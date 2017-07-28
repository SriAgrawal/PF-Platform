//
//  PFSupportViewController.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 10/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFSupportViewController.h"

#import "PFEditClientViewController.h"
#import "TextField.h"
#import "PFProfileViewController.h"
#import "PFBillingViewController.h"
#import "PFCommunicationViewController.h"
#import "PFBuildQuoteVC.h"
#import "PFUtility.h"
#import "Macro.h"
#include "PFCreateSupportTicketViewController.h"

@interface PFSupportViewController ()<clientOrderProtocol,PFBuildQuoteVCDelegate,UIGestureRecognizerDelegate> {
    BOOL                isAnimated;
    PFTutorialNewVC *profileVC;
    PFFaqVC *faqVC;
    PFTutorialVC *tutorialVC;
    PFTicketVC *ticketVC;
    NSMutableArray *dropDownArray;
    NSMutableArray *dropDownNewArray;
    NSString *str_selectedID;
    NSInteger orderViewheight;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *tutorialNewButton;
@property (weak, nonatomic) IBOutlet UIButton *faqButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;
@property (weak, nonatomic) IBOutlet UIButton *ticketButton;


@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *dropDownTableView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet TextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBtnWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBtnHeightConstraints;


@end

@implementation PFSupportViewController


#pragma mark - Initial method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}

#pragma mark - Initial method

- (void)initialMethod {
    
    dropDownArray = [[NSMutableArray alloc] initWithObjects:@"Newest First",@"Oldest First",@"Watched",@"Unwatched", nil];
    dropDownNewArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<dropDownArray.count; i++) {
        
        PFTutorialInfo *obj = [[PFTutorialInfo alloc]init];
        obj.strTitle = [dropDownArray objectAtIndex:i];
        obj.strId = [NSString stringWithFormat:@"%d",i+1];
        if (i == 0)
            obj.isSelected =YES;
        else
         obj.isSelected = NO;
        
        [dropDownNewArray addObject:obj];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.searchTextField setPlaceholder:@"Search"];
    [self.searchTextField setReturnKeyType:UIReturnKeyDone];
    
    // Alloc Controller
      [self.dropDownTableView registerNib:[UINib nibWithNibName:@"PFDropDownTableCell" bundle:nil] forCellReuseIdentifier:@"PFDropDownTableCell"];
    
   // profileVC = [[PFTutorialNewVC alloc]initWithNibName:@"PFTutorialNewVC" bundle:nil];
    
    faqVC = [[PFFaqVC alloc]initWithNibName:@"PFFaqVC" bundle:nil];
    
    ticketVC = [[PFTicketVC alloc]initWithNibName:@"PFTicketVC" bundle:nil];
    
    tutorialVC = [[PFTutorialVC alloc]initWithNibName:@"PFTutorialVC" bundle:nil];
    
    // Set logout view
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];
    [self.viewHeightConstraint setConstant:200];
    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    [self displayController:faqVC];
    [self restoreButtonState];
    
    [self.faqButton setSelected:YES];

    self.faqButton.backgroundColor = KBtnSelectedColor;
    
    
    //Adding the notification observer for getting the height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewHeightNotification:)
                                                 name:@"viewHeightNotification"
                                               object:nil];
    
    //tapGesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark * * * DELEGATE METHOD * * *

- (void) viewHeightNotification:(NSNotification *) notification
{
    NSMutableDictionary *dic = notification.object;
    switch ([[dic valueForKey:@"Type"] intValue]) {
        case 1:{
            self.searchBtn.layer.cornerRadius = 19;
            self.searchBtn.clipsToBounds = YES;
            [self.searchBtn setTitle:@"Search" forState:UIControlStateNormal];
            [self.searchTextField setPlaceholder:@"Search"];
            self.searchBtnHeightConstraints.constant = 40;
            self.searchBtnWidthConstraints.constant = 155;
            self.dropDownView.hidden = NO;
            self.viewHeightConstraint.constant = [[dic valueForKey:@"Height"] floatValue];
            break;
        }
        case 2:
        {
            self.searchBtn.layer.cornerRadius = 19;
            self.searchBtn.clipsToBounds = YES;
            [self.searchBtn setTitle:@"Search" forState:UIControlStateNormal];
            [self.searchTextField setPlaceholder:@"Search"];
            self.searchBtnHeightConstraints.constant = 40;
            self.searchBtnWidthConstraints.constant = 155;
            self.dropDownView.hidden = YES;
            self.viewHeightConstraint.constant = [[dic valueForKey:@"Height"] floatValue];
        }
            break;
        case 3:{
            self.searchBtn.layer.cornerRadius = 19;
            self.searchBtn.clipsToBounds = YES;
            [self.searchBtn setTitle:@"Search" forState:UIControlStateNormal];
            [self.searchTextField setPlaceholder:@"Search"];
            self.searchBtnHeightConstraints.constant = 40;
            self.searchBtnWidthConstraints.constant = 155;
            self.dropDownView.hidden = NO;
            self.viewHeightConstraint.constant = [[dic valueForKey:@"Height"] floatValue];
            break;
        }
        case 4:
        {
            [self.searchTextField setPlaceholder:@"Search By Title"];
            self.viewHeightConstraint.constant = [[dic valueForKey:@"Height"] floatValue];
            [self.searchBtn setTitle:@"Create Support Ticket" forState:UIControlStateNormal];
            self.searchBtnHeightConstraints.constant = 50;
            self.searchBtnWidthConstraints.constant = 220;
            self.searchBtn.layer.cornerRadius = 25;
            self.searchBtn.clipsToBounds = YES;
            self.dropDownView.hidden = YES;
        }
            break;
        default:
            break;
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

#pragma mark - Selector Method

- (void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
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

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    
}

-(IBAction)commonButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([sender.titleLabel.text isEqualToString:@"Create Support Ticket"]) {
       
        PFCreateSupportTicketViewController *obj = [[PFCreateSupportTicketViewController alloc] initWithNibName:@"PFCreateSupportTicketViewController" bundle:nil];
        [self.navigationController pushViewController:obj animated:YES];

    }else {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setValue:[NSString stringWithFormat:@"%@",str_selectedID] forKey:@"ID"];
        [userInfo setValue:self.searchTextField.text forKey:@"search"];
        
        
        if (self.tutorialButton.selected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotification" object:userInfo];
        }else if (self.tutorialNewButton.selected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotificationForNewTutorial" object:userInfo];
        }else if (self.faqButton.selected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotificationForFAQ" object:userInfo];

        }
    }
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
    self.tutorialNewButton.backgroundColor = KAppGreenColor;
    self.faqButton.backgroundColor = KAppGreenColor;
    self.tutorialButton.backgroundColor = KAppGreenColor;
    self.ticketButton.backgroundColor = KAppGreenColor;
    [self.tutorialButton setSelected:NO];
    [self.faqButton setSelected:NO];
    [self.tutorialNewButton setSelected:NO];
    [self.ticketButton setSelected:NO];

}


