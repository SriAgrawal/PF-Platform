//
//  PFOrderViewController.m
//  PriceFixer
//
//  Created by Tejas Pareek on 21/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFOrderViewController.h"
#import "PFOrderTableViewCell.h"
#import "PFOrderInvoiceModel.h"


static NSString * cellIdentifier = @"OrderCellId";

@interface PFOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate, PFBuildQuoteVCDelegate> {
    
    NSMutableArray *orderDataArray;
    NSMutableArray      *arrOfCount;
    BOOL                isAnimated;
    NSMutableArray *paymentMethodArray;
    NSMutableArray *orderTypeArray;
    PFOrderInvoiceModel *modelObj;
    int fromOrToDatePickerValue;

}

@end

@implementation PFOrderViewController {

    IBOutlet UIImageView *profileImageView;
    
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *orderIDTextField;
    IBOutlet UITextField *customerTextField;
    __weak IBOutlet UITextField *zipCodeTextField;
    __weak IBOutlet UITextField *dateToTextField;
    __weak IBOutlet UITextField *dateFromTextfield;
    __weak IBOutlet UITextField *orderTypeTextField;
    __weak IBOutlet UITextField *paymentMethodTextField;
    __weak IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
    
    __weak IBOutlet UICollectionView *orderCollectionView;
    __weak IBOutlet UITableView *orderTableView;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIView *topMainView;
    
    __weak IBOutlet UIButton *prevButton;
    __weak IBOutlet UIButton *nextbutton;
    
    __weak IBOutlet UILabel *userNameLabel;
    
    __weak IBOutlet NSLayoutConstraint *logOutViewheightconstraint;
    __weak IBOutlet NSLayoutConstraint *topViewHeightConstraint;
    
    __weak IBOutlet UIView *logOutView;
    __strong Pagination *pagination;
    __strong UITableView *crewTableView;
    
    __weak IBOutlet UIButton *orderTypeButton;
    
    __weak IBOutlet UIButton *underProcessButton;
    __weak IBOutlet UIButton *archivedButton;
    __weak IBOutlet UIButton *allButton;
    __weak IBOutlet UIButton *payMethodButton;

    __weak IBOutlet UIButton *dateRangeButton;
    __weak IBOutlet UIButton *monthRangeButton;
    __weak IBOutlet UIButton *yesterdayRangeButton;
    __weak IBOutlet UIButton *todayRangeButton;
    __weak IBOutlet UIButton *allRangeButton;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UIButton *toDateButton;
    
    __weak IBOutlet UIButton *fromDateButton;
    
}

#pragma mark:- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
    
   // UITapGestureRecognizer *singleFingerTap =
    ////[[UITapGestureRecognizer alloc] initWithTarget:self
                                     //       action:@selector(handleSingleTap:)];
   // [self.view addGestureRecognizer:singleFingerTap];
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


#pragma mark - Memory Management Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    datePicker.hidden = YES;
    toDateButton.selected = NO;
    fromDateButton.selected = NO;

    //Do stuff here...
}


#pragma mark -

#pragma mark - Validation Method

-(BOOL)isValidate {
    
    if (!customerTextField.text.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter customer." onController:self];
    }
    else
        if (!emailTextField.text.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter email." onController:self];
        }
        else if ([PFUtility validateEmailAddress:emailTextField.text]){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid email." onController:self];
        }
        else if (!orderIDTextField.text.length){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter order ID." onController:self];
        }
        else if (!paymentMethodTextField.text.length){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select payment method." onController:self];
        }
        else if (!orderTypeTextField.text.length){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select order type." onController:self];
        }
        else if (!(allButton.selected || archivedButton.selected || underProcessButton.selected)){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select any order show." onController:self];
        }
        else if (!(allRangeButton.selected || todayRangeButton.selected || yesterdayRangeButton.selected || monthRangeButton.selected || dateRangeButton.selected)){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select any range." onController:self];
        }
        else{
            return YES;
        }
    return NO;
}


