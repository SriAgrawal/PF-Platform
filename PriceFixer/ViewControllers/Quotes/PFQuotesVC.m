//
//  PFQuotesVC.m
//  PriceFixer
//
//  Created by Ankit Kumar Gupta on 21/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFQuotesVC.h"
#import "Macro.h"
#import "PFQuotesTVC.h"

static NSString * cellIdentifier = @"clientCellID";

@interface PFQuotesVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, PFBuildQuoteVCDelegate> {
    
    BOOL                isAnimated;
    BOOL                isLoadMoreExecuting;
    PFQuotesListInfo    *modelObj;
    NSMutableArray      *clientDataArray;
    NSMutableArray      *arrOfCount;
    NSMutableArray      *quotesStatusArray;
    int                 fromOrToDatePickerValue;

}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewCustomerViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (strong, nonatomic) IBOutlet UITableView *crewTableView;
@property (weak, nonatomic) IBOutlet UITableView *quotesTableView;
@property (nonatomic, strong) Pagination *pagination;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIButton *prevbutton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTblViewHeight;
@property (weak, nonatomic) IBOutlet UIView *quoteTopview;

@end

@implementation PFQuotesVC{

    __weak IBOutlet UIButton *dateRangeButton;
    __weak IBOutlet UIButton *monthRangeButton;
    __weak IBOutlet UIButton *yesterdayRangeButton;
    __weak IBOutlet UIButton *todayRangeButton;
    __weak IBOutlet UIButton *allRangeButton;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UIButton *toDateButton;
    __weak IBOutlet UIButton *fromDateButton;
    __weak IBOutlet UITextField *dateToTextField;
    __weak IBOutlet UITextField *dateFromTextField;

    __weak IBOutlet UIButton *orderTypeButton;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtCustomer;
    __weak IBOutlet UITextField *txtQuotesStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    [self.navigationController setNavigationBarHidden:YES];
    

    [self.quotesTableView registerNib:[UINib nibWithNibName:@"PFQuotesTVC" bundle:nil] forCellReuseIdentifier:@"PFQuotesTVC"];
    [self methodForSetupCollectionview];
    
    // Alloc Client DataArray
    clientDataArray = [NSMutableArray array];
    
    // Alloc Model Class
    modelObj = [[PFQuotesListInfo alloc]init];
    modelObj.strRange = @"";
    modelObj.strTodate = @"";
    modelObj.strFromDate = @"";
    
    isLoadMoreExecuting = NO;
    self.pagination = [[Pagination alloc] init];
    self.bottomView.hidden = YES;
    
    // Initial hide search view
    self.searchView.hidden = YES;
    self.addNewCustomerViewConstraint.constant = 30;
    
    // Add Custom TableView
    _crewTableView = [[UITableView alloc]initWithFrame:CGRectMake(152, 370, 720, 150) style:UITableViewStylePlain];
    _crewTableView.dataSource=self;
    _crewTableView.delegate=self;
    [self.searchView addSubview:_crewTableView];
    
    _crewTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    _crewTableView.layer.cornerRadius = 6;
    _crewTableView.layer.masksToBounds = YES;
    _crewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _crewTableView.hidden=YES;
    
    self.searchView.layer.borderColor = KHomeTextFieldGrayBorderColor;
    self.searchView.layer.borderWidth = 1.0;
    
    self.quoteTopview.layer.borderColor = KHomeTextFieldGrayBorderColor;
    self.quoteTopview.layer.borderWidth = 1.0;

    quotesStatusArray = [[NSMutableArray alloc]initWithObjects:@"All",@"Sent",@"Viewed",@"On Website",@"Bought", nil];
    
    // Set logout view
    self.logOutView.hidden = YES;
    [self.logOutViewHeightConstraint setConstant:0];
    
    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    
    
    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    [self callAPIForGetQuotesList:1];
    
}

#pragma mark -
-(BOOL)isValidate {
    
    if (!txtCustomer.text.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter customer." onController:self];
    }
    else
        if (!txtEmail.text.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter email." onController:self];
        }
        else if ([PFUtility validateEmailAddress:txtEmail.text]){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid email." onController:self];
        }
        else if (!txtQuotesStatus.text.length){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select quotes status." onController:self];
        }
//        else if (!orderTypeTextField.text.length){
//            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select order type." onController:self];
//        }
        else if (!(allRangeButton.selected || todayRangeButton.selected || yesterdayRangeButton.selected || monthRangeButton.selected || dateRangeButton.selected)){
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select any range." onController:self];
        }
        else{
            return YES;
        }
    return NO;
}

#pragma mark - UIButton Action
- (IBAction)searchButtonAction:(id)sender {
    [self.view endEditing:YES];
    orderTypeButton.selected = NO;
    [self hideShowLogoutView];
  //  if ([self isValidate]) {
    [self callAPIForGetQuotesList:1];
    //}
}

