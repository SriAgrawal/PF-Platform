//
//  ViewController.m
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 26/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize strOrderId;

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==stateTableView){
        return [stateArray count];
    }
    else if (tableView==countryTableView){
        return [countryArray count];
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    if (tableView==stateTableView)
    {
        cell.textLabel.text=[[stateArray objectAtIndex:indexPath.row] objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    }
    else if (tableView==countryTableView)
    {
        cell.textLabel.text=[[countryArray objectAtIndex:indexPath.row]objectForKeyNotNull:@"name" expectedClass:[NSString class]];

    }

        return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField==address1TextField)
    {
        [address1TextField resignFirstResponder];
        [address2TextField becomeFirstResponder];
    }
    else if (textField==address2TextField)
    {
        [address2TextField resignFirstResponder];
        [cityTextField becomeFirstResponder];
        
    }
    else if (textField==cityTextField)
    {
        [cityTextField resignFirstResponder];
        [zipTextField becomeFirstResponder];
        
    }
    else if (textField==zipTextField)
    {
        [zipTextField resignFirstResponder];
        [phoneTextField becomeFirstResponder];
    }
    else if (textField==phoneTextField)
    {
        [phoneTextField resignFirstResponder];
    }
    return YES;
}



- (void) onKeyboardHide:(NSNotification *)notification
{
    
    valueForViewMoveUp=0;
    [self moveViewUp];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    
    
    countryTableView=[[UITableView alloc]initWithFrame:CGRectMake(151, 488, 721, 50) style:UITableViewStylePlain];
    countryTableView.dataSource=self;
    countryTableView.delegate=self;
    [self.view addSubview:countryTableView];
    
    stateArray=[NSMutableArray new];
    countryArray=[NSMutableArray new];

    stateTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    
    countryTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];

    
    stateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    countryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    editAddressView.layer.cornerRadius = 8;
    editAddressView.layer.masksToBounds = YES;
    
    stateTableView.layer.cornerRadius = 6;
    stateTableView.layer.masksToBounds = YES;
    
    countryTableView.layer.cornerRadius = 6;
    countryTableView.layer.masksToBounds = YES;
    
    stateTableView.hidden=YES;
    countryTableView.hidden=YES;

    
    if (self.fromRepair)
        [self callgetAddressFromRepairServiceIntegration];
    else
        [self callgetAddressServiceIntegration];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideTableView:(id)sender
{
    stateTableView.hidden=YES;
    countryTableView.hidden=YES;
    
    [self.view endEditing:YES];
    
    valueForViewMoveUp=0;
    [self moveViewUp];

}

- (IBAction)openTableView:(id)sender{
    if (stateTableView.hidden==NO){
        stateTableView.hidden=YES;
    }
    else{
        tableviewIndicator=@"state";
        
        
        
        stateTableView.hidden=NO;
        countryTableView.hidden=YES;
        [self.view endEditing:YES];
        
        valueForViewMoveUp=0;
        [self moveViewUp];
        

 
    }
}

- (IBAction)openCountryTableView:(id)sender
{
    if (countryTableView.hidden==NO){
        countryTableView.hidden=YES;
    }
    else{
        tableviewIndicator=@"country";
        
        countryTableView.hidden=NO;
        stateTableView.hidden=YES;
        [self.view endEditing:YES];
        
        valueForViewMoveUp=0;
        [self moveViewUp];
        
        
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableviewIndicator isEqualToString:@"state"]){
        stateTableView.hidden=YES;
        stateTextField.text=[[stateArray objectAtIndex:indexPath.row] objectForKeyNotNull:@"name" expectedClass:[NSString class]];

    }
    else{
        countryTableView.hidden=YES;
        countryTextField.text=[[countryArray objectAtIndex:indexPath.row]objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    }
    
  }

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    stateTableView.hidden=YES;
    countryTableView.hidden=YES;
    
    
    if (textField==address2TextField)
    {
        valueForViewMoveUp=-50;
        [self moveViewUp];
    }
    else if (textField==cityTextField ||textField==zipTextField)
    {
        valueForViewMoveUp=-120;
        [self moveViewUp];
        
    }
    else if (textField==countryTextField)
    {
        valueForViewMoveUp=-230;
        [self moveViewUp];
    }
    
    else if (textField==phoneTextField)
    {
        valueForViewMoveUp=-300;
        [self moveViewUp];
    }
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

- (IBAction)closePopUpAction:(id)sender{
    
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];

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