#pragma mark :- Helper Methods
-(void) customInit{

    [self.navigationController setNavigationBarHidden:YES];
    datePicker.backgroundColor = [UIColor whiteColor];
    [orderTableView registerNib:[UINib nibWithNibName:@"PFOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    // Add Custom TableView
    crewTableView = [[UITableView alloc]initWithFrame:CGRectMake(152, 370, 720, 100) style:UITableViewStylePlain];
    crewTableView.dataSource=self;
    crewTableView.delegate=self;
    [topMainView addSubview:crewTableView];
    
    crewTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    crewTableView.layer.cornerRadius = 6;
    crewTableView.layer.masksToBounds = YES;
    
    crewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    crewTableView.hidden=YES;
    datePicker.hidden = YES;
    
    // Alloc Model Class
     modelObj = [[PFOrderInvoiceModel alloc] init];
    
    // Alloc Client DataArray
    orderDataArray = [NSMutableArray array];
    paymentMethodArray = [[NSMutableArray alloc]initWithObjects:@"All",@"Cash",@"Check",@"Credit Card", nil];
    orderTypeArray = [[NSMutableArray alloc]initWithObjects:@"All",@"Installations",@"Repairs",@"Maintenance", nil];
    
    pagination = [[Pagination alloc] init];
    bottomView.hidden = YES;
    
    // Initial hide search view
    topViewHeightConstraint.constant = 0;
    orderTableView.hidden = YES;
    
    // Set logout view
    logOutView.hidden = YES;
    [logOutViewheightconstraint setConstant:0];
    
    // Set userImage corner radius
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2;
    profileImageView.layer.masksToBounds = YES;


    // Set UserName
    userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    
    [profileImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    
    [self methodForSetupCollectionview];
    
    [self callClientListServiceIntegration:1];
}


-(void)methodForSetupCollectionview{
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [orderCollectionView registerNib:[UINib nibWithNibName:@"PFCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    orderCollectionView.layer.cornerRadius = 5.0f;
    orderCollectionView.layer.borderColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1.f].CGColor;
    orderCollectionView.layer.borderWidth = 1.0f;
    orderCollectionView.layer.masksToBounds = YES;
}

#pragma mark -

#pragma mark - UICollectionView  delegate and dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return arrOfCount.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PFCollectionCell * cell = (PFCollectionCell * )[orderCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
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
    [self callClientListServiceIntegration:indexPath.item+1];
    
    [orderCollectionView reloadData];
}

#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (payMethodButton.selected) {
        return paymentMethodArray.count;
    }
    else if (orderTypeButton.selected) {
        return orderTypeArray.count;
    }
    else
        return orderDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (payMethodButton.selected || orderTypeButton.selected) {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        }
        if (payMethodButton.selected)
            cell.textLabel.text=[paymentMethodArray objectAtIndex:indexPath.row];
        else
            cell.textLabel.text=[orderTypeArray objectAtIndex:indexPath.row];

        return cell;

    }
    else {
    PFOrderTableViewCell * cell = (PFOrderTableViewCell *)[orderTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.printButton.tag = indexPath.row + 800;
     PFOrderInvoiceModel *orderInfo = [orderDataArray objectAtIndex:indexPath.row];
        
        cell.idLabel.text = orderInfo.strOrder_id;
        cell.dateLabel.text = orderInfo.strOrder_date;
        cell.nameLabel.text = orderInfo.strCustomer_name;
        cell.statusLabel.text = orderInfo.strOrder_status;
        cell.totalAmountLabel.text = orderInfo.strNet_total;
        cell.owedAmountLabel.text = orderInfo.strOwed;
        cell.orderCodeLabel.text = orderInfo.strOrder_code;

        
        if ([orderInfo.strOrder_status isEqualToString:@"Pre-Inspection Set"])
            cell.statusLabel.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:157.0/255.0 blue:65.0/255.0 alpha:1.0];
        else if
            ([orderInfo.strOrder_status isEqualToString:@"Pending"] || [orderInfo.strOrder_status isEqualToString:@"Cancelled"])
            cell.statusLabel.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:61.0/255.0 blue:63.0/255.0 alpha:1.0];
        else if
            ([orderInfo.strOrder_status isEqualToString:@"In Route"] || [orderInfo.strOrder_status isEqualToString:@"Awaiting Shipment"] || [orderInfo.strOrder_status isEqualToString:@"Arrived"])
            cell.statusLabel.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:101.0/255.0 blue:168.0/255.0 alpha:1.0];
        else
            cell.statusLabel.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:179.0/255.0 blue:63.0/255.0 alpha:1.0];

        
        [cell.printButton addTarget:self action:@selector(printButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    }
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (payMethodButton.selected) {
            paymentMethodTextField.text = [paymentMethodArray objectAtIndex:indexPath.row];
            payMethodButton.selected = NO;
    }
    else if(orderTypeButton.selected){
            orderTypeTextField.text = [orderTypeArray objectAtIndex:indexPath.row];
        if ([orderTypeTextField.text isEqualToString:@"All"]) {
            modelObj.strOrderType = @"";
        }
        else if ([orderTypeTextField.text isEqualToString:@"Installations"]) {
            modelObj.strOrderType = @"2";
        }
        else if ([orderTypeTextField.text isEqualToString:@"Repairs"]) {
            modelObj.strOrderType = @"3";
        }
        else {
            modelObj.strOrderType = @"4";
        }
        orderTypeButton.selected = NO;
    }
    
    crewTableView.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (payMethodButton.selected || orderTypeButton.selected)
        return 30.0;
    else
        return 57.0;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.returnKeyType == UIReturnKeyNext) {
        UITextField *txtField = [self.view viewWithTag:textField.tag+1];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;
    datePicker.hidden = YES;
    crewTableView.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length > 60 && (textField.tag == 100 || textField.tag == 101))
        return NO;
    else if (str.length > 10 && textField.tag == 102)
        return NO;
    else if (str.length > 20 && textField.tag == 300)
        return NO;
    
    return YES;
}


