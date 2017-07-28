//
//  PFDispatchVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFDispatchVC.h"
#import "PFBuildQuoteVC.h"
#import "PFUtility.h"
#import "PFSendproposalViewController.h"
static NSString * cellIdentifier = @"PFDispatchCell";
static NSString * cellIdentifier1 = @"PFCollectionCell";


@interface PFDispatchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource, PFBuildQuoteVCDelegate,setBuildQuoteProtocol>{
    BOOL                isAnimated;
    NSMutableArray      *arrOfCount;
    NSMutableArray      *dispatchDataSourceArray;
    BOOL                isLoadMoreExecuting;

}

@property (strong, nonatomic) IBOutlet UIView *installView;
@property (strong, nonatomic) IBOutlet UIView *maintanceView;
@property (strong, nonatomic) IBOutlet UIView *repairView;
@property (strong, nonatomic) IBOutlet UIView *installOuterView;
@property (strong, nonatomic) IBOutlet UIView *maintwnanceOuterView;
@property (strong, nonatomic) IBOutlet UIView *repairOuterView;
@property (strong, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet UIView *bottomNextView;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;

@property (strong, nonatomic) IBOutlet UIImageView *installImgView;
@property (strong, nonatomic) IBOutlet UIImageView *maintanceimgView;
@property (strong, nonatomic) IBOutlet UIImageView *repairImgView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property (weak, nonatomic) IBOutlet UITableView *dispatchTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *prevbutton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoutViewHeightConstant;
@property (strong, nonatomic) IBOutlet UILabel *lblInstall;
@property (weak, nonatomic) IBOutlet UILabel *lblRepair;
@property (weak, nonatomic) IBOutlet UILabel *lblSent;
@property (weak, nonatomic) IBOutlet UILabel *lblView;
@property (weak, nonatomic) IBOutlet UILabel *lblWebsite;
@property (weak, nonatomic) IBOutlet UILabel *lblBought;

@property (nonatomic, strong) Pagination *pagination;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstant;

@end

@implementation PFDispatchVC

#pragma mark - View controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.installView.layer.cornerRadius = self.installView.frame.size.width/2;
    self.maintanceView.layer.cornerRadius = self.maintanceView.frame.size.width/2;
    self.repairView.layer.cornerRadius = self.repairView.frame.size.width/2;
    self.installImgView.layer.cornerRadius = self.installImgView.frame.size.width/2;
    self.maintanceimgView.layer.cornerRadius = self.maintanceimgView.frame.size.width/2;
    self.repairImgView.layer.cornerRadius = self.repairImgView.frame.size.width/2;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    
    // Set UserImage
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    
    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    self.bottomNextView.hidden = YES;

    [_dispatchTableView registerNib:[UINib nibWithNibName:@"PFDispatchCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

    [self.logOutView setHidden:YES];
    [self.logoutViewHeightConstant setConstant:0];
    
    dispatchDataSourceArray = [[NSMutableArray alloc] init];
    
    isLoadMoreExecuting = NO;
    self.pagination = [[Pagination alloc] init];
    
    [self methodForSetupCollectionview];
    
    self.dispatchTableView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(refershDispatchList:)
                                                      name:@"refershDispatchList" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [_collectionView setContentOffset:CGPointMake(0, 0)];

    [self callgetDispatchServiceIntegration:1];
    AppDelegate * appDelegate = APPDELEGATE;
    appDelegate.signatureViewTappedIndicator=@"no";
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



#pragma mark - Helper method
-(void)methodForSetupCollectionview{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PFCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.layer.cornerRadius = 5.0f;
    self.collectionView.layer.borderColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1.f].CGColor;
    self.collectionView.layer.borderWidth = 1.0f;
    self.collectionView.layer.masksToBounds = YES;
}
#pragma mark -



#pragma mark - UICollectionView  delegate and dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrOfCount.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PFCollectionCell * cell = (PFCollectionCell * )[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    PFDispatchModel * modalObj = [arrOfCount objectAtIndex:indexPath.item];
    cell.cellCountLabel.tag = indexPath.item;
    cell.cellCountLabel.text = [NSString stringWithFormat:@"%ld",(long)modalObj.strCount];
    
    if (modalObj.isSelected) {
        cell.cellCountLabel.textColor = [UIColor whiteColor];
        cell.cellCountLabel.backgroundColor = [UIColor colorWithRed:114/255.0f green:189/255.0f blue:37/255.0f alpha:1.0f];
    }
    else{
        cell.cellCountLabel.textColor = [UIColor colorWithRed:22/255.0f green:45/255.0f blue:84/255.0f alpha:1.0f];
        cell.cellCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(45,45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [arrOfCount enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PFDispatchModel * modalObj = (PFDispatchModel *)obj;
        modalObj.isSelected = idx==indexPath.item  ? !modalObj.isSelected : NO;

    }];
      [self callgetDispatchServiceIntegration:indexPath.item + 1];
    [self.collectionView reloadData];
}

#pragma mark -


#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dispatchDataSourceArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFDispatchCell * cell = (PFDispatchCell *)[self.dispatchTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    //PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];

    if (obj.strApointmenttId == nil || [obj.strApointmenttId isEqualToString:@""]) {
        
        [cell.lblAppoinment setText:@"Click to set"];
        [cell.btnEditAddress setHidden:YES];
        [cell.btnEditAppoinment setHidden:YES];
        [cell.btnAggrement setHidden:YES];
        [cell.btnChat setHidden:YES];
        [cell.btnAppDate setUserInteractionEnabled:YES];
        
    }else{
        [cell.lblAppoinment setText:obj.strApointmenttDate];
        [cell.btnEditAddress setHidden:NO];
        [cell.btnEditAppoinment setHidden:NO];
        [cell.btnAggrement setHidden:NO];
        [cell.btnChat setHidden:NO];
        [cell.btnAppDate setUserInteractionEnabled:NO];

    }
    [cell.lblClient setText:obj.strCustomerName];
    [cell.lblTask setText:obj.strOrderType];
    [cell.lblStatus setText:obj.strOrderStatus];
    [cell.orderCode setText:obj.strOrderCode];

    
    [cell.btnEditAddress addTarget:self action:@selector(btnEditAddressAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEditAppoinment addTarget:self action:@selector(btnEditAppoinmentAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAggrement addTarget:self action:@selector(btnAggrementAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCommunication addTarget:self action:@selector(btnCommunicationAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnChat addTarget:self action:@selector(btnChatAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMap addTarget:self action:@selector(btnMapAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAppDate addTarget:self action:@selector(btnCreateAppoinment:withEvent:) forControlEvents:UIControlEventTouchUpInside];
   
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
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
      //  textField.inputAccessoryView = toolBarForNumberPad(self,@"Done");
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

#pragma mark - UITouch Method

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark -

#pragma mark - IBActions
- (IBAction)menuButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}


- (IBAction)createAppoinmentBtnAction:(UIButton *)sender {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    createAppointmentViewController *objVC = [[createAppointmentViewController alloc]initWithNibName:@"createAppointmentViewController" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.isFromCreateAppointmentBtn = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}


- (void)btnCreateAppoinment:(UIButton *)button withEvent:(UIEvent *)event {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];

    createAppointmentViewController *objVC = [[createAppointmentViewController alloc]initWithNibName:@"createAppointmentViewController" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.isFromCreateAppointmentBtn = NO;
    objVC.strAppOrderCode = obj.strOrderCode;
    objVC.strAppCustomerId = obj.strCustomerId;
    objVC.strAppShopId = obj.strShopId;
    objVC.strAppOrderId = obj.strOrderId;
    
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}


- (void)btnEditAddressAction:(UIButton *)button withEvent:(UIEvent *)event {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];
    ViewController *objVC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
    

}

- (void)btnEditAppoinmentAction:(UIButton *)button withEvent:(UIEvent *)event {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];

    editAppointmentViewController *objVC = [[editAppointmentViewController alloc]initWithNibName:@"editAppointmentViewController" bundle:nil];
    objVC.strAppoinmentId = obj.strApointmenttId;
    objVC.strAppoinmentDate = obj.strApointmenttDate;
    objVC.strOrderId = obj.strOrderId;

    objVC.obj_editDetail = obj;
    
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];


}

- (void)btnAggrementAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];


    
    agreementViewController *objVC = [[agreementViewController alloc]initWithNibName:@"agreementViewController" bundle:nil];
    
    objVC.strOrderId = obj.strOrderId;
    objVC.strOrderCode = obj.strOrderCode;
    objVC.agreementViewType  = repeatAgreementType_Dispach;
    objVC.strParentID = obj.strParentOrderId;

    objVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:objVC animated:YES completion:nil];
//    [self addChildViewController:objVC];
//    [self.view addSubview:objVC.view];
//    [objVC didMoveToParentViewController:self];

}

- (void)btnCommunicationAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.strEmployeId = obj.strCustomerId;
    objVC.strOrderCode = obj.strOrderCode;

    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];

}

