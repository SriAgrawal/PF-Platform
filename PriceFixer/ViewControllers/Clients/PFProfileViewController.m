//
//  PFProfileViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 14/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFProfileViewController.h"
#import "PFUtility.h"
#import "TextField.h"
#import "Macro.h"

@interface PFProfileViewController ()

@property (weak, nonatomic) IBOutlet TextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet TextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet TextField *emailTextField;
@property (weak, nonatomic) IBOutlet TextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *emailNewsLetterButton;

@end

@implementation PFProfileViewController


#pragma mark -

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark -

#pragma mark - Initial Method

-(void)initialSetup {
    
    self.firstNameTextField.text = self.clientInfo.first_name;
    self.lastNameTextField.text = self.clientInfo.last_name;
    self.emailTextField.text = self.clientInfo.email;
    self.phoneTextField.text = self.clientInfo.phone;

}

#pragma mark -

#pragma mark - Memory Warning Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length > 30 && (textField.tag == 100 || textField.tag == 101))
        return NO;
    
    else if (str.length > 14 && textField.tag == 103){
        return NO;
    }
    //*****************************
    
   else if (textField.tag == 103) {
    NSString *newString = [_phoneTextField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *decimalString = [components componentsJoinedByString:@""];
    
    NSUInteger length = decimalString.length;
    BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
    
    if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
        textField.text = decimalString;
        return NO;
    }
    
    NSUInteger index = 0;
    NSMutableString *formattedString = [NSMutableString string];

    
    if (length - index > 3) {
        NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"(%@) ",areaCode];
        index += 3;
    }
    
    if (length - index > 3) {
        NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@-",prefix];
        index += 3;
    }
    
    NSString *remainder = [decimalString substringFromIndex:index];
    [formattedString appendString:remainder];
    
    textField.text = formattedString;
    
    return NO;
    
}

    //*****************************
    
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        UITextField *txtField = [self.view viewWithTag:(textField.tag == 101)?textField.tag + 2:textField.tag + 1];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}


#pragma mark -

#pragma mark - UIButton Action
- (IBAction)saveInformationButtonAction:(id)sender {
    
    if (!self.firstNameTextField.text.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter first name." onController:self];
    }
    else if (!self.lastNameTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter last name." onController:self];
    }
    else if (!self.phoneTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter phone number." onController:self];
    }
    else{
        [self callEditInfoServiceIntegration];
    }
}

- (IBAction)resetPasswordButtonAction:(id)sender {
    
    
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to reset password by email?" andButtonsWithTitle:[NSArray arrayWithObjects:@"Cancel",@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 1){
            [self callResetPasswordServiceIntegration];
        }
    }];
    
}

- (IBAction)emailNewsLetterButtonAction:(id)sender {
    
    self.emailNewsLetterButton.selected = !self.emailNewsLetterButton.selected;
}

#pragma mark

#pragma mark - Service Helper Method

- (void)callEditInfoServiceIntegration {
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"updateCustomer"forKey:@"action"];
    [dict setValue:self.firstNameTextField.text forKey:kFirst_name];
    [dict setValue:self.lastNameTextField.text forKey:kLast_name];
    [dict setValue:self.phoneTextField.text forKey:kPhoneNumber];
    [dict setValue:self.clientInfo.customer_id forKey:kCustomer_id];
    [dict setValue:(self.emailNewsLetterButton.selected)?@"1":@"0" forKey:kNewsletter];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
           
            [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

- (void)callResetPasswordServiceIntegration {
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"resetPassword"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kUserId] forKey:kAppUserId];
    [dict setValue:self.clientInfo.customer_id forKey:kCustomer_id];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];

        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
