//
//  PFRepairViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 20/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFRepairViewController.h"
#import "PFRepairTableViewCell.h"
#import "editAppointmentViewController.h"
#import "Macro.h"

static NSString * cellIdentifier = @"repairId";

@interface PFRepairViewController ()<UITableViewDelegate,UITableViewDataSource,editAppointmentProtocol,changeAgreeMentProtocol,communicationProtocol,editAddressProtocol, PFBuildQuoteVCDelegate>
{
    BOOL isAnimated;
    NSMutableArray *repairArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutViewHeightConstant;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;

@end

@implementation PFRepairViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialMethod];
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
- (void)initialMethod {

    self.navigationController.navigationBarHidden = YES;

    // Register TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"PFRepairTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

    // Alloc Array
    repairArray = [NSMutableArray array];

    // Set UserImage
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];

    self.logOutView.hidden = YES;

    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;

    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];

    [self callGetRepairServiceIntegration];
}

#pragma mark - UITableView Delegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return repairArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFRepairTableViewCell * cell = (PFRepairTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PFInstallModel *repairInfo = [repairArray objectAtIndex:indexPath.row];
    
    PFInstallModel *repairItemInfo = [repairInfo.arrayItems firstObject];

    cell.orderPlacedLabel.text = [NSString stringWithFormat:@"%@ %@",repairInfo.title1,repairInfo.strOrderPlaceDate];
    cell.appointmentTopLabel.text = [NSString stringWithFormat:@"%@ %@",repairInfo.title2,repairInfo.strAppointmentDate];
    cell.inRouteLabel.text = [NSString stringWithFormat:@"%@",repairInfo.title3];
    cell.arrivedLabel.text = [NSString stringWithFormat:@"%@",repairInfo.title4];
    cell.completeLabel.text = [NSString stringWithFormat:@"%@",repairInfo.title5];

    cell.installationDateLabel.text = [NSString stringWithFormat:@"%@",repairInfo.strAptDate];
    cell.clientNameLabel.text = [NSString stringWithFormat:@"%@",repairInfo.strShippingName];
    cell.clientMobileNumberLabel.text = [NSString stringWithFormat:@"%@",repairInfo.strShippingPhone];
    cell.clientAddressLabel.text = [NSString stringWithFormat:@"%@",repairInfo.strShippingAddress1];
    cell.currentStatusLabel.text = [NSString stringWithFormat:@"%@",repairInfo.strCurrentStatus];
    cell.contractLabel.text = [NSString stringWithFormat:@"%@",repairInfo.strOrderCode];

    cell.repairInfo = repairItemInfo;

    //For Top view
    cell.inRouteButton.userInteractionEnabled = YES;
    cell.arrivedbutton.userInteractionEnabled = YES;
    cell.completeButton.userInteractionEnabled = YES;

    if([repairInfo.titleTwoComplete isEqualToString:@" completed"])
    {
        cell.approvedLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
        [cell.editAppointMentButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
    }
    else {
        cell.approvedLabel.backgroundColor = [UIColor whiteColor];
        [cell.editAppointMentButton setImage:[UIImage imageNamed:@"delivery_icon"] forState:UIControlStateNormal];
    }
    
    if([repairInfo.titleThreeComplete isEqualToString:@" completed"])
    {
        cell.inRouteButton.userInteractionEnabled = NO;
        cell.appointmentLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
        [cell.inRouteButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
    }
    else {
        cell.appointmentLabel.backgroundColor = [UIColor whiteColor];
        [cell.inRouteButton setImage:[UIImage imageNamed:@"delivery_icon"] forState:UIControlStateNormal];
    }
    
    if([repairInfo.titleFourComplete isEqualToString:@" completed"])
    {
        cell.arrivedbutton.userInteractionEnabled = NO;
        cell.inRouteTopLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
        [cell.arrivedbutton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
    }
    else {
        cell.inRouteTopLabel.backgroundColor = [UIColor whiteColor];
        [cell.arrivedbutton setImage:[UIImage imageNamed:@"delivery_icon"] forState:UIControlStateNormal];
    }
    
    if([repairInfo.strIsReviewInstall isEqualToString:@" completed"])
    {
        cell.completeButton.userInteractionEnabled = NO;
        cell.arrivedTopLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
        [cell.completeButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
    }
    else {
        cell.arrivedTopLabel.backgroundColor = [UIColor whiteColor];
        [cell.completeButton setImage:[UIImage imageNamed:@"delivery_icon"] forState:UIControlStateNormal];
    }
 
    
    // Set Button Tag
    cell.installEditButton.tag = indexPath.row + 100;
    cell.clientEditButton.tag = indexPath.row + 300;
    cell.currentStatusEditButton.tag = indexPath.row + 500;
    cell.contractIdEditButton.tag = indexPath.row + 700;
    cell.communicationEditButton.tag = indexPath.row + 900;

    cell.editAppointMentButton.tag = indexPath.row + 1100;
    cell.inRouteButton.tag = indexPath.row + 1300;
    cell.arrivedbutton.tag = indexPath.row + 1300;
    cell.completeButton.tag = indexPath.row + 1300;

    // Set Button Target
    [cell.installEditButton addTarget:self action:@selector(installEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.clientEditButton addTarget:self action:@selector(clientEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.currentStatusEditButton addTarget:self action:@selector(statusEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contractIdEditButton addTarget:self action:@selector(contractEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.communicationEditButton addTarget:self action:@selector(communicationEditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.inRouteButton.textSend = repairInfo.title3;
    cell.arrivedbutton.textSend = repairInfo.title4;
    cell.completeButton.textSend = repairInfo.title5;

    [cell.editAppointMentButton addTarget:self action:@selector(editAppointmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.inRouteButton addTarget:self action:@selector(communicationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.arrivedbutton addTarget:self action:@selector(communicationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.completeButton addTarget:self action:@selector(communicationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 504.0;
}


#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if ((str.length > 20 || !stringIsValid) && textField.tag == 300)
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
- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self.sidePanelController toggleLeftPanel:nil];
}

- (IBAction)signOutButtonAction:(id)sender {
    
    [UIView transitionWithView:self.view duration:0.1 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if (isAnimated == NO) {
                            isAnimated = YES;
                            [self.logoutViewHeightConstant setConstant:69];
                            [self.logOutView setHidden:NO];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }else{
                            isAnimated = NO;
                            [self.logoutViewHeightConstant setConstant:0];
                            [self.logOutView setHidden:YES];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }
                    }
                    completion:^(BOOL finished) {
                    }];
    
}

- (IBAction)changePasswordbuttonAction:(id)sender {
    
    [self hideShowLogoutView];
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)logOutButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0)
        {
            [self callLogoutServiceIntegration];
        }
    }];
    
}

- (IBAction)buildQuoteButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    if (!self.zipCodeTextField.text.length) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (self.zipCodeTextField.text.length < 4) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
    }
    else
    {
        
        [self.view endEditing:YES];
        
        if (!self.zipCodeTextField.text.length) {
            
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
        }
        else if (self.zipCodeTextField.text.length < 4)
        {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
        }
        else
        {
            PFBuildQuoteVC *objVC = [[PFBuildQuoteVC alloc]initWithNibName:@"PFBuildQuoteVC" bundle:nil];
            objVC.providesPresentationContextTransitionStyle = YES;
            objVC.definesPresentationContext = YES;
            objVC.delegate = self;
            objVC.zipCode = self.zipCodeTextField.text;
            [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
    }
}

#pragma mark - Custom Delegate Method
- (void)callTechCheckApi {
    [self callGetRepairServiceIntegration];
}

#pragma mark - Selector Method
- (void)installEditButtonAction:(UIButton *)sender {
    
    PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-100];
    obj.strShopId = [NSUSERDEFAULTS valueForKey:kShop_id];
    editAppointmentViewController *objVC = [[editAppointmentViewController alloc]initWithNibName:@"editAppointmentViewController" bundle:nil];
    objVC.objEditDetail = obj;
    objVC.isFromTechCheck = YES;
    objVC.isFromRepair = YES;
    objVC.delegate = self;
    objVC.objEditDetail = obj;
    objVC.strOrderId =obj.strOrderId;
    objVC.strAppoinmentId =obj.strAptId;
    objVC.strScreenIndicator=@"preinspection";
    objVC.isFromTechCheckForEdit = YES;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)clientEditButtonAction:(UIButton *)sender {
    
      PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-300];
    
    ViewController *objVC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    objVC.fromRepair = YES;
    objVC.strOrderId = obj.strOrderId;
    objVC.delegate = self;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
    
}

- (void)statusEditButtonAction:(UIButton *)sender {
    
    PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-500];
    communicationViewController *objVC = [[communicationViewController alloc]initWithNibName:@"communicationViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.fromRepair = YES;
    objVC.delegate = self;
    objVC.strEmployeId = obj.strCustomerId;
    objVC.strCustomerName = obj.strShippingName;
    objVC.strOrderCode = obj.strOrderCode;
    objVC.strCurrentStatus = obj.strCurrentStatus;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
    
}

- (void)contractEditButtonAction:(UIButton *)sender {
    
    PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-700];
    agreementViewController *objVC = [[agreementViewController alloc]initWithNibName:@"agreementViewController" bundle:nil];
    objVC.strOrderCode = obj.strOrderCode;
    objVC.strParentOrderId = obj.strParentOrderId;
    objVC.strParentID = obj.strOrderId;
    objVC.delegate = self;
    objVC.agreementViewType  = repeatAgreementType_ApprovedLabour;
    objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:objVC animated:YES completion:nil];

    
}

- (void)communicationEditButtonAction:(UIButton *)sender {
    
    PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-900];
    
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strEmployeId =obj.strCustomerId;
    objVC.strOrderId =obj.strOrderId;
    objVC.strOrderCode =obj.strOrderCode;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)editAppointmentButtonAction:(UIButton *)sender {
    
    PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-1100];
    editAppointmentViewController *objVC = [[editAppointmentViewController alloc]initWithNibName:@"editAppointmentViewController" bundle:nil];
    objVC.objEditDetail = obj;
    objVC.isFromTechCheck = YES;
    objVC.isFromRepair = YES;
    objVC.delegate = self;
    objVC.strOrderId =obj.strOrderId;
    objVC.strAppoinmentId =obj.strAptId;
    objVC.strScreenIndicator=@"preinspection";
    objVC.isFromTechCheckForEdit = YES;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}


- (void)communicationButtonAction:(PFButton *)sender {
    
    PFInstallModel *obj = [repairArray objectAtIndex:sender.tag-1300];
    communicationViewController *objVC = [[communicationViewController alloc]initWithNibName:@"communicationViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.strCompleteRoute = sender.textSend;
    objVC.fromRepair = YES;
    objVC.delegate = self;
    objVC.strEmployeId = obj.strCustomerId;
    objVC.strCustomerName = obj.strShippingName;
    objVC.strOrderCode = obj.strOrderCode;
    objVC.strCurrentStatus = obj.strCurrentStatus;

    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
    
}



-(void)hideShowLogoutView
{
    isAnimated = NO;
    [self.logoutViewHeightConstant setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}


#pragma mark - Service Helper Method
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


-(void)callGetRepairServiceIntegration
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"repairList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                [repairArray removeAllObjects];
                
                NSArray *installArray = [response objectForKeyNotNull:@"responseData" expectedClass:[NSArray class]];
                for (NSMutableDictionary *installDict in installArray)
                {
                    PFInstallModel *installInfo = [PFInstallModel modelRepairListDict:installDict];
                    [repairArray addObject:installInfo];
                }
                
                [self.tableView reloadData];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

@end
