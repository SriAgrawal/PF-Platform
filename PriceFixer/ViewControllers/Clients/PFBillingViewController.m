//
//  PFBillingViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 15/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFBillingViewController.h"
#import "PFClientModelInfo.h"
#import "PFUtility.h"
#import "TextField.h"
#import "Macro.h"

@interface PFBillingViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    
    NSIndexPath *indexpath;
    NSMutableArray *countryArray;
    NSMutableArray *stateArray;
    NSMutableArray *billingArray;
    UITableView *countryListTableView;
    int countryOrStateTable;
    PFClientModelInfo *clientInfo;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TextField *cardHolderNameTextField;
@property (weak, nonatomic) IBOutlet TextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet TextField *monthTextfield;
@property (weak, nonatomic) IBOutlet TextField *yearTextField;
@property (weak, nonatomic) IBOutlet TextField *cvvTextField;
@property (weak, nonatomic) IBOutlet TextField *firstAddressTextField;
@property (weak, nonatomic) IBOutlet TextField *secondAddressTextfield;
@property (weak, nonatomic) IBOutlet TextField *cityTextField;
@property (weak, nonatomic) IBOutlet TextField *stateTextField;
@property (weak, nonatomic) IBOutlet TextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet TextField *countryTextfield;


@end

@implementation PFBillingViewController

#pragma mark -

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialSetup];
}


#pragma mark -

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark -

#pragma mark - Memory Management Method
- (void)initialSetup {
    
    // Alloc Model Class
    clientInfo = [[PFClientModelInfo alloc]init];
    
    // Alloc Array
    countryArray = [NSMutableArray array];
    stateArray = [NSMutableArray array];
    billingArray = [NSMutableArray array];

    // Set Table View
    countryListTableView=[[UITableView alloc]initWithFrame:CGRectMake(520, 265, 390, 100) style:UITableViewStylePlain];
    countryListTableView.dataSource=self;
    countryListTableView.delegate=self;
    [self.view addSubview:countryListTableView];

    countryListTableView.layer.cornerRadius = 6;
    countryListTableView.layer.masksToBounds = YES;
    countryListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    countryListTableView.hidden=YES;
    
    [self callBillDetailServiceIntegration];

}

#pragma mark -

#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (countryOrStateTable == 1){
        return [stateArray count];
    }
    else if (countryOrStateTable == 2){
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
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    
    if (countryOrStateTable == 1) {
        PFClientModelInfo *obj = [stateArray objectAtIndex:indexPath.row];
        cell.textLabel.text = obj.stateName;
    }
    else {
        PFClientModelInfo *obj = [countryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = obj.countryName;
    }

        

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (countryOrStateTable == 1) {
        
        PFClientModelInfo *obj = [stateArray objectAtIndex:indexPath.row];
        self.stateTextField.text = obj.stateName;
    }
    else {
        PFClientModelInfo *obj = [countryArray objectAtIndex:indexPath.row];
        self.countryTextfield.text = obj.countryName;
    }
        countryListTableView.hidden=YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != countryListTableView) 
        countryListTableView.hidden = YES;
    
}

- (BOOL)validateField {
    
    if (!self.cardHolderNameTextField.text.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter name on card." onController:self];
    }
    else if (!self.cardNumberTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter credit card number." onController:self];
    }
    else if (!self.monthTextfield.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter month." onController:self];
    }
    else if (!self.yearTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter year." onController:self];
    }
    else if (!self.cvvTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter cvv." onController:self];
    }
    else if (!self.firstAddressTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter address 1." onController:self];
    }
    else if (!self.secondAddressTextfield.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter address 2." onController:self];
    }
    else if (!self.cityTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter city." onController:self];
    }
    else if (!self.stateTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select state." onController:self];
    }
    else if (!self.zipCodeTextField.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:Kblankzipcode onController:self];
    }
    else if (!self.countryTextfield.text.length){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select country." onController:self];
    }
    else{
        return YES;
    }
    return NO;
}