- (void)btnChatAction:(UIButton *)button withEvent:(UIEvent *)event {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];
    communicationViewController *objVC = [[communicationViewController alloc]initWithNibName:@"communicationViewController" bundle:nil];
    objVC.strOrderId = obj.strOrderId;
    objVC.strEmployeId = obj.strCustomerId;
    objVC.strCustomerName = obj.strCustomerName;
    objVC.strOrderCode = obj.strOrderCode;


    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];


}

- (void)btnMapAction:(UIButton *)button withEvent:(UIEvent *)event {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    NSIndexPath * indexPath = [self.dispatchTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.dispatchTableView]];
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];

    // destination address
    CLLocationCoordinate2D coordinate = [self geoCodeUsingAddress:[NSString stringWithFormat:@"%@ %@ %@ %@",obj.strShippingAddress1,obj.strShippingCity,obj.strShippingState,obj.strShippingZip]];
    
    // source address
    CLLocation * currLocation = [APPDELEGATE currentLocation];

    NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f&directionsmode=driving",coordinate.latitude, coordinate.longitude,currLocation.coordinate.latitude,currLocation.coordinate.longitude];
    
    NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)navBtnQueryAction:(UIButton *)sender {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}

- (IBAction)navBtnAction:(UIButton *)sender {
    
    [self hideShowLogoutView];
    
    [self.view endEditing:YES];

    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];

}