#pragma mark -

#pragma mark - Selector Method

-(void)afterSomeTime {
    
    tableViewHeightConstraint.constant = orderTableView.contentSize.height;
    
}

-(void)hideShowLogoutView {
    
    datePicker.hidden = YES;
    crewTableView.hidden = YES;
    isAnimated = NO;
    [logOutViewheightconstraint setConstant:0];
    [logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}

- (void)printButtonAction:(UIButton*)sender {
    
    PFOrderInvoiceModel *orderInfo = [orderDataArray objectAtIndex:sender.tag - 800];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:orderInfo.strPrint_url]];
}



#pragma mark:- UIButton Action Methods
- (IBAction)menuButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}

- (IBAction)buildQuoteButtonAction:(UIButton *)sender {
    
    [self hideShowLogoutView];
    [self.view endEditing:YES];
    
    if (!zipCodeTextField.text.length) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (zipCodeTextField.text.length < 4) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:KInvalidzipcode onController:self];
    }
    else {
            PFBuildQuoteVC *objVC = [[PFBuildQuoteVC alloc]initWithNibName:@"PFBuildQuoteVC" bundle:nil];
            objVC.providesPresentationContextTransitionStyle = YES;
            objVC.definesPresentationContext = YES;
            objVC.delegate = self;
            objVC.zipCode = zipCodeTextField.text;
            [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
}

- (IBAction)settingsButtonAction:(UIButton *)sender {
}

- (IBAction)helpButtonAction:(UIButton *)sender {
}

- (IBAction)signOutButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    datePicker.hidden = YES;
    crewTableView.hidden = YES;
    [UIView transitionWithView:self.view duration:0.1 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if (isAnimated == NO) {
                            isAnimated = YES;
                            [logOutViewheightconstraint setConstant:69];
                            [logOutView setHidden:NO];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }else{
                            isAnimated = NO;
                            [logOutViewheightconstraint setConstant:0];
                            [logOutView setHidden:YES];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }
                    }
                    completion:^(BOOL finished) {
                    }];

}