#pragma mark -

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length > 30 && (textField.tag == 100))
        return NO;
    else if (str.length > 16 && textField.tag == 101)
        return NO;
    else if (str.length > 2 && textField.tag == 102)
        return NO;
    else if (str.length > 4 && (textField.tag == 103 || textField.tag == 104))
        return NO;
    else if (str.length > 200 && (textField.tag == 105 || textField.tag == 106))
        return NO;
    else if (str.length > 50 && textField.tag == 107)
        return NO;
    else if (str.length > 20 && textField.tag == 108)
        return NO;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    countryListTableView.hidden = YES;
    textField.layer.borderColor = KHomeTextFieldBorderColor;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        UITextField *txtField = [self.view viewWithTag:textField.tag + 1];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}


#pragma mark

#pragma mark - UIButton Action Method
- (IBAction)saveButtonAction:(id)sender {
    
    countryListTableView.hidden = YES;
    if ([self validateField]) {
        
        [self callUpdateBillDetailServiceIntegration];
    }
}

- (IBAction)openStateTableView:(id)sender{
    
        countryListTableView.frame = CGRectMake(520, 250, 390, 150);
        countryListTableView.hidden = NO;
        countryOrStateTable = 1;
        [self.view endEditing:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(0, 0.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    [countryListTableView reloadData];
    if (!stateArray.count) {
        [self callGetCountryAndStateServiceIntegration];
    }
}

- (IBAction)openCountryTableView:(id)sender{
    
        countryListTableView.frame = CGRectMake(520, 360, 390, 80);
        countryOrStateTable = 2;
        countryListTableView.hidden = NO;
        [self.view endEditing:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(0, 0.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    [countryListTableView reloadData];

    if (!countryArray.count) {
        [self callGetCountryAndStateServiceIntegration];
    }
   
}


#pragma mark

#pragma mark - Service Helper Method
- (void) callBillDetailServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"clientBillingInfo" forKey:@"action"];
    [dict setValue:self.billInfo.customer_id forKey:@"customer_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            
            NSDictionary *billInfo = [response objectForKeyNotNull:@"data" expectedClass:[NSDictionary class]];
            
               clientInfo = [PFClientModelInfo modelBillingInfoListDict:billInfo];
            
               self.cardHolderNameTextField.text = clientInfo.credit_card_person;
               self.cardNumberTextField.text = clientInfo.credit_card_number;
               self.monthTextfield.text = clientInfo.credit_card_month;
               self.yearTextField.text = clientInfo.credit_card_year;
               self.cvvTextField.text = clientInfo.cvv;
               self.firstAddressTextField.text = clientInfo.address_line1;
               self.secondAddressTextfield.text = clientInfo.address_line2;
               self.cityTextField.text = clientInfo.city;
               self.stateTextField.text = clientInfo.state;
               self.zipCodeTextField.text = clientInfo.zip;
               self.countryTextfield.text = clientInfo.country;
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];

    }];
}



- (void) callUpdateBillDetailServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"updateBillingInfo" forKey:@"action"];
    [dict setValue:self.billInfo.customer_id forKey:@"customer_id"];
    [dict setValue:self.cardHolderNameTextField.text forKey:@"credit_card_person"];
    [dict setValue:self.cardNumberTextField.text forKey:@"credit_card_number"];
    [dict setValue:self.monthTextfield.text forKey:@"credit_card_month"];
    [dict setValue:self.yearTextField.text forKey:@"credit_card_year"];
    [dict setValue:self.cvvTextField.text forKey:@"cvv"];
    [dict setValue:self.firstAddressTextField.text forKey:@"address_line1"];
    [dict setValue:self.secondAddressTextfield.text forKey:@"address_line2"];
    [dict setValue:self.cityTextField.text forKey:@"city"];
    [dict setValue:self.stateTextField.text forKey:@"state"];
    [dict setValue:self.zipCodeTextField.text forKey:@"zip"];
    [dict setValue:self.countryTextfield.text forKey:@"country"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


- (void) callGetCountryAndStateServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"stateAndCountry" forKey:@"action"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
          
            
            NSArray *stateTempArray = [response objectForKeyNotNull:@"state" expectedClass:[NSArray class]];
            NSArray *countryTempArray = [response objectForKeyNotNull:@"country" expectedClass:[NSArray class]];
            
            for (NSDictionary *dict in stateTempArray) {
                [stateArray addObject:[PFClientModelInfo modalStateInfoListDict:dict]];
            }
            for (NSDictionary *countryDict in countryTempArray) {
                [countryArray addObject:[PFClientModelInfo modalCountryInfoListDict:countryDict]];
            }
            [countryListTableView reloadData];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

@end
