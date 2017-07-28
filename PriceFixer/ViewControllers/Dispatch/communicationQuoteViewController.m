//
//  communicationQuoteViewController.m
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 27/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import "communicationQuoteViewController.h"
#import "communicationQuoteTableViewCell.h"
#import "PFChatWebViewViewController.h"

@interface communicationQuoteViewController ()<UITextFieldDelegate> {
    
    NSString *messageText;
}
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;

@end

@implementation communicationQuoteViewController
@synthesize strOrderId;
@synthesize strEmployeId;
@synthesize strOrderCode;

#pragma mark - Status Bar Visibility Setting
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark -

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    communicationQuotePopUpView.layer.cornerRadius = 8;
    communicationQuotePopUpView.layer.masksToBounds = YES;
    
    if (self.fromOrder)
        CommunicationTitleLabel.text=[NSString stringWithFormat:@"Your Communication - %@",strOrderCode];
    else
        CommunicationTitleLabel.text=[strOrderCode stringByAppendingString:@" Communication"];
    
    self.sendButton.enabled = NO;
    
    messageArray=[[NSMutableArray alloc]initWithObjects:@"We are on the way, kindly wait for further information and do check updates regularly.We are on the way, kindly wait for further information and do check updates regularly. thanks",@"Testing. We are on the way, kindly wait for further information and do check updates regularly.We are on the way, kindly wait for further information and do check updates regularly. thanks. We are on the way, kindly wait for further information and do check updates regularly.We are on the way, kindly wait for further information and do check updates regularly. thanks",@"About to deliver",@"Hi", nil];
    
    backgroundViewForMessage.layer.cornerRadius = 4;
    backgroundViewForMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backgroundViewForMessage.layer.borderWidth = 1.0f;
    backgroundViewForMessage.layer.masksToBounds = YES;
    
     
    [messageTableView registerNib:[UINib nibWithNibName:@"communicationQuoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"communicationQuoteTableViewCell"];

    messageTableView.estimatedRowHeight = 44.0 ;
    messageTableView.rowHeight = UITableViewAutomaticDimension;
    
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listArray = [[NSMutableArray alloc]init];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self callGetCommunicationServiceIntegration];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark -

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


#pragma mark - Common Method For AlertView Display

-(void)moveViewUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, valueForViewMoveUp,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)callAlertView{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:alertTitle
                                 message:alertMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handle your yes please button action here
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -


#pragma mark - IB Actions

- (IBAction)closePopUpAction:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (IBAction)sendMessageAction:(id)sender{
    valueForViewMoveUp=0;
    [self moveViewUp];
    [self.view endEditing:YES];
    
    alertTitle=@"Information";
    if ([messageText length]==0){
        alertMessage=@"Please enter your message.";
        [self callAlertView];
        
    }
    else{
        [self callPostCommunicationServiceIntegration];
    }

}

- (IBAction)privateButtonAction:(id)sender {
    
    self.privateButton.selected = !self.privateButton.selected;
}

- (IBAction)hideKeyBoard:(id)sender{
    [self.view endEditing:YES];
    valueForViewMoveUp=0;
    [self moveViewUp];
}
#pragma mark -

#pragma mark - Text Field Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField;{
    valueForViewMoveUp=0;
    [self moveViewUp];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    valueForViewMoveUp=-300;
    [self moveViewUp];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    messageText = TRIM_SPACE(str);
    if (messageText.length) {
        self.sendButton.enabled = YES;
    }
    else {
        self.sendButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark -

#pragma mark - Table View Delegate and Data source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    communicationQuoteTableViewCell *cell = (communicationQuoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"communicationQuoteTableViewCell"];
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
   
    cell.messageLabel.layer.cornerRadius = 19;
    cell.messageLabel.layer.masksToBounds = YES;
    cell.clickToViewButton.tag = indexPath.row + 200;
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    
    NSDictionary *dict_chat = [listArray objectAtIndex:indexPath.row];
    
    if ([[dict_chat valueForKey:@"details"] length]) {
        [cell.clickToViewButton setHidden:NO];
    }else{
        [cell.clickToViewButton setHidden:YES];
    }
    
    
    if ([[dict_chat valueForKey:@"is_private"] isEqualToString:@"1"]) {
        [cell.privateButton setHidden:NO];
    }else{
        [cell.privateButton setHidden:YES];
    }
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[dict_chat valueForKey:@"title"] attributes:@{ NSParagraphStyleAttributeName : style}];
    
    cell.messageLabel.numberOfLines = 0;
    cell.messageLabel.attributedText = attrText;
    
    cell.dateNtimeLabel.text=[dict_chat valueForKey:@"date"];
    
    cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.height /2;
    cell.userImageView.layer.masksToBounds = YES;
    cell.userImageView.layer.borderWidth = 0;
    
    [cell.clickToViewButton addTarget:self action:@selector(ClickToOpenWebView:) forControlEvents:UIControlEventTouchUpInside];


    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
          return [listArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    valueForViewMoveUp=0;
    [self moveViewUp];
}

- (void) onKeyboardHide:(NSNotification *)notification{
    valueForViewMoveUp=0;
    [self moveViewUp];
    
}


-(void) ClickToOpenWebView:(UIButton*)sender {
    
    NSDictionary *tempDict = [listArray objectAtIndex:sender.tag-200];

    PFChatWebViewViewController *obj = [[PFChatWebViewViewController alloc]initWithNibName:@"PFChatWebViewViewController" bundle:nil];
    obj.htmlContent = [tempDict objectForKeyNotNull:@"details" expectedClass:[NSString class]];
    obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
}

#pragma mark -

#pragma mark - service helper method
-(void)callGetCommunicationServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"clientCommunication"forKey:@"action"];
    [dict setValue:strOrderId forKey:@"order_id"];
    [dict setValue:@"0" forKey:@"customer_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
             
             NSArray *araLIs = [response objectForKeyNotNull:@"chat_data" expectedClass:[NSArray class]];
             [listArray removeAllObjects];
             for (NSDictionary *dict in araLIs) {
                 [listArray  addObject:dict];
             }
             
             [messageTableView reloadData];
             if (listArray.count > 0) {
                 [messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[listArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
         }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
         else
             [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];

     }];
}

-(void)callPostCommunicationServiceIntegration{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"sendMessage"forKey:@"action"];
            [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
            [dict setValue:strOrderId forKey:@"order_id"];
            [dict setValue:@"0" forKey:@"customer_id"];
            [dict setValue:messageText forKey:@"message"];
            [dict setValue:(self.privateButton.selected)?@"1":@"0" forKey:@"is_private"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                     messageTextField.text = @"";
                     self.sendButton.enabled = NO;
                     [self callGetCommunicationServiceIntegration];
                 }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
             }];
}

#pragma mark -


@end
