//
//  communicationViewController.m
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 26/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import "communicationViewController.h"

@interface communicationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@end

@implementation communicationViewController


@synthesize strOrderId;
@synthesize strEmployeId;
@synthesize strCustomerName;
@synthesize strOrderCode;

#pragma mark - Status Bar Visibility Setting

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [messageTextView setPlaceholderText:@"Type Message"];

    // Do any additional setup after loading the view from its nib.
    
    if (self.fromRepair) {
        self.firstLabel.text = @"Appointment Set";
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    
    backgroundViewForTextView.layer.cornerRadius = 5;
    backgroundViewForTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backgroundViewForTextView.layer.borderWidth = 1.0f;
    backgroundViewForTextView.layer.masksToBounds = YES;
    
    communicationPopUpView.layer.cornerRadius = 8;
    communicationPopUpView.layer.masksToBounds = YES;

    
    userTextField.enabled=NO;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.fromRepair) {
        [self hideUnhideRouteButton];
    }
    else
     [self callGetCommunicationServiceIntegration];
}
#pragma mark -


#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -


#pragma mark - Text View Delegate Methods
- (void)textViewDidBeginEditing:(UITextField *)textField{
    valueForViewMoveUp=-300;
    [self moveViewUp];
}

#pragma mark -

#pragma mark - IB Actions
- (IBAction)installationSetButtonAction:(id)sender {
    
    if (installationSetButton.enabled)
    {
        selectedQuote=@"Installation Set";
        
        if (self.fromRepair)
            status=@"0";
        else
            status=@"3";
        
        messageTextView.text = @"Installation Set predefined text";
        
        installationSetButton.enabled=NO;
        inRouteButton.enabled=YES;
        arrivedButton.enabled=YES;
        eightyPercentButton.enabled=YES;
        hundreadPercentButton.enabled=YES;
        
    }
}


- (IBAction)hideTableView:(id)sender{
    [self.view endEditing:YES];
    valueForViewMoveUp=0;
    [self moveViewUp];
    
}

- (IBAction)sendSelection:(id)sender
{
    valueForViewMoveUp=0;
    [self moveViewUp];
    
    [self.view endEditing:YES];
    
    
    alertTitle=@"Information";
    
    if ([CommunicationTitleLabel.text length]==0)
    {
        alertMessage=@"Please select quote status.";
        [self callAlertView];
    }
    else if ([self.strCurrentStatus isEqualToString:@"100% Complete"] || [self.strCurrentStatus isEqualToString:@"Cancelled"] || [self.strCurrentStatus isEqualToString:@""]) {
        alertMessage=@"Please select quote status.";
        [self callAlertView];
    }
    else if ([messageTextView.text length]==0)
    {
        alertMessage=@"Please enter your message.";
        [self callAlertView];
        
    }
    else
    {
        if (self.fromInstall || self.fromRepair)
            [self callPostCommunicationInstallServiceIntegration];
        else
            [self callPostCommunicationServiceIntegration];

    }
}

