//
//  PFClientVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 03/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFClientVC.h"
#import "PFClientTableViewCell.h"
#import "PFEditClientViewController.h"
#import "PFAddNewCustomerViewController.h"
#import "PFClientModelInfo.h"
#import "PFBuildQuoteVC.h"
#import "TextField.h"
#import "PFUtility.h"

static NSString * cellIdentifier = @"clientCellID";

@interface PFClientVC ()<UITextFieldDelegate,addNewClientProtocol, PFBuildQuoteVCDelegate> {
    
    BOOL                isAnimated;
    NSMutableArray *clientDataArray;
    PFClientModelInfo *clientInfo;
    NSString *status;
    BOOL isLoadMoreExecuting;
    BOOL isCallSearchApi;
    NSMutableArray      *arrOfCount;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewCustomerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *clientTableView;
@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet TextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) IBOutlet UIButton *inActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *allUserButton;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIButton *prevbutton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) Pagination *pagination;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation PFClientVC

#pragma mark -

#pragma mark - View controller life cycle method

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialMethod];
}

#pragma mark -

#pragma mark - Initial method
- (void)initialMethod {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.clientTableView registerNib:[UINib nibWithNibName:@"PFClientTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.clientTableView.scrollEnabled = NO;
    
    // Alloc Client DataArray
    clientDataArray = [NSMutableArray array];
    
    // Alloc Model Class
    clientInfo = [[PFClientModelInfo alloc]init];
    
    isLoadMoreExecuting = NO;
    self.pagination = [[Pagination alloc] init];
    self.bottomView.hidden = YES;
    
    // Initial hide search view
    self.searchView.hidden = YES;
    self.addNewCustomerViewConstraint.constant = 10;
    self.clientTableView.hidden = YES;

    // Set logout view
    self.logOutView.hidden = YES;
    [self.logOutViewHeightConstraint setConstant:0];

    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;

    self.activeButton.selected = YES;
    isCallSearchApi = NO;
    status = @"1";

    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];

    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];

    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    [self methodForSetupCollectionview];
    
    [self callClientListServiceIntegration:1];
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

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (isCallSearchApi)
        [self callSearchClientListServiceIntegration:indexPath.item + 1];
    else
        [self callClientListServiceIntegration:indexPath.item + 1];
    
    [self.collectionView reloadData];
}

#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return clientDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFClientTableViewCell * cell = (PFClientTableViewCell *)[self.clientTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.editButton.tag = indexPath.row + 100;
    clientInfo = [clientDataArray objectAtIndex:indexPath.row];
    
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",clientInfo.first_name,clientInfo.last_name];
    cell.emailLabel.text = clientInfo.email;
    cell.phoneLabel.text = clientInfo.phone;
    cell.dateJoinedLabel.text = clientInfo.registered_on;
    cell.activeLabel.text = ([clientInfo.is_active boolValue])?@"Active":@"In-Active";
    
    [cell.editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57.0;
}


#pragma mark -

#pragma mark - Selector Method

-(void)afterSomeTime {
    
    self.tableViewHeightConstraint.constant = self.clientTableView.contentSize.height;
    
}

-(void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}

-(void)editButton:(UIButton *)sender {
    
    PFEditClientViewController *editVC = [[PFEditClientViewController alloc]initWithNibName:@"PFEditClientViewController" bundle:nil];
    clientInfo = [clientDataArray objectAtIndex:sender.tag-100];
    editVC.clientInfo = clientInfo;
    [self.navigationController pushViewController:editVC animated:YES];
}


#pragma mark -

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
    
    //    if (textField.tag == 300)
    //        textField.inputAccessoryView = toolBarForNumberPad(self,@"Done");
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark -

#pragma mark - UIButton Action

- (void)backToClientVC {
    
    [self callClientListServiceIntegration:1];
}

#pragma mark -

#pragma mark - UIButton Action

- (IBAction)menuButtonACtion:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}

- (IBAction)hideButtonAction:(id)sender {
    
    [self hideShowLogoutView];
//    _showButton.backgroundColor = [UIColor colorWithRed:230/255.0f green:109/255.0f blue:26/255.0f alpha:1.0f];
//    _hideButton.backgroundColor = [UIColor colorWithRed:198/255.0f green:198/255.0f blue:198/255.0f alpha:1.0f];
    self.searchView.hidden = YES;
    self.addNewCustomerViewConstraint.constant = 10;
}

