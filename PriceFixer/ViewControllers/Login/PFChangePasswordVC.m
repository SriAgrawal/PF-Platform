//
//  PFChangePasswordVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFChangePasswordVC.h"

static NSString * cellIdentifier = @"PFResetPasswordCell";

@interface PFChangePasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UserInfo *modalObject;
}
@property (weak, nonatomic) IBOutlet UITableView *forgotPasswordTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;

@end

@implementation PFChangePasswordVC

#pragma mark - View Life Cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setUpDefaults];
}
#pragma mark -

#pragma mark - Memory Management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

#pragma mark - Helper method

-(void)setUpDefaults{
    
    modalObject = [[UserInfo alloc]init];
    
    [_forgotPasswordTableView registerNib:[UINib nibWithNibName:@"PFResetPasswordCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.forgotPasswordTableView.layer.borderColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1.f].CGColor;
    self.forgotPasswordTableView.layer.borderWidth = 1.0f;
    self.forgotPasswordTableView.layer.masksToBounds = YES;
    self.forgotPasswordTableView.tableHeaderView = _headerView;
    self.forgotPasswordTableView.tableFooterView = _footerView;
    self.changePasswordButton.layer.cornerRadius = self.changePasswordButton.frame.size.height/2;
    self.changePasswordButton.layer.borderWidth = 1.0f;
    self.changePasswordButton.layer.borderColor = KAppBorderColor.CGColor;
    self.changePasswordButton.layer.masksToBounds = YES;
    
}
#pragma mark -

#pragma mark - IBOutlet Button actions
- (IBAction)changePasswordButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([self isFieldVerified ]) {
        [self callResetPasswordServiceIntegration];
    }

}

- (IBAction)menuButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.sidePanelController toggleLeftPanel:nil];
}

- (IBAction)navBtnQueryAction:(UIButton *)sender {
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress" onController:self];
}

- (IBAction)navBtnAction:(UIButton *)sender {
    
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress" onController:self];
    
}
- (IBAction)btnNavLogoutAction:(UIButton *)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if(index == 0){
            
            [self callLogoutServiceIntegration];
        }
    }];
}


#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFResetPasswordCell * cell = (PFResetPasswordCell *)[self.forgotPasswordTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.cellTextField.tag = indexPath.row + 100;
    cell.cellTextField.returnKeyType = UIReturnKeyNext;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.cellTextField.delegate = self;
    
    
    switch (indexPath.row) {
        case 0:
            cell.cellTextField.placeholder = @"Old Password";
            cell.cellTextField.secureTextEntry = YES;
            cell.cellTextField.text = modalObject.strOldPassword;
            cell.cellTitleLabel.text = @"Old Password";
            break;
            
        case 1:
            cell.cellTextField.placeholder = @"New Password";
            cell.cellTextField.secureTextEntry = YES;
            cell.cellTextField.text = modalObject.strNewPassword;
            cell.cellTitleLabel.text = @"New Password";
            break;
            
        case 2:
            cell.cellTextField.placeholder = @"Confirm Password";
            cell.cellTextField.secureTextEntry = YES;
            cell.cellTextField.text = modalObject.strConfirmPassword;
            cell.cellTitleLabel.text = @"Confirm Password";
            cell.cellTextField.returnKeyType = UIReturnKeyDone;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0f;
}
#pragma mark -

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case 100:
            modalObject.strOldPassword = TRIM_SPACE(textField.text);
            break;
            
        case 101:
            modalObject.strNewPassword = TRIM_SPACE(textField.text);
            break;
            
        case 102:
            modalObject.strConfirmPassword = TRIM_SPACE(textField.text);
            break;
        default:
            break;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType == UIReturnKeyNext) {
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if((textField. text.length >= 12 && range.length == 0))
        return NO;
    else
        return YES;
    
}
#pragma mark -

#pragma mark - Validate method -

-(BOOL)isFieldVerified {
    BOOL isVerified = NO;
    
    if(modalObject.strOldPassword.length == 0)
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@" Enter old password." onController:self];

    
    else if(modalObject.strNewPassword.length == 0)
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Enter new password." onController:self];
    
    
    else if(modalObject.strConfirmPassword.length == 0)
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Enter confirm password." onController:self];
    
    else if(![modalObject.strNewPassword isEqualToString:modalObject.strConfirmPassword])
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Password not matched." onController:self];
    
    else
        isVerified = YES;
    return isVerified;
}
#pragma mark -


#pragma mark - Service Helper Method
-(void)callResetPasswordServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"changePasswords"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:modalObject.strNewPassword forKey:@"newPass"];
    [dict setValue:modalObject.strOldPassword forKey:@"oldPass"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Password changed successfully." onController:self];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


-(void)callLogoutServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"userLogout"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:@"ios" forKey:@"deviceType"];
    if ([NSUSERDEFAULTS objectForKey:kDeviceToken] == nil) {
        [dict setValue:@"" forKey:@"deviceToken"];
    }else{
        [dict setValue:[NSUSERDEFAULTS objectForKey:kDeviceToken] forKey:@"deviceToken"];
    }
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            
            [[APPDELEGATE navController] popToRootViewControllerAnimated:YES];
            
        }
    }];
}


#pragma mark -

@end