#pragma mark - * * * TABLE VIEW DATASOURCE & DELEGATE METHOD * * *

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dropDownNewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PFDropDownTableCell";
    PFDropDownTableCell *cell = (PFDropDownTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =  (PFDropDownTableCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = (PFDropDownTableCell*) [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
       PFTutorialInfo *obj_tuto =   [dropDownNewArray objectAtIndex:indexPath.row];
    cell.dropDownLbl.text= obj_tuto.strTitle;
    cell.clikedBtn.tag = indexPath.row +100;
    if (obj_tuto.isSelected) {
        [cell.checkImageView setImage:[UIImage imageNamed:@"check2"]];
    }else{
        [cell.checkImageView setImage:[UIImage imageNamed:@""]];
    }
    [cell.clikedBtn addTarget:self action:@selector(clickedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark -

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    self.searchTextField.text = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSString stringWithFormat:@"%@",str_selectedID] forKey:@"ID"];
    [userInfo setValue:self.searchTextField.text forKey:@"search"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotification" object:userInfo];
    return YES;
}


#pragma mark -

#pragma mark - UITouch Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
    [self.dropDownTableView setHidden:YES];
}

#pragma mark -

#pragma mark - UIButton Action

-(void)clickedButtonAction :(UIButton *) sender {
    [self.view endEditing:YES];
    
    for (PFTutorialInfo *obj in dropDownNewArray) {
        obj.isSelected = NO;
    }
    
    PFTutorialInfo *obj_tuto =   [dropDownNewArray objectAtIndex:sender.tag-100];
    
    if (obj_tuto.isSelected) {
        obj_tuto.isSelected = NO;
    }else {
        obj_tuto.isSelected = YES;
    }
    str_selectedID = obj_tuto.strId;

    [self.dropDownBtn setTitle:obj_tuto.strTitle forState:UIControlStateNormal];
    self.dropDownTableView.hidden = YES;
    [self.dropDownTableView reloadData];

}



#pragma mark - UIButton Action
- (IBAction)searchButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    //  if ([self isValidate]) {
    //}
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSString stringWithFormat:@"%@",str_selectedID] forKey:@"ID"];
    [userInfo setValue:self.searchTextField.text forKey:@"search"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotification" object:userInfo];
}


- (IBAction)dropDownButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.dropDownTableView setHidden:NO];
    //  if ([self isValidate]) {
    //}
}
- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self.dropDownTableView setHidden:YES];
    //  [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}


- (IBAction)tutorialNewButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self restoreButtonState];
    [self.tutorialNewButton setSelected:YES];
    [self.dropDownTableView setHidden:YES];
    [self.searchBtn setTitle:@"" forState:UIControlStateNormal];
    [self.searchTextField setText:@""];
    [self.view endEditing:YES];
    [self displayController:profileVC];
    self.tutorialNewButton.backgroundColor = KBtnSelectedColor;
}

- (IBAction)FaqButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self restoreButtonState];
    [self.faqButton setSelected:YES];
    [self.dropDownTableView setHidden:YES];
    [self.searchBtn setTitle:@"" forState:UIControlStateNormal];
    [self.searchTextField setText:@""];
    [self.view endEditing:YES];
    [self displayController:faqVC];
    self.faqButton.backgroundColor = KBtnSelectedColor;

}

- (IBAction)tutorialButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self restoreButtonState];
    [self.tutorialButton setSelected:YES];
    [self.dropDownTableView setHidden:YES];
    [self.searchBtn setTitle:@"" forState:UIControlStateNormal];
    [self.searchTextField setText:@""];
    [self.view endEditing:YES];
    [self displayController:tutorialVC];
    self.tutorialButton.backgroundColor = KBtnSelectedColor;

}

- (IBAction)ticketAction:(id)sender
{
    [self.view endEditing:YES];
    [self restoreButtonState];
    [self.ticketButton setSelected:YES];
    [self.dropDownTableView setHidden:YES];
    [self.searchBtn setTitle:@"" forState:UIControlStateNormal];
    [self.searchTextField setText:@""];
    [self.view endEditing:YES];
    [self displayController:ticketVC];
    self.ticketButton.backgroundColor = KBtnSelectedColor;

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
