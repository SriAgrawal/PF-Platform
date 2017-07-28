//
//  agreementTextViewController.m
//  PriceFixer
//
//  Created by Ashish Kumar Gupta on 05/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "agreementTextViewController.h"

@interface agreementTextViewController ()
@end

@implementation agreementTextViewController
@synthesize agreementTextString;

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    orderCodeAgreementLabel.text=[[self.strOrderCode stringByAppendingString:@" "]stringByAppendingString:@"Agreement"];
    
    
    textViewAgreement.editable=NO;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[agreementTextString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:14.0]
                  range:NSMakeRange(0, attributedString.length)];
    textViewAgreement.attributedText = attributedString;
    
    agreementView.layer.cornerRadius = 8;
    agreementView.layer.masksToBounds = YES;
}
#pragma mark -

#pragma mark - IB Actions
- (IBAction)closeBtnAction:(UIButton *)sender{
    [self.view removeFromSuperview];
}
#pragma mark -

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -




@end