- (IBAction)hideButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
   topViewHeightConstraint.constant = 0;
}

- (IBAction)showButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    topViewHeightConstraint.constant = 343;
}

- (IBAction)searchButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
   // if ([self isValidate]) {
        
        [self callClientListServiceIntegration:1];
   // }
}

- (IBAction)logOutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];

}

- (IBAction)prevButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
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
        [self collectionView:orderCollectionView didSelectItemAtIndexPath:indexPath];
        if(!(orderCollectionView.contentOffset.x <= 0))
            [orderCollectionView setContentOffset:CGPointMake(orderCollectionView.contentOffset.x -45, 0)];
    }
    
}

- (IBAction)nextPageButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
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
    if (currentIndex <= [pagination.maxPageNo integerValue] -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [self collectionView:orderCollectionView didSelectItemAtIndexPath:indexPath];
        if(!(orderCollectionView.contentOffset.x >= 270) && [pagination.maxPageNo integerValue] > 4)
            [orderCollectionView setContentOffset:CGPointMake(orderCollectionView.contentOffset.x + 45, 0)];
    }
}

- (IBAction)orderTypeButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    datePicker.hidden = YES;

    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 150;
    
    [crewTableView setFrame:rect];
    payMethodButton.selected = NO;
    orderTypeButton.selected = !orderTypeButton.selected;
    
    if (orderTypeButton.selected)
        [crewTableView setHidden:NO];
    else
        [crewTableView setHidden:YES];
    
    [crewTableView reloadData];

}

- (IBAction)payMethodButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    datePicker.hidden = YES;

    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 150;
    
    [crewTableView setFrame:rect];
    orderTypeButton.selected = NO;
    payMethodButton.selected = !payMethodButton.selected;
    
    if (payMethodButton.selected)
        [crewTableView setHidden:NO];
    else
        [crewTableView setHidden:YES];
    
    [crewTableView reloadData];

}

- (IBAction)fromDateButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    fromOrToDatePickerValue = 1;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    dateFromTextfield.text = [dateFormatter stringFromDate:[datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    modelObj.strFromDate = [dateFormatter1 stringFromDate:[datePicker date]];
    
    fromDateButton.selected = !fromDateButton.selected;
    
    if (fromDateButton.selected)
        [datePicker setHidden:NO];
    else
        [datePicker setHidden:YES];
    
    [crewTableView setHidden:YES];
//    self.quoteButton.selected = NO;
//    self.crewButton.selected = NO;
//    self.hourButton.selected = NO;
//    self.minuteButton.selected = NO;
//    self.amButton.selected = NO;
}

- (IBAction)toDateButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    fromOrToDatePickerValue = 2;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    dateToTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    modelObj.strTodate = [dateFormatter1 stringFromDate:[datePicker date]];
    
    toDateButton.selected = !toDateButton.selected;
    
    if (toDateButton.selected)
        [datePicker setHidden:NO];
    else
        [datePicker setHidden:YES];
    
    [crewTableView setHidden:YES];
}


