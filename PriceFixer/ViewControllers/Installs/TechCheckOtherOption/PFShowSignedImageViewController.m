//
//  PFShowSignedImageViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 15/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFShowSignedImageViewController.h"
#import "Macro.h"

@interface PFShowSignedImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PFShowSignedImageViewController


#pragma mark - UIView LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Image On ImageView
    [self.imageView setImageWithURL:[NSURL URLWithString:self.imageString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIButton Action

- (IBAction)dismissButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