- (IBAction)menuButtonACtion:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}
- (IBAction)commonButtonAction:(UIButton*)sender {
    
    allRangeButton.selected         = NO;
    todayRangeButton.selected       = NO;
    yesterdayRangeButton.selected   = NO;
    monthRangeButton.selected       = NO;
    dateRangeButton.selected        = NO;
    
 if (sender.tag == 600) {
        allRangeButton.selected = !allRangeButton.selected;
        modelObj.strRange = @"all";
    }
    else if (sender.tag == 601) {
        todayRangeButton.selected = !todayRangeButton.selected;
        modelObj.strRange = @"today";
    }
    else if (sender.tag == 602) {
        yesterdayRangeButton.selected = !yesterdayRangeButton.selected;
        modelObj.strRange = @"yesterday";
    }
    else if (sender.tag == 603) {
        monthRangeButton.selected = !monthRangeButton.selected;
        modelObj.strRange = @"month";
    }
    else if (sender.tag == 604) {
        dateRangeButton.selected = !dateRangeButton.selected;
        modelObj.strRange = @"date";
    }
}
- (IBAction)fromDateButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    fromOrToDatePickerValue = 1;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    dateFromTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    modelObj.strFromDate = [dateFormatter1 stringFromDate:[datePicker date]];
    
    fromDateButton.selected = !fromDateButton.selected;

    if (fromDateButton.selected)
    {
        [datePicker setHidden:NO];
        datePicker.backgroundColor = [UIColor whiteColor];
    }
    else
        [datePicker setHidden:YES];

  //  [_quotesTableView setHidden:YES];
}

- (IBAction)toDateButtonAction:(UIButton*)sender
{
    [self.view endEditing:YES];
    fromOrToDatePickerValue = 2;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    dateToTextField.text = [dateFormatter stringFromDate:[datePicker date]];

    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    modelObj.strTodate = [dateFormatter1 stringFromDate:[datePicker date]];

    fromDateButton.selected = !fromDateButton.selected;

    if (fromDateButton.selected)
    {
        [datePicker setHidden:NO];
        datePicker.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        [datePicker setHidden:YES];
    }
  //  [_quotesTableView setHidden:YES];
}


- (IBAction)dateSelection:(id)sender {
    
    [self.view endEditing:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    if (fromOrToDatePickerValue == 1) {
        dateFromTextField.text = [dateFormatter stringFromDate:[datePicker date]];
        modelObj.strFromDate = [dateFormatter1 stringFromDate:[datePicker date]];
    }
    else {
        dateToTextField.text = [dateFormatter stringFromDate:[datePicker date]];
        modelObj.strTodate = [dateFormatter1 stringFromDate:[datePicker date]];
    }
    
}

- (IBAction)orderTypeButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    datePicker.hidden = YES;
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 180;
    
    [_crewTableView setFrame:rect];
   
    orderTypeButton.selected = !orderTypeButton.selected;
    
    if (orderTypeButton.selected)
        [_crewTableView setHidden:NO];
    else
        [_crewTableView setHidden:YES];
    
    [_crewTableView reloadData];
    
}

- (IBAction)logOutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}
-(IBAction)editButtonAction:(UIButton *)sender{
    
    
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to editquote this record?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0)
        {
            PFQuotesListInfo *obj = [clientDataArray objectAtIndex:sender.tag-100];
            PFQuotesBuildViewController *vc = [[PFQuotesBuildViewController alloc]initWithNibName:@"PFQuotesBuildViewController" bundle:nil];
            vc.strQuoteId = obj.strId;
            
            [UIView  beginAnimations: @"Showinfo"context: nil];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.75];
            [self.navigationController pushViewController:vc animated:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];
        }
    }];
    
}

- (void)printButtonAction:(UIButton*)sender {
    
    PFQuotesListInfo *obj = [clientDataArray objectAtIndex:sender.tag-200];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.strPrintUrl]];
}

- (void)resendEmailButtonAction:(UIButton*)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Are you sure you want to resendEmail this record?" andButtonsWithTitle:[NSArray arrayWithObjects:@"OK",@"Cancel", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0)
        {
            [self callResendEmailServiceIntegration:sender.tag-300];
        }
    }];
}

#pragma mark -

#pragma mark - Other Helper Method

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

-(void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
    datePicker.hidden = YES;
    _crewTableView.hidden = YES;
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}
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

- (IBAction)hideButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    self.searchView.hidden = YES;
    self.addNewCustomerViewConstraint.constant = 30;
}

- (IBAction)showButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    self.searchView.hidden = NO;
    self.addNewCustomerViewConstraint.constant = 314;
}

//
- (IBAction)buildQuoteButtonAction:(id)sender {
    
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
            objVC.delegate = self;
            objVC.zipCode = self.zipCodeTextField.text;
            [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self.navigationController presentViewController:objVC animated:NO completion:nil];
        }
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

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];

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