- (IBAction)btnChangePasswordAction:(UIButton *)sender {
    
    [self hideShowLogoutView];

    [self.view endEditing:YES];

    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)sendMessageBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];

    PFSendMessageVC *objVC = [[PFSendMessageVC alloc]initWithNibName:@"PFSendMessageVC" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}


- (IBAction)btnNavLogoutAction:(UIButton *)sender {
    
    [self.view endEditing:YES];

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


- (IBAction)btnLogoutAction:(UIButton *)sender {
    
    [self.view endEditing:YES];

    [self hideShowLogoutView];
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}

- (IBAction)btnAddClientAction:(UIButton *)sender {
    
    [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Work in progress." onController:self];
}

- (IBAction)prevButtonAction:(id)sender {
    
    [self.view endEditing:YES];

    NSInteger currentIndex = 0;
    
    for (int i=0; i<[arrOfCount count]; i++) {
        PFDispatchModel *obj = [arrOfCount objectAtIndex:i];
        if (obj.isSelected) {
            currentIndex = --i;
            break;
        }else{
            continue;
        }
    }
    if (currentIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
        if(!(self.collectionView.contentOffset.x <= 0))
            [_collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x -45, 0)];
    }
    
}

- (IBAction)nextPageButtonAction:(id)sender {
    
    [self.view endEditing:YES];

    NSInteger currentIndex = 0;
    
    for (int i=0; i<[arrOfCount count]; i++) {
        PFDispatchModel *obj = [arrOfCount objectAtIndex:i];
        if (obj.isSelected) {
            currentIndex = ++i;
            break;
        }else{
            continue;
        }
    }
    if (currentIndex <= [self.pagination.maxPageNo integerValue] -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
        NSLog(@"%f",self.collectionView.contentOffset.x);
        if(!(self.collectionView.contentOffset.x >= 270) && [self.pagination.maxPageNo integerValue] > 4)
            [_collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 45, 0)];
    }
}

