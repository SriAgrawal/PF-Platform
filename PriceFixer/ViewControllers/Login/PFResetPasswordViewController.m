//
//  PFResetPasswordViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 13/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFResetPasswordViewController.h"
#import "TextField.h"
#import "PFUtility.h"
#import "Macro.h"

@interface PFResetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TextField *emailTextField;

@end

@implementation PFResetPasswordViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length > 60)
        return NO;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - UIButton Action

- (IBAction)backButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)resetPasswordButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (![TRIM_SPACE(self.emailTextField.text) length]) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter email." onController:self];
    }
    else if ([PFUtility validateEmailAddress:self.emailTextField.text]){

        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid email." onController:self];
    }
    else{

            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@""forKey:@"action"];
            [dict setValue:@"ios" forKey:@"deviceType"];
            [dict setValue:self.emailTextField.text forKey:@""];
        
            if ([NSUSERDEFAULTS objectForKey:kDeviceToken] == nil)
            {
                [dict setValue:@"" forKey:@"deviceToken"];
                
            }else
                [dict setValue:[NSUSERDEFAULTS objectForKey:kDeviceToken] forKey:@"deviceToken"];
            
            
            [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
                
                if (suceeded) {
                }
                else
                {
                    [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
                }
            }];
    }
}

@end
