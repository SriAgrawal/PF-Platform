//
//  PFInstallVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFInstallVC.h"
#import "Macro.h"

static NSString * cellIdentifier = @"PFInstallCell";
static NSString * PFInstallsMainCell = @"PFInstallsMainTVC";

@interface PFInstallVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate, orderDelegate,deleteEquipmentProtocol,addEquipmentProtocol,specialHourProtocol,setTechCheckProtocol,editAppointmentProtocol,changeAgreeMentProtocol,changeAddHourProtocol,communicationProtocol,createAppointmentEquipmentProtocol,claimEquipmentProtocol,warehouseEquipmentProtocol,processReturnEquipmentProtocol,walkThroughProtocol, PFBuildQuoteVCDelegate,editAddressProtocol> {
    
    NSString *imageName;
    NSInteger indexForWalkThrough;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *installTableView;
@property (strong, nonatomic) IBOutlet UIView *logOutView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoutViewHeightConstant;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (strong, nonatomic) UIImage *uploadImage;



- (IBAction)btnBuildAction:(id)sender;

@end

@implementation PFInstallVC

#pragma mark - View Controller life cycle method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refershInstallList:)
                                                 name:@"refershInstallList" object:nil];
    // Set UserImage
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    
    self.logOutView.hidden = YES;
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    
    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    [self.installTableView registerNib:[UINib nibWithNibName:@"PFInstallsMainTVC" bundle:nil] forCellReuseIdentifier:PFInstallsMainCell];
    installListArray = [[NSMutableArray alloc] init];
    if(self.viewType == RepeatViewType_TypeCheck)
    {
        self.lblTitle.text = @"TechCheck";
    }
    else if (self.viewType == RepeatViewType_Install)
    {
        self.lblTitle.text = @"Installs";
    }
    else if (self.viewType == RepeatViewType_Equipment)
    {
        self.lblTitle.text = @"Equipment";
    }
    else if (self.viewType == RepeatViewType_Repair)
    {
        self.lblTitle.text = @"Repairs";
    }
    self.installTableView.estimatedRowHeight = 600;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    AppDelegate * appDelegate = APPDELEGATE;
    appDelegate.signatureViewTappedIndicator=@"no";

    if(self.viewType == RepeatViewType_TypeCheck || self.viewType == RepeatViewType_Install || self.viewType == RepeatViewType_Equipment || self.viewType == RepeatViewType_Repair){
        [self callAPIForTechCheck];
    }
}

