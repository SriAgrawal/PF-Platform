//
//  PFViewSignedViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 02/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFViewSignedViewController.h"
#import "Macro.h"

@interface PFViewSignedViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PFViewSignedViewController


#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:self.signedImageView] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIButton Action

- (IBAction)dismissButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
