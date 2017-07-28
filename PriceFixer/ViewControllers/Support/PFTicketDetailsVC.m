//
//  PFTicketDetailsVC.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 16/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFTicketDetailsVC.h"
#import "Macro.h"
#import "PFTicketDetailsInfo.h"

@interface PFTicketDetailsVC ()<clientOrderProtocol,PFBuildQuoteVCDelegate,UIGestureRecognizerDelegate>{
    BOOL                isAnimated;
    PFTutorialNewVC *profileVC;
    PFFaqVC *faqVC;
    PFTutorialVC *tutorialVC;
    PFTicketVC *ticketVC;
    NSMutableArray *dropDownArray;
    NSInteger orderViewheight;
    PFTicketDetailsInfo *ticketObj;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *AssignToLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;
@property (weak, nonatomic) IBOutlet UIWebView *ckEditWebView;
@property (weak, nonatomic) IBOutlet UITableView *messageTabelView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *closedDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *closedLabel;


@end

@implementation PFTicketDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ticketLabel.text = self.tickeTitle;
    ticketObj = [[PFTicketDetailsInfo alloc] init];
    [self callTicketDetailsServiceIntegration];
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Initial method

- (void)initialMethod {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // Alloc Controller
    [self.messageTabelView registerNib:[UINib nibWithNibName:@"PFTicketMessageCell" bundle:nil] forCellReuseIdentifier:@"PFTicketMessageCell"];
    
    // Set logout view
    [self.logOutViewHeightConstraint setConstant:0];
    [self.viewHeightConstraint setConstant:windowHeight];
    [self.logOutView setHidden:YES];
    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    // Set UserName
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    //Adding the notification observer for getting the height
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewHeightNotification:)
                                                 name:@"viewHeightNotification"
                                               object:nil];
    
    self.closedLabel.hidden = YES;
    self.closedDateLbl.hidden = YES;
    self.closeButton.hidden = YES;
    
    [self showTicketDetail];
    
    //tapGesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
//    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.ckEditWebView.scrollView.scrollEnabled = NO;
    self.ckEditWebView.scrollView.bounces = NO;
    [super viewDidLoad];
    [self loadContent];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Load content locally.

- (void)loadContent {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"/CKEditor/demo.html" ofType:@""];
    [self.ckEditWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
#pragma mark - WebView Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.ckEditWebView stringByEvaluatingJavaScriptFromString:
     @"document.body.style.margin='0';document.body.style.padding = '0'"];
    [self.ckEditWebView stringByEvaluatingJavaScriptFromString:
     ticketObj.strMessageDescription];
    [self.ckEditWebView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('editor').focus();"];
}
-(void)showTicketDetail{

    self.dateLabel.text = ticketObj.strDate;
    self.AssignToLabel.text = ticketObj.strAssignTo;
    self.statusLabel.text = ticketObj.strStatus;
    self.priorityLabel.text = ticketObj.strPriorty;
    self.createdByLabel.text = ticketObj.strCreatedBy;
    self.messageLabel.text   = ticketObj.strMessage;
    

    //Manage the Color of Status
    if ([ticketObj.strStatus isEqualToString:@"Pending"]) {
        self.statusLabel.backgroundColor = RGBCOLOR( 217, 83, 79, 1.0);
    }
    else if ([ticketObj.strStatus isEqualToString:@"Working"]){
        self.statusLabel.backgroundColor = RGBCOLOR( 240, 173, 78, 1.0);
    }
    else
        self.statusLabel.backgroundColor = RGBCOLOR( 92, 184, 92, 1.0);
    
    //Manage the Color of Priority
    if ([ticketObj.strPriorty isEqualToString:@"Urgent"]) {
        self.priorityLabel.backgroundColor = RGBCOLOR( 217, 83, 79, 1.0);
    }
    else if ([ticketObj.strPriorty isEqualToString:@"Medium"]){
        self.priorityLabel.backgroundColor = RGBCOLOR( 240, 173, 78, 1.0);
    }
    else
        self.priorityLabel.backgroundColor = RGBCOLOR( 21, 122, 183, 1.0);
    
    
    //Close Button Use case
    
    if ([ticketObj.strClosedStatus isEqualToString:@"Close Ticket"]){
        
        self.closeButton.hidden = NO;
        self.closedDateLbl.hidden = YES;
        self.closedLabel.hidden = YES;
        self.sendView.hidden = NO;
        self.sendViewHeightConstraint.constant = 310.0f;
        
    }
    else{
        
        self.sendView.hidden = YES;
        self.sendViewHeightConstraint.constant = 0.0f;
        self.closeButton.hidden = YES;
        self.closedDateLbl.hidden = NO;
        self.closedLabel.hidden = NO;
        self.closedDateLbl.text = ticketObj.strClosedStatus;
    }
}