- (IBAction)updateAction:(id)sender{
    alertTitle=@"Information";
    
    valueForViewMoveUp=0;
    [self moveViewUp];
    
    
    [self.view endEditing:YES];


    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
   
    if ([address1TextField.text length]==0){
        alertMessage=@"Please enter address.";
        [self callAlertView];
    }
   
    else if ([cityTextField.text length]==0)
    {
        alertMessage=@"Please enter city.";
        [self callAlertView];

 
    }
    else if ([stateTextField.text length]==0)
    {
        alertMessage=@"Please select state.";
        [self callAlertView];


    }
    else if ([zipTextField.text length]<5 ||[zipTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        alertMessage=@"Please enter a valid zip code.";
        [self callAlertView];

 
    }
        else if ([countryTextField.text length]==0)
    {
        alertMessage=@"Please entercountry.";
        [self callAlertView];

 
    }
    else if ([phoneTextField.text length]<10)
    {
        alertMessage=@"Please enter a valid phone number.";
        [self callAlertView];


    }else{
        
        if (self.fromRepair)
            [self callupdateAddressRepairServiceIntegration];
        else
            [self callupdateAddressServiceIntegration];
    }
   
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    
    if (textField==phoneTextField)
    {
        if (isBackSpace == -8) {
            return YES;
        }
        if (str.length > 14) {
            return NO;
        }
        if (textField==phoneTextField) {
            NSString *newString = [phoneTextField.text stringByReplacingCharactersInRange:range withString:string];
            NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
            NSString *decimalString = [components componentsJoinedByString:@""];
            
            NSUInteger length = decimalString.length;
            BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
            
            if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
                textField.text = decimalString;
                return NO;
            }
            
            NSUInteger index = 0;
            NSMutableString *formattedString = [NSMutableString string];
            
            if (length - index > 3) {
                NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
                [formattedString appendFormat:@"(%@) ",areaCode];
                index += 3;
            }
            
            if (length - index > 3) {
                NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
                [formattedString appendFormat:@"%@-",prefix];
                index += 3;
            }
            
            NSString *remainder = [decimalString substringFromIndex:index];
            [formattedString appendString:remainder];
            
            textField.text = formattedString;
            
        }
        if([string length]==0)
        {
            return YES;
        }

        return NO;
    }
    else if (textField  == zipTextField) {

        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        
        if (isBackSpace == -8) {
            return YES;
        }
        if (str.length > 20) {
            return NO;
        }
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if ([myCharSet characterIsMember:c]) {
                return YES;
            }
        }
        
        return NO;
    }

    else
        return YES;
}


#pragma mark - Service Helper Method

-(void)callgetAddressServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getAddress"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"orderId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            NSDictionary *addressDict = [response objectForKeyNotNull:@"address" expectedClass:[NSDictionary class]];
            
            [address1TextField setText:[addressDict objectForKeyNotNull:@"billingAddress1" expectedClass:[NSString class]]];
            [address2TextField setText:[addressDict objectForKeyNotNull:@"billingAddress2" expectedClass:[NSString class]]];
            [cityTextField setText:[addressDict objectForKeyNotNull:@"billingCity" expectedClass:[NSString class]]];
            [countryTextField setText:[addressDict objectForKeyNotNull:@"billingCountry" expectedClass:[NSString class]]];
            [phoneTextField setText:[addressDict objectForKeyNotNull:@"billingPhone" expectedClass:[NSString class]]];
            [stateTextField setText:[addressDict objectForKeyNotNull:@"billingState" expectedClass:[NSString class]]];
            [zipTextField setText:[addressDict objectForKeyNotNull:@"billingZip" expectedClass:[NSString class]]];

        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    
        [self callAPIForStateAndCountry];
    }];
}


-(void)callgetAddressFromRepairServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"repairClientAddress"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                NSDictionary *addressDict = [response objectForKeyNotNull:@"responseData" expectedClass:[NSDictionary class]];
                
                [address1TextField setText:[addressDict objectForKeyNotNull:@"address1" expectedClass:[NSString class]]];
                [address2TextField setText:[addressDict objectForKeyNotNull:@"address2" expectedClass:[NSString class]]];
                [cityTextField setText:[addressDict objectForKeyNotNull:@"city" expectedClass:[NSString class]]];
                [countryTextField setText:[addressDict objectForKeyNotNull:@"country" expectedClass:[NSString class]]];
                [phoneTextField setText:[addressDict objectForKeyNotNull:@"phone" expectedClass:[NSString class]]];
                [stateTextField setText:[addressDict objectForKeyNotNull:@"state" expectedClass:[NSString class]]];
                [zipTextField setText:[addressDict objectForKeyNotNull:@"zip" expectedClass:[NSString class]]];
                
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        
        [self callAPIForStateAndCountry];

    }];
}



-(void)callupdateAddressServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"upadateBillingAddress"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"orderId"];
    [dict setValue:address1TextField.text forKey:@"billingAddress1"];
    [dict setValue:address2TextField.text forKey:@"billingAddress2"];
    [dict setValue:cityTextField.text forKey:@"billingCity"];
    [dict setValue:stateTextField.text forKey:@"billingState"];
    [dict setValue:zipTextField.text forKey:@"billingZip"];
    [dict setValue:phoneTextField.text forKey:@"billingPhone"];
    [dict setValue:countryTextField.text forKey:@"billingCountry"];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            
            [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Address updated successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                if(index == 0)
                {
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self.delegate callTechCheckApi];
                        
                    }];
                }
            }];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callupdateAddressRepairServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"updateRepairAddressInfo"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"order_id"];
    [dict setValue:address1TextField.text forKey:@"address1"];
    [dict setValue:address2TextField.text forKey:@"address2"];
    [dict setValue:cityTextField.text forKey:@"city"];
    [dict setValue:stateTextField.text forKey:@"state"];
    [dict setValue:zipTextField.text forKey:@"zip"];
    [dict setValue:phoneTextField.text forKey:@"phone"];
    [dict setValue:countryTextField.text forKey:@"country"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Address updated successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    if(index == 0)
                    {
                    [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate callTechCheckApi];
                    }];
                    }
                }];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callAPIForStateAndCountry {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"stateAndCountry"forKey:@"action"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                if (suceeded)
                {
                    [stateArray removeAllObjects];
                    [countryArray removeAllObjects];
                    NSArray *state = [response objectForKeyNotNull:@"state" expectedClass:[NSArray class]];
                    NSArray *country = [response objectForKeyNotNull:@"country" expectedClass:[NSArray class]];
                    
                    [stateArray addObjectsFromArray:state];
                    [countryArray addObjectsFromArray:country];
                    [stateTableView reloadData];
                    [countryTableView reloadData];
                }
                else
                {
                    
                }
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