- (IBAction)dateSelection:(id)sender {
    
    [self.view endEditing:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    if (fromOrToDatePickerValue == 1) {
        dateFromTextfield.text = [dateFormatter stringFromDate:[datePicker date]];
        modelObj.strFromDate = [dateFormatter1 stringFromDate:[datePicker date]];
    }
    else {
        dateToTextField.text = [dateFormatter stringFromDate:[datePicker date]];
        modelObj.strTodate = [dateFormatter1 stringFromDate:[datePicker date]];
    }

}

- (IBAction)commonButtonAction:(UIButton*)sender {
    

    if(sender.tag <=602) {
        allButton.selected = NO;
        archivedButton.selected = NO;
        underProcessButton.selected = NO;
    }
    else {
        allRangeButton.selected = NO;
        todayRangeButton.selected = NO;
        yesterdayRangeButton.selected = NO;
        monthRangeButton.selected = NO;
        dateRangeButton.selected = NO;
    }

    if (sender.tag == 600) {
        allButton.selected = !allButton.selected;
        modelObj.strOrderShow = @"-1";
    }
    else if (sender.tag == 601) {
        archivedButton.selected = !archivedButton.selected;
        modelObj.strOrderShow = @"1";

    }
    else if (sender.tag == 602) {
        underProcessButton.selected = !underProcessButton.selected;
        modelObj.strOrderShow = @"0";
    }
    else if (sender.tag == 603) {
        allRangeButton.selected = !allRangeButton.selected;
        modelObj.strRange = @"all";

    }
    else if (sender.tag == 604) {
        todayRangeButton.selected = !todayRangeButton.selected;
        modelObj.strRange = @"today";
    }
    else if (sender.tag == 605) {
        yesterdayRangeButton.selected = !yesterdayRangeButton.selected;
        modelObj.strRange = @"yesterday";
    }
    else if (sender.tag == 606) {
        monthRangeButton.selected = !monthRangeButton.selected;
        modelObj.strRange = @"month";
    }
    else if (sender.tag == 607) {
        dateRangeButton.selected = !dateRangeButton.selected;
        modelObj.strRange = @"date";
    }

}

#pragma mark - Service Helper Class

-(void)callClientListServiceIntegration: (NSInteger) pageNumber {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"orderList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:customerTextField.text forKey:@"customer"];
    [dict setValue:emailTextField.text forKey:@"email"];
    [dict setValue:orderIDTextField.text forKey:@"order_id"];
    [dict setValue:([paymentMethodTextField.text isEqualToString:@"All"])?@"":paymentMethodTextField.text forKey:@"pay_method"];
    [dict setValue:modelObj.strOrderType forKey:@"order_type"];
    [dict setValue:modelObj.strFromDate forKey:@"date_from"];
    [dict setValue:modelObj.strTodate forKey:@"date_to"];
    [dict setValue:modelObj.strOrderShow forKey:@"is_archived"];
    [dict setValue:modelObj.strRange forKey:@"span"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"pageNumber"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                NSArray *orderList = [response objectForKeyNotNull:@"orderData" expectedClass:[NSArray class]];
                
                orderTableView.hidden = NO;
                
                topViewHeightConstraint.constant = 0;
                pagination = [Pagination getPaginationInfoFromDict:[response objectForKeyNotNull:@"pagination" expectedClass:[NSDictionary class]]];
                
                [orderDataArray removeAllObjects];
                
                for (NSDictionary *tempDict in orderList) {
                    
                    [orderDataArray addObject:[PFOrderInvoiceModel modelOrderListDict:tempDict]];
                }
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                
                orderTableView.delegate = self;
                orderTableView.dataSource = self;
                
                if ([pagination.maxPageNo intValue] > 1) {
                    bottomView.hidden = NO;
                }
                else {
                    bottomView.hidden = YES;
                }
                
                arrOfCount = [[NSMutableArray alloc] init];
                for (int i =1; i<=[pagination.maxPageNo integerValue]; i++) {
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
                orderCollectionView.delegate = self;
                orderCollectionView.dataSource = self;

                [orderCollectionView reloadData];
                [orderTableView reloadData];
            }
            else if([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 0) {
                [orderDataArray removeAllObjects];
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                orderTableView.hidden = YES;
                bottomView.hidden = YES;
                topViewHeightConstraint.constant = 0;
                [orderTableView reloadData];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
            }
            else {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
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