#pragma mark * * * DELEGATE METHOD * * *

- (void) viewHeightNotification:(NSNotification *) notification
{


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

#pragma mark - * * * TABLE VIEW DATASOURCE & DELEGATE METHOD * * *

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [ticketObj.strMessageArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PFTicketMessageCell";
    PFTicketMessageCell *cell = (PFTicketMessageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =  (PFTicketMessageCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = (PFTicketMessageCell*) [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    PFTicketDetailsInfo *messageObj = [ticketObj.strMessageArray objectAtIndex:indexPath.row];
    cell.ownerLabel.text = messageObj.strMessageUserName;
    cell.dateLabel.text = messageObj.strDate;
    [cell.messageWebView loadHTMLString:messageObj.strMessageDescription baseURL:nil];
    if ([messageObj.strMessageFile_name isEqualToString:@""]) {
        cell.viewButton.hidden = YES;
        cell.bottomConstraints.constant = 0;
    }
    else{
        cell.viewButton.hidden = NO;
        cell.bottomConstraints.constant = 29;
        cell.viewButton.tag = indexPath.row + 200;
    [cell.viewButton addTarget:self action:@selector(viewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.messageWebView.scrollView.scrollEnabled = NO;
    cell.messageWebView.scrollView.bounces = NO;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

-(void)viewButtonAction:(UIButton *)sender{
    PFTicketDetailsInfo *messageObj = [ticketObj.strMessageArray objectAtIndex:sender.tag % 200];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:messageObj.strMessageFile_name]];

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

#pragma mark - UITouch Method

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
    // do something, like dismiss your view controller, picker, etc., etc.
}

#pragma mark - UIButton Action
- (IBAction)menuButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}


- (IBAction)logOutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}
- (IBAction)closeTicket:(id)sender {
    [self.view endEditing:YES];
    [self callCloseTicketServiceIntegration];
}
- (IBAction)sendMessage:(id)sender {
    [self.view endEditing:YES];
    if ([[self getHtmlData] length]) {
        [self callSendMeassage: [self getHtmlData]];
    }
}
-(NSString *) getHtmlData{
    NSString *html = [self.ckEditWebView stringByEvaluatingJavaScriptFromString:
                      @"CKEDITOR.instances.editor.getData()"];
    return html;
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

- (void)callTicketDetailsServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"ticketDetail"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kShop_id] forKey:@"shop_id"];
    [dict setValue:self.ticketId forKey:@"id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                ticketObj = [PFTicketDetailsInfo getTicketDetails:[response objectForKeyNotNull:kResponseData expectedClass:[NSDictionary class]]];
                
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:1.0];
                [self initialMethod];
                [self.messageTabelView reloadData];
                
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}
- (void)callCloseTicketServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"closeTicket"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:self.ticketId forKey:@"ticket_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
//                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
                [self callTicketDetailsServiceIntegration];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}
- (void)callSendMeassage:(NSString *)message {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"sendNewMessage"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:self.ticketId forKey:@"ticket_id"];
    [dict setValue:message forKey:@"description"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self callTicketDetailsServiceIntegration];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


//Helper Method
- (void)afterSomeTime{
    
    NSLog(@"Table Height %f",_messageTabelView.contentSize.height);
    NSLog(@"Total Height %f",self.mainView.frame.size.height + _messageTabelView.contentSize.height);
    self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + _messageTabelView.contentSize.height;
}
@end
