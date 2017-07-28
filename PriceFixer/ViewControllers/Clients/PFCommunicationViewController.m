//
//  PFCommunicationViewController.m
//  PriceFixer
//
//  Created by Tejas Pareek on 15/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFCommunicationViewController.h"
#import "PFChatWebViewViewController.h"
#import "PFUtility.h"
#import "communicationQuoteTableViewCell.h"
#import "PFChatInfo.h"
#import "Macro.h"

@interface PFCommunicationViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
 //   NSArray *listArray;
    NSMutableArray *listArray;
    PFChatInfo *chatInfo;
    NSString *messageText;
}
@property (weak, nonatomic) IBOutlet UIView *viewMsg;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *msgTxtField;
- (IBAction)btnMessegeAction:(id)sender;

@end

@implementation PFCommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}
-(void)initialSetup{

    listArray = [NSMutableArray new];
    
    chatInfo = [[PFChatInfo alloc]init];
    
    [_tblView setEstimatedRowHeight:60];
    [_tblView registerNib:[UINib nibWithNibName:@"communicationQuoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"communicationQuoteTableViewCell"];
    
    self.sendButton.enabled = NO;
    
    [self callGetCommunicationServiceIntegration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [[_viewMsg layer]setBorderWidth:1];
    [[_viewMsg layer] setBorderColor:[UIColor colorWithRed:139/255.0f green:186/255.0f	 blue:242/255.0f alpha:1.0f].CGColor];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [[_viewMsg layer]setBorderWidth:0];
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

#pragma mark - Table View Delegate and Data source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    communicationQuoteTableViewCell *cell = (communicationQuoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"communicationQuoteTableViewCell"];
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    
    cell.viewChatLabel.layer.cornerRadius = 10;
    cell.messageLabel.layer.masksToBounds = YES;
    cell.clickToViewButton.tag = indexPath.row+100;
    
     chatInfo = [listArray objectAtIndex:indexPath.row];
    
    if (chatInfo.details.length)
        cell.clickToViewButton.hidden = NO;
    else
        cell.clickToViewButton.hidden = YES;
    
    if ([chatInfo.is_private isEqualToString:@"1"])
        cell.privateButton.hidden = NO;
    else
        cell.privateButton.hidden = YES;

    cell.messageLabel.text = chatInfo.title;
    
    cell.dateNtimeLabel.text = chatInfo.date;

    cell.userImageView.layer.cornerRadius = 30;
    cell.userImageView.layer.masksToBounds = YES;
    cell.userImageView.layer.borderWidth = 0;
    
    [cell.clickToViewButton addTarget:self action:@selector(clickToView:) forControlEvents:UIControlEventTouchUpInside];
    
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
}


#pragma mark - Selector Method

-(void)clickToView:(UIButton*)sender {
    
    chatInfo = [listArray objectAtIndex:sender.tag-100];

    PFChatWebViewViewController *chatWebView = [[PFChatWebViewViewController alloc]initWithNibName:@"PFChatWebViewViewController" bundle:nil];
    chatWebView.htmlContent = chatInfo.details;
    chatWebView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:chatWebView animated:YES completion:nil];
    
}

#pragma mark - * * * BUTTON ACTION * * *
- (IBAction)btnMessegeAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([messageText length]==0){
        
        [PFUtility alertWithTitle:@"Information" andMessage:@"Please enter your message." andController:self];
        
    }
    else{
        [self callPostCommunicationServiceIntegration];
    }

}


#pragma mark - service helper method
- (void)callGetCommunicationServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"clientCommunication"forKey:@"action"];
    [dict setValue:@"0" forKey:@"orderId"];
    [dict setValue:self.clientInfo.customer_id forKey:@"customer_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            NSArray *chatData = [response objectForKeyNotNull:@"chat_data" expectedClass:[NSArray class]];
            
            for (NSDictionary *dict in chatData) {
                chatInfo = [PFChatInfo chatListDict:dict];
                [listArray addObject:chatInfo];
            }
            [_tblView reloadData];
        }
        else{
            [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
    }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


-(void)callPostCommunicationServiceIntegration{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"sendMessage"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:messageText forKey:@"message"];
    [dict setValue:self.clientInfo.customer_id forKey:@"customer_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            self.msgTxtField.text = @"";
            messageText = @"";
            self.sendButton.enabled = NO;
            NSDictionary *chatDict = [response objectForKeyNotNull:@"chat_data" expectedClass:[NSDictionary class]];
            
                chatInfo = [PFChatInfo chatListDict:chatDict];
                [listArray addObject:chatInfo];

            if (listArray.count > 0) {
                [_tblView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[listArray count]-1 inSection:0];
                [self.tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
            else{
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
           [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

@end