- (IBAction)closeBtnAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (IBAction)inRouteSelection:(id)sender
{
    if (inRouteButton.enabled)
    {
        selectedQuote=@"In Route";
        if (self.fromRepair)
            status=@"1";
        else
            status=@"4";
        messageTextView.text = @"In route predefined text";

        inRouteButton.enabled=NO;
        arrivedButton.enabled=YES;
        eightyPercentButton.enabled=YES;
        hundreadPercentButton.enabled=YES;
        installationSetButton.enabled=NO;
        
        if ([statusFromServer isEqualToString:@"0"] || [self.strCurrentStatus isEqualToString:@"Appointment Set"])
        {
            installationSetButton.enabled=NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=YES;
        }
    }
    
}
- (IBAction)arrivedSelection:(id)sender
{
    if (arrivedButton.enabled)
    {
        selectedQuote=@"80% Complete";
        if (self.fromRepair)
            status=@"2";
        else
            status=@"5";
        messageTextView.text = @"arrived predefined text";

        if ([statusFromServer isEqualToString:@"0"] || [self.strCurrentStatus isEqualToString:@"Appointment Set"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=YES;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=YES;
        }
        else if ([statusFromServer isEqualToString:@"1"] || [self.strCurrentStatus isEqualToString:@"In Route"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=YES;
        }
        
    }
}
- (IBAction)eightyCompleteSelection:(id)sender
{
    if (eightyPercentButton.enabled)
    {
        selectedQuote=@"100% Complete";
        if (self.fromRepair)
            status=@"3";
        else
            status=@"6";
        messageTextView.text = @"80% complete predefined text";

        if ([statusFromServer isEqualToString:@"0"] || [self.strCurrentStatus isEqualToString:@"Appointment Set"])
        {
            inRouteButton.enabled=YES;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=NO;
            hundreadPercentButton.enabled=YES;
            installationSetButton.enabled = NO;
        }
        else if ([statusFromServer isEqualToString:@"1"] || [self.strCurrentStatus isEqualToString:@"In Route"])
        {
            installationSetButton.enabled = NO;
            inRouteButton.enabled=NO;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=NO;
            hundreadPercentButton.enabled=YES;
        }
        else if ([statusFromServer isEqualToString:@"2"] || [self.strCurrentStatus isEqualToString:@"Arrived"])
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
- (IBAction)hundreadCompleteSelection:(id)sender
{
    if (hundreadPercentButton.enabled)
    {
        selectedQuote=@"100";
        if (self.fromRepair)
            status=@"4";
        else
            status=@"7";
        messageTextView.text = @"100% complete predefined text";

        if ([statusFromServer isEqualToString:@"0"] || [self.strCurrentStatus isEqualToString:@"Appointment Set"])
        {
            inRouteButton.enabled=YES;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;

        }
        else if ([statusFromServer isEqualToString:@"1"] || [self.strCurrentStatus isEqualToString:@"In Route"])
        {
            inRouteButton.enabled=NO;
            arrivedButton.enabled=YES;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;

        }
        else if ([statusFromServer isEqualToString:@"2"] || [self.strCurrentStatus isEqualToString:@"Arrived"])
        {
            inRouteButton.enabled=NO;
            arrivedButton.enabled=NO;
            eightyPercentButton.enabled=YES;
            hundreadPercentButton.enabled=NO;
            installationSetButton.enabled = NO;

        }
        else if ([statusFromServer isEqualToString:@"3"] || [self.strCurrentStatus isEqualToString:@"80% Complete"])
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

#pragma mark -

#pragma mark - Common Method For AlertView Display

-(void)callAlertView
{
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

-(void)moveViewUp
{
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


- (void) onKeyboardHide:(NSNotification *)notification
{
    
    valueForViewMoveUp=0;
    [self moveViewUp];
    
}


- (void)hideUnhideRouteButton{
    
    
    CommunicationTitleLabel.text = [NSString stringWithFormat:@"%@ Communication",self.strOrderCode];

    if ([self.strCurrentStatus isEqualToString:@"Appointment Set"]){
        inRouteButton.enabled=YES;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [inRouteButton setBackgroundImage:[UIImage imageNamed:@"icon20"] forState:UIControlStateNormal];
        [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
        [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
        
        [inRouteButton setImage:[UIImage imageNamed:@"arrivedBlue"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([self.strCurrentStatus isEqualToString:@"In Route"]){
        inRouteButton.enabled=NO;arrivedButton.enabled=YES;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
        [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
        
        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([self.strCurrentStatus isEqualToString:@"Arrived"]){
        inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=YES;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];

        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([self.strCurrentStatus isEqualToString:@"80% Complete"]){
        inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=YES;installationSetButton.enabled =NO;
        
        [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];

        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    else if ([self.strCurrentStatus isEqualToString:@"100% Complete"] || [self.strCurrentStatus isEqualToString:@"Cancelled"]||[self.strCurrentStatus isEqualToString:@""]){
        inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=NO;installationSetButton.enabled =NO;
        
        [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
        [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
        [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
        [hundreadPercentButton setImage:[UIImage imageNamed:@"100Gray"] forState:UIControlStateNormal];
        [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
    }
    if ([self.strCompleteRoute isEqualToString:@"In Route"]) {
        inRouteButton.enabled=NO;
        selectedQuote=@"In Route";
        status=@"1";
        messageTextView.text = @"In route predefined text";
    }
    else if ([self.strCompleteRoute isEqualToString:@"Arrived"]) {
        arrivedButton.enabled=NO;
        selectedQuote=@"80% Complete";
        status=@"2";
        messageTextView.text = @"arrived predefined text";
    }
    else if ([self.strCompleteRoute isEqualToString:@"Complete"]) {
        hundreadPercentButton.enabled=NO;
        selectedQuote=@"100";
        status=@"4";
        messageTextView.text = @"100% complete predefined text";
    }
    if (self.fromRepair) {
        hundreadPercentButton.enabled=NO;
        selectedQuote=@"100";
        status=@"4";
        messageTextView.text = @"100% complete predefined text";
    }

    userTextField.text = [NSString stringWithFormat:@"%@ %@",self.strOrderCode,strCustomerName];

}

#pragma mark -

#pragma mark - service helper method

-(void)callGetCommunicationServiceIntegration
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:@"getcommunication"forKey:@"action"];
    [params setValue:strOrderId forKey:@"orderId"];
    [params setValue:(self.fromRepair)?@"1":@"" forKey:@"is_repair"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:params AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
         if (suceeded) {
             
             if ([[response objectForKey:@"responseCode"]isEqualToString:@"200"])
             {
                 
                 NSDictionary *dict_communication = [response objectForKeyNotNull:@"communication" expectedClass:[NSDictionary class]];
                 
                 if (self.fromInstall) {
                     if ([self.strCompleteRoute isEqualToString:@"80% Completed"]) {
                         messageTextView.text = @"80% complete predefined text";
                         eightyPercentButton.enabled = NO;
                         status = @"6";
                         selectedQuote=@"80% Complete";
                         
                         [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];


                     }
                     else {
                         messageTextView.text = @"100% complete predefined text";
                         hundreadPercentButton.enabled = NO;
                         status = @"7";
                         selectedQuote=@"100";
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Gray"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];

                     }
                 }
                 
                 if (self.fromRepair) {
                     
                 if ([self.strCompleteRoute isEqualToString:@"In Route"]) {
                     inRouteButton.enabled=NO;
                     selectedQuote=@"In Route";
                     status=@"1";
                     messageTextView.text = @"In route predefined text";
                     
                     [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
                     [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
                     [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                     
                     [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                     [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
                     [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
                     [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                     [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];

                 }
                 else if ([self.strCompleteRoute isEqualToString:@"Arrived"]) {
                     arrivedButton.enabled=NO;
                     selectedQuote=@"80% Complete";
                     status=@"2";
                     messageTextView.text = @"arrived predefined text";
                     
                     [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
                     [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                     
                     [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                     [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                     [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
                     [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                     [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];

                 }
                 else if ([self.strCompleteRoute isEqualToString:@"Complete"]) {
                     hundreadPercentButton.enabled=NO;
                     selectedQuote=@"100";
                     status=@"4";
                     messageTextView.text = @"100% complete predefined text";
                     
                     [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                     [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                     [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
                     [hundreadPercentButton setImage:[UIImage imageNamed:@"100Gray"] forState:UIControlStateNormal];
                     [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];

                 }
             }
                 
                     userTextField.text = [NSString stringWithFormat:@"%@ %@",[dict_communication objectForKey:@"orderCode "],strCustomerName];
                     
                    CommunicationTitleLabel.text=[[dict_communication objectForKey:@"orderCode "] stringByAppendingString:@" Communication"];
                     
                     statusFromServer=[[dict_communication objectForKey:@"orderStatus"] stringValue];

                     if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"0"])
                     {
                         installationSetButton.enabled=NO;
                         
                         [inRouteButton setBackgroundImage:[UIImage imageNamed:@"icon20"] forState:UIControlStateNormal];
                         [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
                         [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
                         [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedBlue"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"1"])
                     {
                         inRouteButton.enabled=NO;installationSetButton.enabled=NO;
                         
                         [arrivedButton setBackgroundImage:[UIImage imageNamed:@"icon21"] forState:UIControlStateNormal];
                         [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
                         [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteBlue"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
 
                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"2"])
                     {
                         installationSetButton.enabled=NO;inRouteButton.enabled=NO;arrivedButton.enabled=NO;
                         
                         [eightyPercentButton setBackgroundImage:[UIImage imageNamed:@"icon22"] forState:UIControlStateNormal];
                         [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Blue"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];

                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"3"])
                     {
                         installationSetButton.enabled=NO; inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;
                         
                         [hundreadPercentButton setBackgroundImage:[UIImage imageNamed:@"icon23"] forState:UIControlStateNormal];
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Blue"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];

                     }
                     else if ([[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"4"]|| [[[dict_communication objectForKey:@"orderStatus"] stringValue]isEqualToString:@"5"])
                     {
                         installationSetButton.enabled=NO; inRouteButton.enabled=NO;arrivedButton.enabled=NO;eightyPercentButton.enabled=NO;hundreadPercentButton.enabled=NO;
                         
                         [inRouteButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                         [arrivedButton setImage:[UIImage imageNamed:@"inRouteGray"] forState:UIControlStateNormal];
                         [eightyPercentButton setImage:[UIImage imageNamed:@"80Gray"] forState:UIControlStateNormal];
                         [hundreadPercentButton setImage:[UIImage imageNamed:@"100Gray"] forState:UIControlStateNormal];
                         [installationSetButton setImage:[UIImage imageNamed:@"arrivedGray"] forState:UIControlStateNormal];
                     }
               //  }
             }
             else
             {
                 NSLog(@"Display Error");
                 alertTitle=@"Information";
                 alertMessage=[response objectForKey:@"responseMessage"];
                 [self callAlertView];

             }
         }
         else
         {
             alertTitle=@"Information";
             alertMessage=@"Something went wrong, please try again.";
             [self callAlertView];

         }
     }];
}


-(void)callPostCommunicationServiceIntegration
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:@"sendCommunicationQuote"forKey:@"action"];
    [dict setValue:strOrderId forKey:@"orderId"];
    [dict setValue:strEmployeId forKey:@"empId"];
    [dict setValue:selectedQuote forKey:@"title"];
    [dict setValue:messageTextView.text forKey:@"description"];
    [dict setValue:status forKey:@"status"];
    
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
         if (suceeded) {
             
             if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                 
                 [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Communication sent." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                     
                     if(index == 0)
                     {
                         [self dismissViewControllerAnimated:YES completion:^{
                             [self.delegate callTechCheckApi];
                         }];
                     }
                 }];
                 
//             [self callAlertView];
         }
         else
             [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
         }
         
         else
             [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
     }];

}


-(void)callPostCommunicationInstallServiceIntegration
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:@"sentMessageApt"forKey:@"action"];
    [dict setValue:strOrderId forKey:@"order_id"];
    [dict setValue:messageTextView.text forKey:@"message"];
    [dict setValue:status forKey:@"order_status"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Communication sent." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    if(index == 0)
                    {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self.delegate callTechCheckApi];
                        }];
                    }
                }];
                
                //             [self callAlertView];
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
