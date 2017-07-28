//
//  PFEquipmentClaimViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 24/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFEquipmentClaimViewController.h"
#import "Macro.h"

@interface PFEquipmentClaimViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitLabel;

@end

@implementation PFEquipmentClaimViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self callAPIToGetClaimData];
}


#pragma mark - Memory Mangement Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIButton Action
- (IBAction)acceptButtonAction:(id)sender {
    
    [self callAPIToUpdateClaimData];
}

- (IBAction)dismissButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Service Helper Method
- (void)callAPIToGetClaimData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setValue:@"claim" forKey:@"action"];
    [dict setValue:self.orderId forKey:@"order_id"];
    [dict setValue:@"1" forKey:@"is_own"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                NSDictionary *tempDict = [response objectForKeyNotNull:@"responseData" expectedClass:[NSDictionary class]];
                self.titleLabel.text = [tempDict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
                self.equipmentLabel.text = [tempDict objectForKeyNotNull:@"equipment" expectedClass:[NSString class]];
                self.deliveryFeeLabel.text = [tempDict objectForKeyNotNull:@"delivery_fee" expectedClass:[NSString class]];
                self.totalFeeLabel.text = [tempDict objectForKeyNotNull:@"total_deposit" expectedClass:[NSString class]];
                self.seoLabel.text = [tempDict objectForKeyNotNull:@"seo" expectedClass:[NSString class]];
                self.rebateLabel.text = [tempDict objectForKeyNotNull:@"rebate" expectedClass:[NSString class]];
                self.benefitLabel.text = [tempDict objectForKeyNotNull:@"benefit" expectedClass:[NSString class]];
               
            }
            else {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

- (void)callAPIToUpdateClaimData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"claimEquipmentOrder" forKey:@"action"];
    [dict setValue:self.orderId forKey:@"order_id"];
    [dict setValue:@"1" forKey:@"is_own"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate callTechCheckApi];
                }];
                
            }
            else {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



@end