- (IBAction)buildQuoteButtonAction:(id)sender {
    
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

- (IBAction)sendProposalButtonAction:(id)sender {
    
    PFSendproposalViewController *objVC = [[PFSendproposalViewController alloc]initWithNibName:@"PFSendproposalViewController" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.delegate = self;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}



#pragma mark - Get Lat long from Address string
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address{
    double latitude = 0, longitude = 0;
    [NSUSERDEFAULTS setValue:address forKey:@"strLocation"];
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

- (void)refershDispatchList:(NSNotification *)note {
    
    [self callgetDispatchServiceIntegration:1];
}


-(void)hideShowLogoutView{
    isAnimated = NO;
    [self.logoutViewHeightConstant setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
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
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {

            [APPDELEGATE  navigateToLoginVC];
//            [[APPDELEGATE navController] popToRootViewControllerAnimated:YES];
        }
    }];
}



-(void)callgetDispatchServiceIntegration : (NSInteger) pageNumber{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"dispatchList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"pageNumber"];
    [dict setValue:[NSString stringWithFormat:@"%@",@"5"] forKey:@"pageSize"];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            
            self.lblInstall.text = [response objectForKeyNotNull:@"installs" expectedClass:[NSString class]];

            isLoadMoreExecuting = NO;

            self.pagination = [Pagination getPaginationInfoFromDict:[response objectForKeyNotNull:@"pagination" expectedClass:[NSDictionary class]]];

            [dispatchDataSourceArray removeAllObjects];

            NSArray *DispatchListArray = [response objectForKeyNotNull:@"dispatchList" expectedClass:[NSArray class]];

            NSArray *quotesListArray = [response objectForKeyNotNull:@"quoteData" expectedClass:[NSArray class]];

            NSMutableArray *quotesDataArray = [NSMutableArray array];

            for (NSMutableDictionary *dispatchDict in DispatchListArray) {
                PFDispatchModel *dispatchInfo = [PFDispatchModel modelDispatchListDict:dispatchDict];
                [dispatchDataSourceArray addObject:dispatchInfo];
            }
                if (dispatchDataSourceArray.count)
                    self.dispatchTableView.hidden = NO;
                else
                    self.dispatchTableView.hidden = YES;
            
            for (NSMutableDictionary *quotesDict in quotesListArray) {
                PFDispatchModel *dispatchInfo = [PFDispatchModel quotesListDict:quotesDict];
                [quotesDataArray addObject:dispatchInfo];
            }
            
            self.lblInstall.text    =    [response objectForKeyNotNull:@"installs" expectedClass:[NSString class]];
            self.lblRepair.text    =    [response objectForKeyNotNull:@"repairs" expectedClass:[NSString class]];

            if (quotesDataArray.count == 4) {
                
                PFDispatchModel *quotesData = [quotesDataArray objectAtIndex:0];
                PFDispatchModel *quotesData1 = [quotesDataArray objectAtIndex:1];
                PFDispatchModel *quotesData2 = [quotesDataArray objectAtIndex:2];
                PFDispatchModel *quotesData3 = [quotesDataArray objectAtIndex:3];

                self.lblSent.text    =    quotesData.strItemCount;
                self.lblView.text    =    quotesData1.strItemCount;
                self.lblWebsite.text =    quotesData2.strItemCount;
                self.lblBought.text  =    quotesData3.strItemCount;

            }
            
            if ([_pagination.maxPageNo intValue] > 1) {
                self.bottomNextView.hidden = NO;
            }
            else {
                self.bottomNextView.hidden = YES;
            }
            
            arrOfCount = [[NSMutableArray alloc] init];
            for (int i =1; i<=[self.pagination.maxPageNo integerValue]; i++) {
                PFDispatchModel * modalObj = [[PFDispatchModel alloc]init];
                modalObj.strCount = i;
                if (i == pageNumber) {
                    modalObj.isSelected = YES;
                }
                else{
                    modalObj.isSelected = NO;
                }
                [arrOfCount addObject:modalObj];
            }
            [self.collectionView reloadData];
            [self.dispatchTableView reloadData];
            [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.0];

        }
            else {
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
    }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
  }];
}

#pragma mark -

#pragma mark - Selector Method

-(void)afterSomeTime {
    
    self.tableHeightConstant.constant = self.dispatchTableView.contentSize.height;
    self.dispatchTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.dispatchTableView.layer.borderWidth = 1.0;
}


#pragma mark -

#pragma mark - Selector Method

- (void)doneWithNumberPad {
    
    [self.view endEditing:YES];
}

-(void)callBuildQuote:(NSString *)zipCode {
    
    PFBuildQuoteVC *objVC = [[PFBuildQuoteVC alloc]initWithNibName:@"PFBuildQuoteVC" bundle:nil];
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    objVC.delegate = self;
    objVC.zipCode = zipCode;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}


#pragma mark -

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -


@end
