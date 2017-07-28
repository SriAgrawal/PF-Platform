//
//  PFWalkThroughSignatureViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 27/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFWalkThroughSignatureViewController.h"
#import "SignatureView.h"
#import "Macro.h"

@interface PFWalkThroughSignatureViewController ()
@property (weak, nonatomic) IBOutlet SignatureView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PFWalkThroughSignatureViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.fromEquipment) 
        self.titleLabel.text = @"Equipment has been received in accordance with packing list";
    else
        self.titleLabel.text = @"Walkthrough completed and installation completed";
}


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIButton Action

- (IBAction)clearButtonAction:(id)sender {
    
    [self.inputView erase];
}

- (IBAction)uploadButtonAction:(id)sender {
    
    // code for save the signature
    UIGraphicsBeginImageContext(self.inputView.frame.size);
    [[self.inputView.layer presentationLayer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (self.inputView.drawImage.image != nil) {
        [self callAddWalkthroughPicListServiceIntegration:viewImage];
    }
    else {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please set your signature." onController:self];
    }
}

- (IBAction)dismissButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Service Helper Method

- (void) callAddWalkthroughPicListServiceIntegration:(UIImage*)image {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"uploadEquipmentOrderSignedImage"forKey:@"action"];
    [dict setValue:self.orderId forKey:@"order_id"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [[ServiceHelper_AF3 instance]makeMultipartWebApiCallWithParameters:dict AndPath:@"" andData:imageData mediaType:0 WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate callTechCheckApi];
        }];
        
    } andProgresscompletion:^(double fractionCompleted) {
        
    }];
}


@end
