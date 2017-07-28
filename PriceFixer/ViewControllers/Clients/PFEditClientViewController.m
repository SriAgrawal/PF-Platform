//
//  PFEditClientViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 13/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFEditClientViewController.h"
#import "TextField.h"
#import "PFProfileViewController.h"
#import "PFBillingViewController.h"
#import "PFCommunicationViewController.h"
#import "PFBuildQuoteVC.h"
#import "PFUtility.h"
#import "Macro.h"

@interface PFEditClientViewController ()<clientOrderProtocol, PFBuildQuoteVCDelegate> {
    BOOL                isAnimated;
    PFProfileViewController *profileVC;
    PFBillingViewController *billingVC;
    PFClientOrderViewController *orderVC;
    PFCommunicationViewController *PFCommunicationVC;
    NSInteger orderViewheight;

    
}

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *systemButton;
@property (weak, nonatomic) IBOutlet UIButton *maintenanceButton;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *billingButton;
@property (weak, nonatomic) IBOutlet UIButton *communicationButton;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation PFEditClientViewController


#pragma mark -

#pragma mark - Initial method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialMethod];
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



#pragma mark - Initial method

- (void)initialMethod {
    
    // Alloc Controller
    profileVC = [[PFProfileViewController alloc]initWithNibName:@"PFProfileViewController" bundle:nil];
    profileVC.clientInfo = self.clientInfo;

    billingVC = [[PFBillingViewController alloc]initWithNibName:@"PFBillingViewController" bundle:nil];
    billingVC.billInfo = self.clientInfo;

    PFCommunicationVC = [[PFCommunicationViewController alloc]initWithNibName:@"PFCommunicationViewController" bundle:nil];
    PFCommunicationVC.clientInfo = self.clientInfo;

    orderVC = [[PFClientOrderViewController alloc]initWithNibName:@"PFClientOrderViewController" bundle:nil];
    orderVC.orderInfo = self.clientInfo;
    orderVC.delegate = self;
    
    _timeLabel.text = [NSString stringWithFormat:@"Customer Since %@",[self convertDate:_clientInfo.registered_on]];
    // Set logout view
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];

    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;

    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];

    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];

    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.clientInfo.first_name,self.clientInfo.first_name];
    self.locationLabel.text = self.clientInfo.address;

    [self displayController:profileVC];
    [self restoreButtonState];
    self.profileButton.backgroundColor = KBtnSelectedColor;
}

#pragma mark - * * * HELPER METHOD * * * 
-(NSString *)convertDate:(NSString *)strDate{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormat dateFromString:strDate];
    
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    return dateStr;
}

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

#pragma mark - Selector Method
- (void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}

#pragma mark -

#pragma mark - Custom Delegate Method
-(void)setViewHeight:(NSInteger)height {
    
    orderViewheight = height;
    if (height == 0) {
        self.mainView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    else {
        self.mainView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.8] CGColor];
    }
}

#pragma mark -

#pragma mark - Other methods
- (void)displayController:(UIViewController *)viewController {
    
    [self replaceCurrentVCWithVC:viewController];
}

- (void)replaceCurrentVCWithVC:(UIViewController *)newVC {
    
    [newVC willMoveToParentViewController:nil];
    [newVC.view removeFromSuperview];
    [newVC removeFromParentViewController];
    [self addChildViewController:  newVC];
    [self.mainView addSubview:newVC.view];
    newVC.view.frame = self.mainView.bounds;
    [newVC didMoveToParentViewController:self];
}

- (void)restoreButtonState
{
    self.profileButton.backgroundColor = KAppGreenColor;
    self.systemButton.backgroundColor = KAppGreenColor;
    self.maintenanceButton.backgroundColor = KAppGreenColor;
    self.orderButton.backgroundColor = KAppGreenColor;
    self.billingButton.backgroundColor = KAppGreenColor;
    self.communicationButton.backgroundColor = KAppGreenColor;
    self.cartButton.backgroundColor = KAppGreenColor;
}


#pragma mark -

#pragma mark - UITextField Delegate      
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
     if (str.length > 20 || !stringIsValid)
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


#pragma mark -

#pragma mark - UITouch Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark -

#pragma mark - UIButton Action
- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    //  [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}


- (IBAction)signOutButtonAction:(id)sender {
    
    [self.view endEditing:YES];
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

- (IBAction)buildQuoteButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    
    if (!self.zipCodeTextField.text.length) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (self.zipCodeTextField.text.length < 4) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
    }
    else {
        
        [self hideShowLogoutView];
        
        if (!self.zipCodeTextField.text.length) {
            
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
        }
        else if (self.zipCodeTextField.text.length < 4) {
            
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
        }
        else {
            
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
                objVC.zipCode = self.zipCodeTextField.text;
                objVC.delegate = self;
                [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                [self.navigationController presentViewController:objVC animated:NO completion:nil];
            }
        }
    }
    
}

- (IBAction)profileButtonAction:(id)sender {

    self.mainView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.8] CGColor];
    
    [self.view endEditing:YES];
    [self displayController:profileVC];
    [self restoreButtonState];
    self.profileButton.backgroundColor = KBtnSelectedColor;
}

- (IBAction)systemButtonAction:(id)sender {
    
}

- (IBAction)maintenanceButtonAction:(id)sender {
    
}

- (IBAction)orderButtonAction:(id)sender
{
    if (orderViewheight == 0) {
        self.mainView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    else {
        self.mainView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.8] CGColor];
    }
    [self.view endEditing:YES];
    [self displayController:orderVC];
    [self restoreButtonState];
    self.orderButton.backgroundColor = KBtnSelectedColor;
}

- (IBAction)billingButtonAction:(id)sender {
    
    self.mainView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.8] CGColor];
    
    [self.view endEditing:YES];
    [self displayController:billingVC];
    [self restoreButtonState];
    self.billingButton.backgroundColor = KBtnSelectedColor;
}

- (IBAction)communicationButtonAction:(id)sender {

    self.mainView.layer.borderColor = [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.8] CGColor];

    [self.view endEditing:YES];
    [self displayController:PFCommunicationVC];
    [self restoreButtonState];
    self.communicationButton.backgroundColor = KBtnSelectedColor;
}

- (IBAction)cartButtonAction:(id)sender {
    
}

- (IBAction)messageButtonAction:(id)sender {
 
}

- (IBAction)mapButtonAction:(id)sender {
    
}

- (IBAction)invoiceButtonAction:(id)sender {
    
}

- (IBAction)paymentButtonAction:(id)sender {
    
}

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)logOutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}

#pragma mark

#pragma mark - Service Helper Method
- (void)callLogoutServiceIntegration {
    
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
