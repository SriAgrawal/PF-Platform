//
//  PFSendproposalViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 07/04/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFSendproposalViewController.h"
#import "Macro.h"
#import "TextField.h"

@interface PFSendproposalViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;

@end

@implementation PFSendproposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITextfield Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (str.length > 20 || !stringIsValid)
        return NO;
    
    return YES;
}



#pragma mark - UIButton Action

- (IBAction)buildQuoteButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!self.zipCodeTextField.text.length) {
        [PFUtility alertWithTitle:@"" andMessage:Kblankzipcode andController:self];
    }
    else
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate callBuildQuote:self.zipCodeTextField.text];
    }];
    
}

- (IBAction)dismisButtonAction:(id)sender {
    
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
