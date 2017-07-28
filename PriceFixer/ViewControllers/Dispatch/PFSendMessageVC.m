//
//  PFSendMessageVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 02/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFSendMessageVC.h"

@interface PFSendMessageVC ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UILabel *lblSelectQuote;
    IBOutlet UITextField *userTextField;
    IBOutlet UIButton *inRouteButton;
    IBOutlet UIButton *arrivedButton;
    IBOutlet UIButton *eightyPercentButton;
    IBOutlet UIButton *hundreadPercentButton;
    IBOutlet UIButton *installationSetButton;

    IBOutlet UIView *messageOuterView;
    IBOutlet UIView *processView;
    IBOutlet UIView *communicationPopUpView;

    
    UITableView *quoteTableView;

    IBOutlet NSLayoutConstraint *selectQuoteLblHeight;
    IBOutlet NSLayoutConstraint *sendBtnTopConstraint;
    IBOutlet NSLayoutConstraint *popupHeightConstraint;
    NSIndexPath *indexpath;
    
    float valueForViewMoveUp;
    NSString *status;
    NSString *selectedQuote;
    NSString *statusFromServer;
    NSMutableArray      *dispatchDataSourceArray;
}

@property (strong, nonatomic) IBOutlet TextView *textViewMessage;

@end

@implementation PFSendMessageVC

#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textViewMessage setPlaceholderText:@"Type Message"];
    [self.textViewMessage setBackgroundColor:[UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.f]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    
    popupHeightConstraint.constant = 300.f;
    sendBtnTopConstraint.constant = 180.f;
    selectQuoteLblHeight.constant = 120.f;
    
    [messageOuterView setHidden:YES];
    [processView setHidden:YES];
    [lblSelectQuote setHidden:NO];
    
    //*****************************Create quote table view*******************//
    quoteTableView=[[UITableView alloc]initWithFrame:CGRectMake(152, 358, 720, 100) style:UITableViewStylePlain];
    quoteTableView.dataSource=self;
    quoteTableView.delegate=self;
    quoteTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    quoteTableView.layer.cornerRadius = 6;
    quoteTableView.layer.masksToBounds = YES;
    quoteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    quoteTableView.hidden=YES;
    [self.view addSubview:quoteTableView];
    //***************************************************************************//
    
    dispatchDataSourceArray = [[NSMutableArray alloc] init];
    
    [self callgetMessageDispatchServiceIntegration];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark -

#pragma mark - Text View Delegate Methods
- (void)textViewDidBeginEditing:(UITextField *)textField{
    valueForViewMoveUp=-300;
    [self moveViewUp];
}

#pragma mark -

#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==quoteTableView){
        return [dispatchDataSourceArray count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.text= [NSString stringWithFormat:@"%@ %@",obj.strMessageOrderCode,obj.strMessageCustomerName];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    quoteTableView.hidden=YES;
    PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexPath.row];
    userTextField.text=obj.strMessageOrderCode;
    indexpath = indexPath;
    self.textViewMessage.text = @"";
    
    [self hideUnhideRouteButton:indexPath.row];
   // [self callGetCommunicationServiceIntegration:obj.strMessageOrderId custName:obj.strMessageCustomerName];
}


#pragma mark - IBActions
- (IBAction)hideTableView:(id)sender{
    [self.view endEditing:YES];
    valueForViewMoveUp=0;
    [self moveViewUp];
    
}

- (IBAction)sendSelection:(id)sender{
    valueForViewMoveUp=0;
    [self moveViewUp];
    [self.view endEditing:YES];
    

    if ([userTextField.text length]==0){
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Information" andMessage:@"Please select quote." onController:self];
    }
    else if ([self.textViewMessage.text length]==0){
       
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Information" andMessage:@"Please enter your message." onController:self];
    }else{
        PFDispatchModel *obj = [dispatchDataSourceArray objectAtIndex:indexpath.row];

        [self callPostCommunicationServiceIntegration:obj.strMessageOrderId empId:obj.strMessageCustomerId];
    }
    
}

- (IBAction)closeBtnAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (IBAction)installationSetButtonAction:(id)sender {
    
    if (installationSetButton.enabled)
    {
        selectedQuote=@"Installation Set";
        status=@"3";
        self.textViewMessage.text = @"Installation set predefined text";

        installationSetButton.enabled=NO;
        inRouteButton.enabled=YES;
        arrivedButton.enabled=YES;
        eightyPercentButton.enabled=YES;
        hundreadPercentButton.enabled=YES;
    }
}


- (IBAction)inRouteSelection:(id)sender{
    if (inRouteButton.enabled)
    {
        selectedQuote=@"In Route";
        status=@"4";
        self.textViewMessage.text = @"In route predefined text";
        inRouteButton.enabled=NO;
        arrivedButton.enabled=YES;
        eightyPercentButton.enabled=YES;
        hundreadPercentButton.enabled=YES;
        installationSetButton.enabled=NO;
        
        if ([statusFromServer isEqualToString:@"Installation Set"])
        {
            installationSetButton.enabled=NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=YES;
        }
        
    }}