#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [installListArray count];
  //  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFInstallModel *obj = [installListArray objectAtIndex:indexPath.row];
    PFInstallsMainTVC * cell = (PFInstallsMainTVC *)[self.installTableView dequeueReusableCellWithIdentifier:PFInstallsMainCell];
    
    cell.tblViewTV.alwaysBounceVertical = NO;
    
    cell.btnEditFV.tag = indexPath.row + 500;
    cell.lblInstallationNoSV.text = obj.strTotalQty;
    cell.equipmentTopView.hidden = YES;

    if(self.viewType == RepeatViewType_Install){
        cell.fromInstall = YES;
        
        [cell.btnApproved setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal] ;
        [cell.btnInstallDate setImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal] ;
        [cell.btnInRoute setImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal] ;
        [cell.btnComplete setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal] ;
        [cell.btnWalkThrough setImage:[UIImage imageNamed:@"walkthrough"] forState:UIControlStateNormal] ;
    }

    if (self.viewType == RepeatViewType_Equipment) {
        
        cell.equipmentTopView.hidden = NO;
        cell.installCustomerLabel.hidden = YES;
        cell.labourCustomerLabel.hidden = YES;
        cell.lblInstallationFV.hidden = YES;
        cell.lblLabourFV.hidden = YES;
        cell.taxesTopConstraint.constant = 1.0;
        cell.customerViewheightConstraint.constant = 280.0;
        cell.lblInstallationNoSV.hidden = YES;
        cell.installationStaticLabel.hidden = YES;
        [cell.lblPermitFeeF setHidden:YES];
        [cell.lblPermitFeeFV setHidden:YES];

        
        //For Top view
        if([obj.strIsSetTechCheck isEqualToString:@" completed"])
        {
            cell.orderProgressLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.fullfillmentButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.orderProgressLabel.backgroundColor = [UIColor whiteColor];
            [cell.fullfillmentButton setImage:[UIImage imageNamed:@"FullFillment"] forState:UIControlStateNormal];
        }
        
        if([obj.strIsInRoute isEqualToString:@" completed"])
        {
            cell.fullfilmentProgressLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.setDeliveryButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.fullfilmentProgressLabel.backgroundColor = [UIColor whiteColor];
            [cell.setDeliveryButton setImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal];
        }
        
        if([obj.strIsReviewEq isEqualToString:@" completed"])
        {
            cell.setdeliverProgressLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.deliveryButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.setdeliverProgressLabel.backgroundColor = [UIColor whiteColor];
            [cell.deliveryButton setImage:[UIImage imageNamed:@"icon6"] forState:UIControlStateNormal];
        }
        
        if([obj.strIsReviewInstall isEqualToString:@" completed"])
        {
            cell.deliveryProgressLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.returnButton setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.deliveryProgressLabel.backgroundColor = [UIColor whiteColor];
            [cell.returnButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        }
        
        if ([obj.strIsSetTechCheck isEqualToString:@""] && [obj.strIsInRoute isEqualToString:@""] && [obj.strIsReviewEq isEqualToString:@""] && [obj.strIsReviewInstall isEqualToString:@""]) {
            
            cell.orderProgressLabel.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
        }
        
        cell.equipmentOrderPlaceLabel.text    = [NSString stringWithFormat:@"%@\n%@",obj.title1,obj.strOrderPlaceDate];
        cell.equipmentFullfilmentLabel.text     = [NSString stringWithFormat:@"%@\n%@",obj.title2,obj.strIsSetTechCheckDate] ;
        cell.equipmentSetDeliveryLabel.text   = [NSString stringWithFormat:@"%@\n%@",obj.title3,obj.strInRoute] ;
        cell.equipmentDeliveryLabel.text      = [NSString stringWithFormat:@"%@\n%@",obj.title4,obj.strReviewEqDate] ;
        cell.equipmentReturnLabel.text      = [NSString stringWithFormat:@"%@\n%@",obj.title5,obj.strIsReviewInstallDate] ;
        cell.lblWalkThroughSixth.text   = [NSString stringWithFormat:@"%@\n",obj.title6] ;
    }
    else {
        cell.installCustomerLabel.hidden = NO;
        cell.labourCustomerLabel.hidden = NO;
        cell.lblInstallationFV.hidden = NO;
        cell.lblLabourFV.hidden = NO;
        cell.taxesTopConstraint.constant = 80.0;
        cell.lblInstallationNoSV.hidden = NO;
        cell.installationStaticLabel.hidden = NO;
        //For Top view
        
        if([obj.strIsSetTechCheck isEqualToString:@" completed"])
        {
            cell.lblApproved.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.btnApproved setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.lblApproved.backgroundColor = [UIColor whiteColor];
            if(self.viewType == RepeatViewType_Install)
                [cell.btnApproved setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            else
                [cell.btnApproved setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
        }
        
        if([obj.strIsInRoute isEqualToString:@" completed"])
        {
            cell.lblInstallDate.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.btnInstallDate setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.lblInstallDate.backgroundColor = [UIColor whiteColor];
            if(self.viewType == RepeatViewType_Install)
                [cell.btnInstallDate setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
            else
                [cell.btnInstallDate setImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal];
        }
        
        if([obj.strIsReviewEq isEqualToString:@" completed"])
        {
            cell.lblInRoute.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.btnInRoute setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.lblInRoute.backgroundColor = [UIColor whiteColor];
            if(self.viewType == RepeatViewType_Install || self.viewType == RepeatViewType_Repair)
                [cell.btnInRoute setImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal];
            else
                [cell.btnInRoute setImage:[UIImage imageNamed:@"icon6"] forState:UIControlStateNormal];
        }
        if([obj.strIsReviewInstall isEqualToString:@" completed"])
        {
            cell.lblComplete.backgroundColor = [UIColor colorWithRed:103/255.0f green:170/255.0f blue:52/255.0f alpha:1.0f];
            [cell.btnComplete setImage:[UIImage imageNamed:@"rightCheck"] forState:UIControlStateNormal];
        }
        else {
            cell.lblComplete.backgroundColor = [UIColor whiteColor];
            if(self.viewType == RepeatViewType_Install || self.viewType == RepeatViewType_Repair)
                [cell.btnComplete setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
            else
                [cell.btnComplete setImage:[UIImage imageNamed:@"icon7"] forState:UIControlStateNormal];
        }
        if (self.viewType == RepeatViewType_Repair) {
            [cell.btnWalkThrough setImage:[UIImage imageNamed:@"walkthrough"] forState:UIControlStateNormal] ;
        }
        
        cell.lblOrderPlacedDate.text    = [NSString stringWithFormat:@"%@\n%@",obj.title1,obj.strOrderPlaceDate];
        cell.lblApprovedSecond.text     = [NSString stringWithFormat:@"%@\n%@",obj.title2,obj.strIsSetTechCheckDate] ;
        cell.lblInstallDateThird.text   = [NSString stringWithFormat:@"%@\n%@",obj.title3,obj.strInRoute] ;
        cell.lblInRouteFourth.text      = [NSString stringWithFormat:@"%@\n%@",obj.title4,obj.strReviewEqDate] ;
        cell.lblCompleteFifth.text      = [NSString stringWithFormat:@"%@\n%@",obj.title5,obj.strIsReviewInstallDate] ;
        cell.lblWalkThroughSixth.text   = [NSString stringWithFormat:@"%@\n",obj.title6] ;
    }


    cell.btnApproved.tag = indexPath.row+200;
    cell.btnInstallDate.tag = indexPath.row+200;

    if(self.viewType == RepeatViewType_TypeCheck || self.viewType == RepeatViewType_Repair)
       [cell.btnApproved addTarget:self action:@selector(editAppoinment:) forControlEvents:UIControlEventTouchUpInside];
    else
       [cell.btnInstallDate addTarget:self action:@selector(editAppoinment:) forControlEvents:UIControlEventTouchUpInside];

    cell.orderArray       = obj.arrayItems;
    cell.buttonArray      = obj.arrayButtons;
    cell.mainTableView    = self.installTableView;

    [cell setDelegate:self];
    [cell.tblViewSV reloadData];
    [cell.tblViewTV reloadData];

    cell.lblNameFV.text = obj.strShippingName;
    [cell.lblAddressFV setText:obj.strShippingAddress1];
    [cell.lblPhoneNumberFV setText:obj.strShippingPhone];

    [cell.lblEquipmentFV setText:[NSString stringWithFormat:@"$%@",obj.strEquipmentTotal]];
    
    if (self.viewType == RepeatViewType_Repair) {
        [cell.lblInstallationFV setText:[NSString stringWithFormat:@"$%@",obj.strAnyRepair]];
        [cell.lblLabourFV setText:[NSString stringWithFormat:@"$%@",obj.strParts]];
        cell.installCustomerLabel.text = @"Any Repair";
        cell.labourCustomerLabel.text = @"Parts";
        cell.equipmentClientLabel.hidden = YES;
        cell.lblEquipmentFV.hidden = YES;
    }
    else {
        [cell.lblLabourFV setText:[NSString stringWithFormat:@"$%@",obj.strLabor]];
        [cell.lblInstallationFV setText:[NSString stringWithFormat:@"$%@",obj.strInstallKit]];
    }

    [cell.lblTotalFV setText:[NSString stringWithFormat:@"$%@",obj.strTotal]];
    [cell.lblTaxesFV setText:[NSString stringWithFormat:@"$%@",obj.strTaxes]];
    [cell.lblPermitFeeFV setText:[NSString stringWithFormat:@"$%@",obj.strPermitFee]];
    
    if (self.viewType  == RepeatViewType_TypeCheck) {
        [cell.lblPermitFeeF setHidden:NO];
        [cell.lblPermitFeeFV setHidden:NO];
    }

    [cell.lblOrderIdSV setText:obj.strOrderCode];
    cell.lblTitleTV.text = obj.strActionTitle;
    cell.lblDetailTV.text = obj.strActionDesc;
    [cell.btnEditFV addTarget:self action:@selector(btnEditAction:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - IBActions

-(void)editAppoinment:(UIButton*)sender
{
    [self.view endEditing:YES];
   PFInstallModel *obj = [installListArray objectAtIndex:sender.tag-200];
    editAppointmentViewController *objVC = [[editAppointmentViewController alloc]initWithNibName:@"editAppointmentViewController" bundle:nil];
        objVC.objEditDetail =obj;
        objVC.isFromTechCheck = YES;
        objVC.delegate = self;

        objVC.isFromTechCheckForEdit = YES;
        objVC.strAppoinmentId =obj.strAptId;
        objVC.strOrderId =obj.strOrderId;

    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
    
}


- (IBAction)btnChangePasswordAction:(UIButton *)sender
{
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
- (IBAction)btnNavLogoutAction:(UIButton *)sender
{
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


- (IBAction)btnLogoutAction:(UIButton *)sender
{
    [self hideShowLogoutView];
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0)
        {
            [self callLogoutServiceIntegration];
        }
    }];
}

- (void)productDetailAction:(TAIndexPathButton *)button withEvent:(UIEvent *)event{
    [self hideShowLogoutView];
    
    PFInstallModel *obj = [installListArray objectAtIndex:button.collectionView.tag];
    PFInstallModel *installInfoObj = [obj.arrayItems objectAtIndex:button.indexPath.row];

    PFInstallProductDetailVC *objVC = [[PFInstallProductDetailVC alloc]initWithNibName:@"PFInstallProductDetailVC" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.strProductID = installInfoObj.strProductId;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (IBAction)menuButtonAction:(UIButton *)sender
{
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSidePanel" object:nil];
    [self.view endEditing:YES];
    [self.sidePanelController toggleLeftPanel:nil];
}

- (IBAction)navBtnQueryAction:(UIButton *)sender
{
    [self hideShowLogoutView];
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}

- (IBAction)navBtnAction:(UIButton *)sender
{
    [self hideShowLogoutView];
    
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}


- (void)clickToInstallAction:(UIButton *)button withEvent:(UIEvent *)event
{
    [self hideShowLogoutView];
    
    NSIndexPath * indexPath = [self.installTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.installTableView]];
    PFDispatchModel *obj = [installListArray objectAtIndex:indexPath.row];
    
    createAppointmentViewController *objVC = [[createAppointmentViewController alloc]initWithNibName:@"createAppointmentViewController" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.isFromCreateAppointmentBtn = NO;
    objVC.strAppOrderCode = obj.strOrderCode;
    objVC.strAppCustomerId = obj.strCustomerId;
    objVC.strAppShopId = obj.strShopId;
    objVC.strAppOrderId = obj.strOrderId;
    objVC.strScreenIndicator=@"install";
    
    
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)editAddressBtnAction:(UIButton *)button withEvent:(UIEvent *)event
{
    [self hideShowLogoutView];
    
    NSIndexPath * indexPath = [self.installTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.installTableView]];
    
    PFInstallModel *obj = [installListArray objectAtIndex:indexPath.row];
    
    ViewController *objVC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

 }

- (void)communicationMidAction:(UIButton *)button withEvent:(UIEvent *)event
{
    [self hideShowLogoutView];
    
    NSIndexPath * indexPath = [self.installTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.installTableView]];
    
    PFInstallModel *obj = [installListArray objectAtIndex:indexPath.row];
    
    
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strEmployeId =obj.strCustomerId;
    objVC.strOrderId =obj.strOrderId;
    objVC.strOrderCode =obj.strOrderCode;
    
    
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}
- (void)communicationBtnAction:(UIButton *)button withEvent:(UIEvent *)event
{
   [self hideShowLogoutView];
    
    NSIndexPath * indexPath = [self.installTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.installTableView]];
    
    PFInstallModel *obj = [installListArray objectAtIndex:indexPath.row];

    
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strEmployeId =obj.strCustomerId;
    objVC.strOrderId =obj.strOrderId;
    objVC.strOrderCode =obj.strOrderCode;

    
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

- (void)chatBtnAction:(UIButton *)button withEvent:(UIEvent *)event
{
    [self hideShowLogoutView];
    
    NSIndexPath * indexPath = [self.installTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.installTableView]];
    
    PFInstallModel *obj = [installListArray objectAtIndex:indexPath.row];

    communicationViewController *objVC = [[communicationViewController alloc]initWithNibName:@"communicationViewController" bundle:nil];

    objVC.strEmployeId =obj.strCustomerId;
    objVC.strOrderId =obj.strOrderId;
    objVC.strOrderCode =obj.strOrderCode;
    objVC.strCustomerName =obj.strCustomerName;

    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

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
    
    if (textField.tag == 300)
        textField.layer.borderColor = KHomeTextFieldBorderColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 300) {
        textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -

#pragma mark - ScrollView delegete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *coln = (UICollectionView *)scrollView;
        PFInstallModel *installInfo = [installListArray objectAtIndex:coln.tag];
        installInfo.collectionViewContentOffset = coln.contentOffset;
    }
}
#pragma mark -



#pragma mark - Memory management method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -
    
#pragma mark - Selector method


- (void)btnEditAction :(UIButton *)sender
{
    PFInstallModel *obj = [installListArray objectAtIndex:sender.tag-500];
    ViewController *objVC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.delegate = self;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:objVC animated:NO completion:nil];
}


#pragma mark - DELEGATE METHOD 
-(void)presentProductDetail:(NSString *)productId
{
    PFInstallProductDetailVC *installVC = [[PFInstallProductDetailVC alloc]initWithNibName:@"PFInstallProductDetailVC" bundle:nil];
    installVC.strProductID = productId;
    installVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:installVC animated:NO completion:nil];
}

- (void)callTechCheckApi {
    
    [self callAPIForTechCheck];
}


-(void)buttonClick:(NSInteger)indexes btnTitle:(NSString *)title {
    
    [self hideShowLogoutView];
    [self.view endEditing:YES];

    if ([title isEqualToString:@"In Route"] || [title isEqualToString:@"Arrived"]) {
       
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to perform this action?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if(index == 0)
            {
                [self callAPIForArrived:indexes];
            }
        }];
    }
    else if ([title isEqualToString:@"Messages"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        
        communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
        objVC.strEmployeId =obj.strCustomerId;
        objVC.strOrderId =obj.strOrderId;
        objVC.strOrderCode =obj.strOrderCode;
        
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];

    }
    else if ([title isEqualToString:@"Delete"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];

        PFDeleteEquipmentViewController *objVC = [[PFDeleteEquipmentViewController alloc]initWithNibName:@"PFDeleteEquipmentViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.installModel = obj;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Cancel & Refund"]) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to cancel this order?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if(index == 0)
            {
                [self callAPIForCancelAndRedund:indexes];
            }
        }];
    }
    else if ([title isEqualToString:@"Email and Text"]) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to perform this action?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if(index == 0)
            {
                [self callAPIForEmailAndText:indexes];
            }
        }];
    }
    else if ([title isEqualToString:@"Un-repairable"]) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to perform this action?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if(index == 0)
            {
                [self callAPIForUnrepairable:indexes];
            }
        }];
    }

    else if ([title isEqualToString:@"Add"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFAddEquipmentVC *aa = [[PFAddEquipmentVC alloc] initWithNibName:@"PFAddEquipmentVC" bundle:nil];
        aa.modelInstall = obj;
        aa.delegate = self;
        aa.fromAddPart = NO;
        aa.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [aa setPreferredContentSize:CGSizeMake(800, 600)];
        [self presentViewController:aa animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"Add Part"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFAddEquipmentVC *aa = [[PFAddEquipmentVC alloc] initWithNibName:@"PFAddEquipmentVC" bundle:nil];
        aa.modelInstall = obj;
        aa.delegate = self;
        aa.fromAddPart = YES;
        aa.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [aa setPreferredContentSize:CGSizeMake(800, 600)];
        [self presentViewController:aa animated:YES completion:nil];
    }

    else if ([title isEqualToString:@"Schedule Time"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        
        editAppointmentViewController *objVC = [[editAppointmentViewController alloc]initWithNibName:@"editAppointmentViewController" bundle:nil];
        objVC.objEditDetail = obj;
        objVC.isFromTechCheck = YES;
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
    else if ([title isEqualToString:@"Approve Equipment"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        agreementViewController *objVC = [[agreementViewController alloc]initWithNibName:@"agreementViewController" bundle:nil];
        objVC.strOrderCode = obj.strOrderCode;
        objVC.strParentID = obj.strParentOrderId;
        objVC.delegate = self;
        objVC.strParentOrderId = obj.strParentOrderId;
        objVC.agreementViewType  = repeatAgreementType_ApprovedEquipment;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"Set Installation"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFSetTechCheckViewController *objVC = [[PFSetTechCheckViewController alloc]initWithNibName:@"PFSetTechCheckViewController" bundle:nil];
        objVC.modelInstall = obj;
        objVC.delegate = self;
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Approve Labor"])
    {
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        agreementViewController *objVC = [[agreementViewController alloc]initWithNibName:@"agreementViewController" bundle:nil];
        objVC.strOrderCode = obj.strOrderCode;
        objVC.strParentOrderId = obj.strParentOrderId;
        objVC.strParentID = obj.strOrderId;
        objVC.delegate = self;
        objVC.agreementViewType  = repeatAgreementType_ApprovedLabour;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"Special"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFAddSpecialHoursViewController *objVC = [[PFAddSpecialHoursViewController alloc]initWithNibName:@"PFAddSpecialHoursViewController" bundle:nil];
        objVC.delegate = self;
        objVC.orderId = obj.strOrderId;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
    }
    
    else if ([title isEqualToString:@"Old Equipment Pictures"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        
            UIGraphicsBeginImageContextWithOptions([self.view bounds].size, NO, 0.0f);
            [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
          //  return image;

        PFUploadOldUnitViewController *objVC = [[PFUploadOldUnitViewController alloc]initWithNibName:@"PFUploadOldUnitViewController" bundle:nil];
        objVC.parentId  = obj.strParentOrderId;
        objVC.img       = image;
        objVC.isOldPicture = YES;
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController: objVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
    
    else if ([title isEqualToString:@"Equipment"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFChangeInstallationHourVC *objVC = [[PFChangeInstallationHourVC alloc]initWithNibName:@"PFChangeInstallationHourVC" bundle:nil];
        objVC.delegate = self;
        objVC.installInfo = obj;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"View"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        agreementViewController *objVC = [[agreementViewController alloc]initWithNibName:@"agreementViewController" bundle:nil];
        objVC.isViewFromInstall = YES;
        objVC.strParentID = obj.strParentOrderId;
        objVC.strParentOrderId = obj.strParentOrderId;
        objVC.agreementViewType  = repeatAgreementType_ApprovedEquipment;
        objVC.strOrderCode = obj.strOrderCode;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"View Signed Image"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFViewSignedViewController *objVC = [[PFViewSignedViewController alloc]initWithNibName:@"PFViewSignedViewController" bundle:nil];
        objVC.signedImageView = obj.strSigned_image;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
        
    }
    else if ([title isEqualToString:@"80% Completed"] || [title isEqualToString:@"100% Completed"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];

        communicationViewController *objVC = [[communicationViewController alloc]initWithNibName:@"communicationViewController" bundle:nil];
        objVC.strOrderId = obj.strOrderId;
        objVC.strEmployeId = obj.strCustomerId;
        objVC.strCustomerName = obj.strShippingName;
        objVC.strOrderCode = obj.strOrderCode;
        objVC.strCompleteRoute = title;
        objVC.fromInstall = YES;
        objVC.delegate = self;
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Repair Completed"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        communicationViewController *objVC = [[communicationViewController alloc]initWithNibName:@"communicationViewController" bundle:nil];
        objVC.strOrderId = obj.strOrderId;
        objVC.fromRepair = YES;
        objVC.delegate = self;
        objVC.strEmployeId = obj.strCustomerId;
        objVC.strCustomerName = obj.strShippingName;
        objVC.strOrderCode = obj.strOrderCode;
        objVC.strCurrentStatus = obj.strOrderStatus;
        objVC.strCompleteRoute = obj.strOrderStatus;
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }

    else if ([title isEqualToString:@"Process Final Bill"])
    {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        agreementViewController *objVC = [[agreementViewController alloc]initWithNibName:@"agreementViewController" bundle:nil];
        objVC.strOrderCode = obj.strOrderCode;
        objVC.strParentOrderId = obj.strParentOrderId;
        objVC.strParentID = obj.strOrderId;
        objVC.delegate = self;
        
        if (self.viewType == RepeatViewType_Repair)
            objVC.isViewFromRepairFinalBill = YES;
        else
            objVC.isViewFromInstallFinalBill = YES;
        
        objVC.agreementViewType  = repeatAgreementType_ApprovedLabour;
        objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:objVC animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"Finish & Archive"]) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to perform this action?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            if(index == 0)
            {
                [self callAPIForFinishAndArchive:indexes];
            }
        }];
    }
    else if ([title isEqualToString:@"Installed Pictures"])
    {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        
        
        UIGraphicsBeginImageContextWithOptions([self.view bounds].size, NO, 0.0f);
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //  return image;
        
        PFUploadOldUnitViewController *objVC = [[PFUploadOldUnitViewController alloc]initWithNibName:@"PFUploadOldUnitViewController" bundle:nil];
        objVC.parentId  = obj.strParentOrderId;
        objVC.img       = image;
        objVC.isOldPicture = NO;
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController: objVC animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];

    }
    else if ([title isEqualToString:@"Walkthrough Signature"]) {

        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
         PFWalkThroughSignatureViewController *objVC = [[ PFWalkThroughSignatureViewController alloc]initWithNibName:@"PFWalkThroughSignatureViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.fromEquipment = NO;
        objVC.orderId = obj.strOrderId;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
   
}
    else if ([title isEqualToString:@"Collect Signature"]) {
        
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFWalkThroughSignatureViewController *objVC = [[ PFWalkThroughSignatureViewController alloc]initWithNibName:@"PFWalkThroughSignatureViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.fromEquipment = YES;
        objVC.orderId = obj.strOrderId;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
        
    }

    else if ([title isEqualToString:@"Mark Delivered"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        createAppointmentViewController *objVC = [[createAppointmentViewController alloc]initWithNibName:@"createAppointmentViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.isFromCreateAppointmentBtn = NO;
        objVC.objEditDetail = obj;
        objVC.delegate = self;
        objVC.strAppOrderCode = obj.strOrderCode;
        objVC.isFromEquipment = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Claim"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFEquipmentClaimViewController *objVC = [[PFEquipmentClaimViewController alloc]initWithNibName:@"PFEquipmentClaimViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.orderId = obj.strOrderId;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Warehouse"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFEquipmentWarehouseViewController *objVC = [[PFEquipmentWarehouseViewController alloc]initWithNibName:@"PFEquipmentWarehouseViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.orderId = obj.strOrderId;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Print Packing Slip"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.strPickingImage]];
    }
    else if ([title isEqualToString:@"Set Delivery"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        createAppointmentViewController *objVC = [[createAppointmentViewController alloc]initWithNibName:@"createAppointmentViewController" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.isFromCreateAppointmentBtn = NO;
        objVC.objEditDetail = obj;
        objVC.delegate = self;
        objVC.strAppOrderCode = obj.strOrderCode;
        objVC.isFromEquipmentSetDelivery = YES;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
    else if ([title isEqualToString:@"Process Return"]) {
        
        PFInstallModel *obj = [installListArray objectAtIndex:indexes];
        PFProcessReturnsVC *objVC = [[PFProcessReturnsVC alloc]initWithNibName:@"PFProcessReturnsVC" bundle:nil];
        objVC.providesPresentationContextTransitionStyle = YES;
        objVC.definesPresentationContext = YES;
        objVC.delegate = self;
        objVC.orderCode = obj.strOrderCode;
        objVC.orderId = obj.strOrderId;
        [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:objVC animated:NO completion:nil];
    }
}


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


#pragma mark - * * * BUTTON ACTION * * *

- (IBAction)btnBuildAction:(id)sender {
    
    [self.view endEditing:YES];
    if (!self.txtZipCode.text.length) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (self.txtZipCode.text.length < 4) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
    }
    else {
        
        [self.view endEditing:YES];

        if (!self.txtZipCode.text.length) {

            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
        }
        else if (self.txtZipCode.text.length < 4)
        {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
        }
        else
        {
            PFBuildQuoteVC *objVC = [[PFBuildQuoteVC alloc]initWithNibName:@"PFBuildQuoteVC" bundle:nil];
            objVC.delegate = self;
            objVC.providesPresentationContextTransitionStyle = YES;
            objVC.definesPresentationContext = YES;
            objVC.delegate = self;
            objVC.zipCode = self.txtZipCode.text;
            [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
    }
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

- (void)refershInstallList:(NSNotification *)note
{
    [self callGetInstallServiceIntegration];
}

#pragma mark

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

//FOR INSTALL
-(void)callGetInstallServiceIntegration
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"installList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
             [installListArray removeAllObjects];

             NSArray *installArray = [response objectForKeyNotNull:@"tech_check" expectedClass:[NSArray class]];
             for (NSMutableDictionary *installDict in installArray)
             {
                 PFInstallModel *installInfo = [PFInstallModel modelInstallListDict:installDict];
                 [installListArray addObject:installInfo];
             }

             [_installTableView reloadData];
         }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
     }];
}


// FOR TECHCHECK
- (void)callAPIForTechCheck {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if(self.viewType == RepeatViewType_TypeCheck)
     [dict setValue:@"preInspectionList"forKey:@"action"];
    else if(self.viewType == RepeatViewType_Install)
     [dict setValue:@"installList"forKey:@"action"];
    else if(self.viewType == RepeatViewType_Repair)
        [dict setValue:@"repairList"forKey:@"action"];
    else
        [dict setValue:@"equipment"forKey:@"action"];

    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {

                [installListArray removeAllObjects];
             NSArray *installArray = [response objectForKeyNotNull:@"tech_check" expectedClass:[NSArray class]];
             for (NSMutableDictionary *installDict in installArray)
             {
                 PFInstallModel *installInfo = [PFInstallModel modelInstallListDict:installDict];
                 [installListArray addObject:installInfo];
             }
             [_installTableView reloadData];
         }
            else {
                [installListArray removeAllObjects];
                [_installTableView reloadData];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
     }];
}


- (void)callAPIForArrived:(NSInteger)index {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    PFInstallModel *obj = [installListArray objectAtIndex:index];
    
    if (self.viewType == RepeatViewType_Equipment) {
        [dict setValue:@"equipmentInRoute" forKey:@"action"];
    }
    else if (self.viewType == RepeatViewType_Repair) {
        
        [dict setValue:@"repairInRoute" forKey:@"action"];
        [dict setValue:@"Repairs" forKey:@"sub_action"];
    }
    else {
        [dict setValue:@"inRouteArrived" forKey:@"action"];
        [dict setValue:@"" forKey:@"sub_action"];
    }
    [dict setValue:obj.strOrderId forKey:@"order_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [self callAPIForTechCheck];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

- (void)callAPIForCancelAndRedund:(NSInteger)index {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    PFInstallModel *obj = [installListArray objectAtIndex:index];
    
    if (self.viewType == RepeatViewType_Repair) {
        [dict setValue:@"cancelMainOrder" forKey:@"action"];
        [dict setValue:obj.strOrderId forKey:@"order_id"];
    }else {
        [dict setValue:@"cancelOrder" forKey:@"action"];
        [dict setValue:obj.strParentOrderId forKey:@"parent_order_id"];
    }
    
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self callAPIForTechCheck];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


- (void)callAPIForEmailAndText:(NSInteger)index {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    PFInstallModel *obj = [installListArray objectAtIndex:index];
    [dict setValue:@"emailAndText" forKey:@"action"];
    [dict setValue:obj.strOrderId forKey:@"order_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self callAPIForTechCheck];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



- (void)callAPIForUnrepairable:(NSInteger)index {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    PFInstallModel *obj = [installListArray objectAtIndex:index];
    
    [dict setValue:@"unRepairableOrder" forKey:@"action"];
    [dict setValue:obj.strOrderId forKey:@"order_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self callAPIForTechCheck];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



- (void)callAPIForFinishAndArchive:(NSInteger)index {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    PFInstallModel *obj = [installListArray objectAtIndex:index];
    
    if (self.viewType == RepeatViewType_Equipment)
        [dict setValue:@"equipmentOrderArchive" forKey:@"action"];
    else if (self.viewType == RepeatViewType_Repair) {
        [dict setValue:@"markOrderArchive" forKey:@"action"];
    }
    else
        [dict setValue:@"installOrderArchive" forKey:@"action"];
    
    [dict setValue:obj.strOrderId forKey:@"order_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {

                [self callAPIForTechCheck];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