- (IBAction)showButtonAction:(id)sender {
    
    [self hideShowLogoutView];
//    _hideButton.backgroundColor = [UIColor colorWithRed:230/255.0f green:109/255.0f blue:26/255.0f alpha:1.0f];
//    _showButton.backgroundColor = [UIColor colorWithRed:198/255.0f green:198/255.0f blue:198/255.0f alpha:1.0f];
    self.searchView.hidden = NO;
    self.addNewCustomerViewConstraint.constant = 147;
    
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

- (IBAction)searchButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    
    [self callSearchClientListServiceIntegration:1];
    
}

- (IBAction)addNewCustomerButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFAddNewCustomerViewController *obj = [[PFAddNewCustomerViewController alloc] initWithNibName:@"PFAddNewCustomerViewController" bundle:nil];
    obj.delegate = self;
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)commonButtonAction:(UIButton*)sender {
    
    if (sender.tag == 600) {
        self.activeButton.selected   = YES;
        self.inActiveButton.selected = NO;
        self.allUserButton.selected  = NO;
        status = @"1";
    }
    else if (sender.tag == 601) {
        self.activeButton.selected   = NO;
        self.inActiveButton.selected = YES;
        self.allUserButton.selected  = NO;
        status = @"0";
    }
    else {
        self.activeButton.selected   = NO;
        self.inActiveButton.selected = NO;
        self.allUserButton.selected  = YES;
        status = @"";
    }
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

-(void)callClientListServiceIntegration: (NSInteger) pageNumber {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"getShopCustomers"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kShop_id] forKey:kShop_id];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"pageNumber"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            NSArray *customerList = [response objectForKeyNotNull:@"customerData" expectedClass:[NSArray class]];

            isLoadMoreExecuting = NO;
            self.clientTableView.hidden = NO;

            self.pagination = [Pagination getPaginationInfoFromDict:[response objectForKeyNotNull:@"pagination" expectedClass:[NSDictionary class]]];

            [clientDataArray removeAllObjects];
            
            for (NSDictionary *tempDict in customerList) {
                
                clientInfo = [PFClientModelInfo modelCustomerListDict:tempDict];
                [clientDataArray addObject:clientInfo];
            }
            [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
            
            self.clientTableView.delegate = self;
            self.clientTableView.dataSource = self;
            
            if ([_pagination.maxPageNo intValue] > 1) {
                self.bottomView.hidden = NO;
            }
            else {
                self.bottomView.hidden = YES;
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
            [self.clientTableView reloadData];
        }
            else if([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 0) {
                [clientDataArray removeAllObjects];
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                self.clientTableView.hidden = YES;
                self.bottomView.hidden = YES;
                [self.clientTableView reloadData];
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

- (void) callSearchClientListServiceIntegration: (NSInteger) pageNumber {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"searchCustomer"forKey:@"action"];
    [dict setValue:self.searchTextField.text forKey:kKeyword];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"pageNumber"];

    [dict setValue:status forKey:kStatus];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            self.searchView.hidden = YES;
            self.addNewCustomerViewConstraint.constant = 10;
            self.searchTextField.text = @"";
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            NSArray *customerList = [response objectForKeyNotNull:@"customerData" expectedClass:[NSArray class]];
            isLoadMoreExecuting = NO;
            isCallSearchApi = YES;
            self.clientTableView.hidden = NO;
            self.pagination = [Pagination getPaginationInfoFromDict:[response objectForKeyNotNull:@"pagination" expectedClass:[NSDictionary class]]];
                
            [clientDataArray removeAllObjects];
            for (NSDictionary *tempDict in customerList) {
                
                clientInfo = [PFClientModelInfo modelCustomerListDict:tempDict];
                [clientDataArray addObject:clientInfo];
            }
            [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
            
            self.clientTableView.delegate = self;
            self.clientTableView.dataSource = self;
            
            [self.clientTableView reloadData];
                
                
                if ([_pagination.maxPageNo intValue] > 1) {
                    self.bottomView.hidden = NO;
                }
                else {
                    self.bottomView.hidden = YES;
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
                [self.clientTableView reloadData];
            }
            else if([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 0) {
                [clientDataArray removeAllObjects];
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                self.clientTableView.hidden = YES;
                self.bottomView.hidden = YES;
                [self.clientTableView reloadData];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}




@end