- (IBAction)arrivedSelection:(id)sender{
    if (arrivedButton.enabled)
    {
        selectedQuote=@"80% Complete";
        status=@"5";
        self.textViewMessage.text = @"arrived predefined text";

        if ([statusFromServer isEqualToString:@"Installation Set"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=YES;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=YES;
        }
        else if ([statusFromServer isEqualToString:@"In Route"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=YES;
        }
//        else if ([statusFromServer isEqualToString:@"2"])
//        {
//            installationSetButton.enabled = NO;
//            inRouteButton.enabled=NO;
//            arrivedButton.enabled=NO;
//            eightyPercentButton.enabled=YES;
//            hundreadPercentButton.enabled=YES;
//        }
        
        
        
    }
}

- (IBAction)eightyCompleteSelection:(id)sender{
    if (eightyPercentButton.enabled)
    {
        selectedQuote=@"100% Complete";
        status=@"6";
        self.textViewMessage.text = @"80% Complete predefined text";

        if ([statusFromServer isEqualToString:@"Installation Set"])
        {
            inRouteButton.enabled=YES;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=NO;
            hundreadPercentButton.enabled=YES;
            installationSetButton.enabled = NO;
        }
        else if ([statusFromServer isEqualToString:@"In Route"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=NO;
            hundreadPercentButton.enabled=YES;
        }
        else if ([statusFromServer isEqualToString:@"Arrived"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=NO;
            hundreadPercentButton.enabled=YES;
        }
//        else if ([statusFromServer isEqualToString:@"3"])
//        {
//            installationSetButton.enabled = NO;
//            inRouteButton.enabled=NO;
//            arrivedButton.enabled=NO;
//            eightyPercentButton.enabled=NO;
//            hundreadPercentButton.enabled=YES;
//        }
    }
    
}

- (IBAction)hundreadCompleteSelection:(id)sender{
    if (hundreadPercentButton.enabled)
    {
        selectedQuote=@"100";
        status=@"7";
        self.textViewMessage.text = @"100% complete predefined text";

        if ([statusFromServer isEqualToString:@"Installation Set"])
        {
            inRouteButton.enabled=YES;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;
            
        }
        else if ([statusFromServer isEqualToString:@"In Route"])
        {
            inRouteButton.enabled=NO;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;
            
        }
        else if ([statusFromServer isEqualToString:@"Arrived"])
        {
            inRouteButton.enabled=NO;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;
            
        }
        else if ([statusFromServer isEqualToString:@"80% Complete"])
        {
            inRouteButton.enabled=NO;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=NO;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;
            
        }
//        else if ([statusFromServer isEqualToString:@"4"])
//        {
//            inRouteButton.enabled=NO;
//            arrivedButton.enabled=NO;
//            eightyPercentButton.enabled=NO;
//            hundreadPercentButton.enabled=NO;
//            installationSetButton.enabled = NO;
//            
//        }
    }

}

- (IBAction)quoteBtnAction:(UIButton *)sender {
    if (quoteTableView.hidden==NO){
        quoteTableView.hidden=YES;
    }
    else{
        quoteTableView.hidden=NO;
        
        [self.view endEditing:YES];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(0, 0.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark -

#pragma mark - Common Method For AlertView Display
-(void)moveViewUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, valueForViewMoveUp,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark -

#pragma mark - Keyboard notification
- (void) onKeyboardHide:(NSNotification *)notification{
    valueForViewMoveUp=0;
    [self moveViewUp];
}

#pragma mark -

#pragma mark - service helper method
-(void)callgetMessageDispatchServiceIntegration{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"userMessageList"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            [dispatchDataSourceArray removeAllObjects];

            NSArray *DispatchListArray = [response objectForKeyNotNull:@"dispatchList" expectedClass:[NSArray class]];
            for (NSMutableDictionary *dispatchDict in DispatchListArray) {
                PFDispatchModel *dispatchInfo = [PFDispatchModel modelMessageOrderListDict:dispatchDict];
                [dispatchDataSourceArray addObject:dispatchInfo];
            }
            [quoteTableView reloadData];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

- (void)hideUnhideRouteButton:(NSInteger)index {
    
    PFDispatchModel *dispatchInfo = [dispatchDataSourceArray objectAtIndex:index];
    
    statusFromServer = dispatchInfo.strOrderStatus;
    if ([dispatchInfo.strOrderStatus isEqualToString:@"Installation Set"]){
        inRouteButton.enabled=YES;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [inRouteButton setBackgroundImage:[UIImage imageNamed:@"icon20"] forState:UIControlStateNormal];
        [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
        [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
        [installationSetButton setBackgroundImage:nil forState:UIControlStateNormal];

        [inRouteButton setImage:[UIImage imageNamed:@"arrivedBlue"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([dispatchInfo.strOrderStatus isEqualToString:@"In Route"]){
        inRouteButton.enabled=NO;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
        [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
        [inRouteButton setBackgroundImage:nil forState:UIControlStateNormal];
        [installationSetButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([dispatchInfo.strOrderStatus isEqualToString:@"Arrived"]){
        inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
        [inRouteButton setBackgroundImage:nil forState:UIControlStateNormal];
        [arrivedButton setBackgroundImage:nil forState:UIControlStateNormal];
        [installationSetButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([dispatchInfo.strOrderStatus isEqualToString:@"80% Complete"]){
        inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
        [inRouteButton setBackgroundImage:nil forState:UIControlStateNormal];
        [arrivedButton setBackgroundImage:nil forState:UIControlStateNormal];
        [eightyPercentButton setBackgroundImage:nil forState:UIControlStateNormal];
        [installationSetButton setBackgroundImage:nil forState:UIControlStateNormal];

        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([dispatchInfo.strOrderStatus isEqualToString:@"100% Complete"] || [dispatchInfo.strOrderStatus isEqualToString:@"Cancelled"] || [dispatchInfo.strOrderStatus isEqualToString:@""]){
        inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=NO;installationSetButton.enabled =NO;
        
        [inRouteButton setBackgroundImage:nil forState:UIControlStateNormal];
        [arrivedButton setBackgroundImage:nil forState:UIControlStateNormal];
        [eightyPercentButton setBackgroundImage:nil forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:nil forState:UIControlStateNormal];
        [installationSetButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Gray"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        popupHeightConstraint.constant = 568.f;
                        sendBtnTopConstraint.constant = 438.f;
                        selectQuoteLblHeight.constant = 409.f;
                        
                        
                        [messageOuterView setHidden:NO];
                        [processView setHidden:NO];
                        [lblSelectQuote setHidden:YES];
                        
                        [quoteTableView setFrame:CGRectMake(152, 225, 720, 100)];
                        
                    }
                    completion:^(BOOL finished) {
                    }];

}




-(void)callGetCommunicationServiceIntegration :(NSString*)strOrderId custName:(NSString*)strCustomerName{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:@"getcommunication"forKey:@"action"];
    [params setValue:strOrderId forKey:@"orderId"];
    [params setValue:@"" forKey:@"is_repair"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:params AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
         
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                //  for (NSDictionary *dict in [result objectForKey:@"communication"]){
             
             
             NSDictionary *dict_communication = [response objectForKeyNotNull:@"communication" expectedClass:[NSDictionary class]];
             
                     userTextField.text = [NSString stringWithFormat:@"%@ %@",[dict_communication objectForKey:@"orderCode "],strCustomerName];
                
                     statusFromServer=[[dict_communication objectForKey:@"orderStatus"] stringValue];
                     
                     if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"0"]){
                         inRouteButton.enabled=YES;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"1"]){
                         inRouteButton.enabled=NO;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"2"]){
                         inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"3"]){
                         inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"4"]|| [[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"5"]){
                         inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=NO;installationSetButton.enabled =NO;
                     }
//                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"0"]){
//                        inRouteButton.enabled=YES;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled = YES;
//                     }
               //  }
                 
                 [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     popupHeightConstraint.constant = 568.f;
                                     sendBtnTopConstraint.constant = 438.f;
                                     selectQuoteLblHeight.constant = 409.f;
                                     
                                     
                                     [messageOuterView setHidden:NO];
                                     [processView setHidden:NO];
                                     [lblSelectQuote setHidden:YES];
                                     
                                     [quoteTableView setFrame:CGRectMake(152, 225, 720, 100)];
                                     
                                 }
                                 completion:^(BOOL finished) {
                                 }];
         }else {
         inRouteButton.enabled=YES;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;
         }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
     }];
}



-(void)callPostCommunicationServiceIntegration :(NSString *)strOrderId empId:(NSString*)strEmployeId{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:@"sendCommunicationQuote"forKey:@"action"];
    [dict setValue:strOrderId forKey:@"orderId"];
    [dict setValue:strEmployeId forKey:@"empId"];
    [dict setValue:selectedQuote forKey:@"title"];
    [dict setValue:self.textViewMessage.text forKey:@"description"];
    [dict setValue:status forKey:@"status"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                self.textViewMessage.text = @"";
              [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Information" andMessage:@"Communication sent." onController:self];
             
         }
         else{
             [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Information" andMessage:@"Something went wrong, Please try again." onController:self];
         }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
     }];
}

#pragma mark -

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -


@end