#pragma mark - Selector Method

-(void)afterSomeTime {
    
    self.constraintTblViewHeight.constant = self.quotesTableView.contentSize.height;
    
}


#pragma mark - * * * TABLE VIEW DATASOURCE & DELEGATE METHOD * * * 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return (orderTypeButton.selected)? quotesStatusArray.count:clientDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(orderTypeButton.selected)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        }
        cell.textLabel.text=[quotesStatusArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
    PFQuotesListInfo *obj = [clientDataArray objectAtIndex:indexPath.row];
    PFQuotesTVC *cell = (PFQuotesTVC *)[self.quotesTableView dequeueReusableCellWithIdentifier:@"PFQuotesTVC"];
    cell.lblId.text             = obj.strId;
    cell.lblDate.text           = obj.strDate;
    cell.lblName.text           = obj.strName;
    cell.lblPhoneNumber.text    = obj.strPhoneNumber;
    cell.lblQuotes.text         = obj.strQuote;
    cell.lblEmail.text          = obj.strEmail;
    cell.lblStatus.text         = obj.strStatus;
    cell.lblRegisteredUser.text = obj.strRegisteredUser;
    
    cell.btnEdit.tag            = indexPath.row+100;
    cell.btnPrint.tag           = indexPath.row+200;
    cell.btnResentEmail.tag     = indexPath.row+300;
        [cell.btnEdit addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPrint addTarget:self action:@selector(printButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnResentEmail addTarget:self action:@selector(resendEmailButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(orderTypeButton.selected)
    {
        [txtQuotesStatus setText:[quotesStatusArray objectAtIndex:indexPath.row]];
        [_crewTableView setHidden:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (orderTypeButton.selected)?35:70;
}
#pragma mark - * * * COLLECTION VIEW DATASOURCE & DELEGATE METHOD * * *

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrOfCount.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PFCollectionCell * cell = (PFCollectionCell * )[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    PFQuotesListInfo * modalObj = [arrOfCount objectAtIndex:indexPath.item];
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
    [self callAPIForGetQuotesList:indexPath.item + 1];
    [self.collectionView reloadData];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];

    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];

    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];

    if ((str.length > 20 || !stringIsValid) && textField.tag == 300)
        return NO;
    else if (str.length > 100 && textField.tag == 301)
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

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - * * * SERVICE HELPER METHOD * * * 
-(void)callAPIForGetQuotesList:(NSInteger)pageNo
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"quoteList" forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageNo] forKey:@"pageNumber"];
    [dict setObject:txtCustomer.text forKey:@"customer"];
    [dict setObject:txtEmail.text forKey:@"email"];
    [dict setObject:@"" forKey:@"status"];
    [dict setObject:modelObj.strFromDate    forKey:@"date_from"];
    [dict setObject:modelObj.strTodate      forKey:@"date_to"];
    [dict setObject:modelObj.strRange       forKey:@"span"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [clientDataArray removeAllObjects];
                self.addNewCustomerViewConstraint.constant = 30;
                self.pagination = [Pagination getPaginationInfoFromDict:[response objectForKeyNotNull:@"pagination" expectedClass:[NSDictionary class]]];
                
                NSArray *quotesArray = [response objectForKeyNotNull:@"orderData" expectedClass:[NSArray class]];
                
                for (NSDictionary *quotesDict in quotesArray)
                {
                    PFQuotesListInfo *quotesInfo = [PFQuotesListInfo getQuotesList:quotesDict];
                    [clientDataArray addObject:quotesInfo];
                }
                if ([_pagination.maxPageNo intValue] > 1) {
                    self.bottomView.hidden = NO;
                }
                else {
                    self.bottomView.hidden = YES;
                }
                arrOfCount = [[NSMutableArray alloc] init];
                for (int i =1; i<=[self.pagination.maxPageNo integerValue]; i++) {
                    PFQuotesListInfo * modalObj = [[PFQuotesListInfo alloc]init];
                    modalObj.strCount = i;
                    if (i == pageNo) {
                        modalObj.isSelected = YES;
                    }
                    else
                    {
                        modalObj.isSelected = NO;
                    }
                    [arrOfCount addObject:modalObj];
                }
                [self.quotesTableView  reloadData];
                [self.collectionView reloadData];
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.001];
            }
            else
            {
            self.addNewCustomerViewConstraint.constant = 30;
             [clientDataArray removeAllObjects];
             [PFUtility alertWithTitle:@"" andMessage:kResponseMessage  andController:self];
             [self.quotesTableView reloadData];
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

-(void)callResendEmailServiceIntegration:(NSInteger)index{
    
    PFQuotesListInfo *obj = [clientDataArray objectAtIndex:index];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"resentQuoteEmail"forKey:@"action"];
    [dict setValue:obj.strId forKey:@"quote_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

@end
