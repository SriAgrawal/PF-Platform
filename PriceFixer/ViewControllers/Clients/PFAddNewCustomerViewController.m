//
//  PFAddNewCustomerViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 16/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFAddNewCustomerViewController.h"
#import "PFEditClientViewController.h"
#import "PFBuildQuoteVC.h"
#import "PFClientModelInfo.h"
#import "PFUtility.h"
#import "Macro.h"
#import "TextField.h"

@interface PFAddNewCustomerViewController ()<UITableViewDelegate,UITableViewDataSource, PFBuildQuoteVCDelegate> {
    
    BOOL                isAnimated;
    NSMutableArray *shopArray;
    UITableView *shopListTableView;
    PFClientModelInfo *clientInfo;


}

@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet TextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet TextField *emailTextField;
@property (weak, nonatomic) IBOutlet TextField *phoneTextField;
@property (weak, nonatomic) IBOutlet TextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *logOutView;

@end

@implementation PFAddNewCustomerViewController

#pragma mark -

#pragma mark - View controller life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}


#pragma mark * * * DELEGATE METHOD * * *
-(void)dismissControllerWith:(NSString *)quoteID
{
    PFQuotesBuildViewController *vc = [[PFQuotesBuildViewController alloc]initWithNibName:@"PFQuotesBuildViewController" bundle:nil];
    vc.strQuoteId = quoteID;
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:vc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}



#pragma mark - Initial Method

- (void)initialSetup {
    
    
    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    shopArray = [NSMutableArray array];
    
    shopListTableView=[[UITableView alloc]initWithFrame:CGRectMake(48, 155, windowWidth-96, 100) style:UITableViewStylePlain];
    shopListTableView.dataSource = self;
    shopListTableView.delegate   = self;
    [self.view addSubview:shopListTableView];
    
    shopListTableView.layer.cornerRadius = 6;
    shopListTableView.layer.masksToBounds = YES;
    shopListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shopListTableView.hidden=YES;

    clientInfo = [[PFClientModelInfo alloc] init];

    // Set logout view
    self.logOutView.hidden = YES;
    [self.logOutViewHeightConstraint setConstant:0];
    
    [self callToGetShopListServiceIntegration];
}


#pragma mark -

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark

#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return shopArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    clientInfo = [shopArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = clientInfo.shopName;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    shopListTableView.hidden=YES;
    clientInfo = [shopArray objectAtIndex:indexPath.row];
    self.shopNameTextField.text = clientInfo.shopName;
}



#pragma mark -

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (str.length > 20 && (textField.tag == 100 || textField.tag == 101))
        return NO;
    else if (str.length > 45 && textField.tag == 102)
        return NO;
    else if (str.length > 14 && textField.tag == 103)
        return NO;
    //**************************
    
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
    
    
    
    //***************************
    
    
    else if ((str.length > 20 || !stringIsValid) && textField.tag == 300)
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
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        UITextField *txtField = [self.view viewWithTag:textField.tag+1];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

#pragma mark -

#pragma mark - UITouch Method

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    shopListTableView.hidden = YES;
}



#pragma mark -

#pragma mark - Selector Method

-(void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}

#pragma mark -

#pragma mark - UIButton ACtion

- (IBAction)signOutButtonAction:(id)sender {
    
    [UIView transitionWithView:self.view duration:0.1 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if (isAnimated == NO) {
                            isAnimated = YES;
                            [self.logOutViewHeightConstraint setConstant:69];
                            [self.logOutView setHidden:NO];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }else{
                            isAnimated = NO;
                            [self.logOutViewHeightConstraint setConstant:0];
                            [self.logOutView setHidden:YES];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }
                    }
                    completion:^(BOOL finished) {
                    }];
}

- (IBAction)createNewUserButtonAction:(id)sender {
    
}

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    

}

- (IBAction)logoutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
    
}

- (IBAction)createUserButtonAction:(id)sender {
 
    if ([self isValidate]) {
        
        [self callToAddNewCustomerServiceIntegration];
    }
}

- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];

}

- (IBAction)buildQuotesButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if (!self.zipCodeTextField.text.length) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (self.zipCodeTextField.text.length < 4) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
    }
    else {
        
        PFBuildQuoteVC *objVC = [[PFBuildQuoteVC alloc]initWithNibName:@"PFBuildQuoteVC" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.zipCode = self.zipCodeTextField.text;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }

}
- (IBAction)shopNameButtonAction:(id)sender {
    
    shopListTableView.hidden = !shopListTableView.hidden;
}

#pragma mark -

#pragma mark - Validation Method

-(BOOL)isValidate {
    
    if (!self.shopNameTextField.text.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select shop name." onController:self];
    }
    else
        if (!self.firstNameTextField.text.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter first name." onController:self];
    }
    else if (!self.lastNameTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter last name." onController:self];
    }
    else if (!self.emailTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter email." onController:self];
    }
    else if ([PFUtility validateEmailAddress:self.emailTextField.text]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid email." onController:self];
    }
    else if (!self.phoneTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter phone number." onController:self];
    }
    else if (self.phoneTextField.text.length<10){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid phone number." onController:self];
    }
    else{
        return YES;
    }
    return NO;
}


#pragma mark

#pragma mark - Service Helper Method


- (void)callToAddNewCustomerServiceIntegration {
    
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  
     [dict setValue:@"addCustomer"forKey:@"action"];
     [dict setValue:self.firstNameTextField.text forKey:kFirst_name];
     [dict setValue:self.lastNameTextField.text forKey:kLast_name];
     [dict setValue:self.emailTextField.text forKey:kEmail];
     [dict setValue:self.phoneTextField.text forKey:kPhoneNumber];
     [dict setValue:[NSUSERDEFAULTS valueForKey:kShop_id] forKey:kShop_id];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
    
        if (suceeded) {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
             NSDictionary *customerList = [response objectForKeyNotNull:@"data" expectedClass:[NSDictionary class]];
             
            clientInfo = [PFClientModelInfo modelCustomerListDict:customerList];
             PFEditClientViewController *editVC = [[PFEditClientViewController alloc]initWithNibName:@"PFEditClientViewController" bundle:nil];
             editVC.clientInfo = clientInfo;
             [self.navigationController pushViewController:editVC animated:YES];
      }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
  }];
}


- (void)callToGetShopListServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"getShopList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kUserId] forKey:kAppUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            NSArray *tempArray = [response objectForKeyNotNull:@"shopList" expectedClass:[NSArray class]];

            for (NSDictionary *shopDict in tempArray) {
                
                [shopArray addObject:[PFClientModelInfo modelShopList:shopDict]];
            }
            [shopListTableView reloadData];
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
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            [APPDELEGATE  navigateToLoginVC];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

@end
