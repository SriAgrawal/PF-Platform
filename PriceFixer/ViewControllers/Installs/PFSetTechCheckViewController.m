//
//  PFSetTechCheckViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 28/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFSetTechCheckViewController.h"
#import "Macro.h"
#import "TextField.h"

@interface PFSetTechCheckViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    NSMutableArray *crewArray;
    NSMutableArray *quoteArray;
    NSMutableArray *hourArray;
    NSMutableArray *minArray;
    NSMutableArray *AMArray;
    NSMutableArray *expireMonthArray;
    NSMutableArray *expireYearArray;
    
    NSMutableArray *paymentInfoArray;

    NSIndexPath *indexpath;
    NSString *selectedDate;
    PFAppointmentModel *modalObject;

}

@property (weak, nonatomic) IBOutlet TextField *quoteTextField;
@property (weak, nonatomic) IBOutlet TextField *crewTextField;
@property (weak, nonatomic) IBOutlet TextField *dateTextField;
@property (weak, nonatomic) IBOutlet TextField *hourTextField;
@property (weak, nonatomic) IBOutlet TextField *minuteTextField;
@property (weak, nonatomic) IBOutlet TextField *timeTypeTextField;
@property (weak, nonatomic) IBOutlet TextField *nameOnCardTextField;
@property (weak, nonatomic) IBOutlet TextField *creditCardNumberTextfield;
@property (weak, nonatomic) IBOutlet TextField *cvvTextField;
@property (weak, nonatomic) IBOutlet TextField *monthTextfield;
@property (weak, nonatomic) IBOutlet TextField *yearTextField;

@property (weak, nonatomic) IBOutlet UILabel *chargedTodayLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargedcompletionLabel;

@property (strong, nonatomic) UITableView  *crewTableView;

@property (weak, nonatomic) IBOutlet UIView *backgroundViewForTextView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *quoteButton;
@property (weak, nonatomic) IBOutlet UIButton *crewButton;
@property (weak, nonatomic) IBOutlet UIButton *hourButton;
@property (weak, nonatomic) IBOutlet UIButton *minuteButton;
@property (weak, nonatomic) IBOutlet UIButton *amButton;
@property (weak, nonatomic) IBOutlet UIButton *expireMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *expireYearButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;


@end

@implementation PFSetTechCheckViewController


#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Method

- (void)initialSetup {
    
    self.crewTableView = [[UITableView alloc]initWithFrame:CGRectMake(152, 370, 720, 100) style:UITableViewStylePlain];
    self.crewTableView.dataSource=self;
    self.crewTableView.delegate=self;
    [self.backgroundViewForTextView addSubview:self.crewTableView];
    
    
    quoteArray=[[NSMutableArray alloc] init];
    crewArray = [NSMutableArray array];
    hourArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    minArray=[[NSMutableArray alloc]initWithObjects:@"00",@"15",@"30",@"45", nil];
    AMArray=[[NSMutableArray alloc]initWithObjects:@"AM",@"PM", nil];
    expireMonthArray = [[NSMutableArray alloc]initWithObjects:@"January 01",@"February 02",@"March 03",@"April 04",@"May 05",@"June 06",@"July 07",@"August 08",@"September 09",@"October 10",@"November 11",@"December 12", nil];
    expireYearArray = [[NSMutableArray alloc]initWithObjects:@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028", nil];
    paymentInfoArray = [NSMutableArray array];
    self.crewTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    self.crewTableView.layer.cornerRadius = 6;
    self.crewTableView.layer.masksToBounds = YES;
    self.quoteTextField.text = self.modelInstall.strOrderCode;
    
    self.backgroundViewForTextView.layer.cornerRadius = 5;
    self.backgroundViewForTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundViewForTextView.layer.borderWidth = 1.0f;
    self.backgroundViewForTextView.layer.masksToBounds = YES;

    self.crewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.crewTableView.hidden=YES;
    self.datePicker.hidden=YES;

    self.datePicker.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    [self.datePicker setMinimumDate: [NSDate date]];
    self.datePicker.layer.cornerRadius = 6;
    self.datePicker.layer.masksToBounds = YES;
    
    modalObject = [[PFAppointmentModel alloc]init];
    
    [self callApiToGetCrewServiceIntegration];
    
}


#pragma mark -

#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.quoteButton.selected){
        return [quoteArray count];
    }
    else if (self.hourButton.selected){
        return [hourArray count];
    }
    else if (self.minuteButton.selected){
        return [minArray count];
    }
    else if (self.amButton.selected){
        return [AMArray count];
    }
    else if (_crewButton.selected){
        return [crewArray count];
    }
    else if (_expireMonthButton.selected){
        return [expireMonthArray count];
    }
    else if (_expireMonthButton.selected){
        return [expireMonthArray count];
    }
    else if (_expireYearButton.selected){
        return [expireYearArray count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
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
    
    if (self.quoteButton.selected)
    {
        PFDispatchModel *obj = [quoteArray objectAtIndex:indexPath.row];
        cell.textLabel.text=obj.strAppOrderCode;
        
    }
    else if (self.hourButton.selected)
    {
        cell.textLabel.text=[hourArray objectAtIndex:indexPath.row];
        
    }
    else if (self.minuteButton.selected)
    {
        cell.textLabel.text=[minArray objectAtIndex:indexPath.row];
        
    }
    else if (self.amButton.selected)
    {
        cell.textLabel.font=[UIFont systemFontOfSize:11];
        
        cell.textLabel.text=[AMArray objectAtIndex:indexPath.row];
        
    }
    else if (_expireMonthButton.selected){
       
        cell.textLabel.font=[UIFont systemFontOfSize:11];
        
        cell.textLabel.text=[expireMonthArray objectAtIndex:indexPath.row];
    }
    else if (_expireYearButton.selected){
        
        cell.textLabel.font=[UIFont systemFontOfSize:11];
        
        cell.textLabel.text=[expireYearArray objectAtIndex:indexPath.row];
    }
    else if (self.crewButton.selected)
    {
        PFDispatchModel *obj = [crewArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:11];
        
        cell.textLabel.text = obj.strCrew_name;
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.quoteButton.selected){
        self.crewTableView.hidden=YES;
        self.quoteButton.selected = NO;
        PFDispatchModel *obj = [quoteArray objectAtIndex:indexPath.row];
        self.quoteTextField.text=obj.strAppOrderCode;
        indexpath = indexPath;
    }
    else if (self.hourButton.selected){
        self.crewTableView.hidden=YES;
        self.hourButton.selected = NO;
        self.hourTextField.text=[hourArray objectAtIndex:indexPath.row];
        modalObject.strHour = [hourArray objectAtIndex:indexPath.row];
    }
    else if (self.minuteButton.selected){
        self.crewTableView.hidden=YES;
        self.minuteButton.selected = NO;
        self.minuteTextField.text=[minArray objectAtIndex:indexPath.row];
        modalObject.strMin = [minArray objectAtIndex:indexPath.row];
    }
    else if (self.expireMonthButton.selected){
        self.crewTableView.hidden=YES;
        self.expireMonthButton.selected = NO;
        self.monthTextfield.text=[expireMonthArray objectAtIndex:indexPath.row];
        modalObject.strExpireMonth = [expireMonthArray objectAtIndex:indexPath.row];
    }
    else if (self.expireYearButton.selected){
        self.crewTableView.hidden=YES;
        self.expireYearButton.selected = NO;
        self.yearTextField.text=[expireYearArray objectAtIndex:indexPath.row];
        modalObject.strExpireYear = [expireYearArray objectAtIndex:indexPath.row];
    }
    else if (self.amButton.selected){
        self.crewTableView.hidden=YES;
        self.amButton.selected = NO;
        self.timeTypeTextField.text=[AMArray objectAtIndex:indexPath.row];
        modalObject.strAM = [AMArray objectAtIndex:indexPath.row];
    }
    else if (self.crewButton.selected){
        self.crewTableView.hidden=YES;
        self.crewButton.selected = NO;
        PFDispatchModel *obj = [crewArray objectAtIndex:indexPath.row];
        self.crewTextField.text = obj.strCrew_name;
        indexpath = indexPath;
    }
}


#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
      textField.layer.borderColor = KHomeTextFieldBorderColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 30 && textField.tag == 100) {
        return NO;
    }
    else if (str.length > 16 && textField.tag == 101) {
        return NO;
    }
    else if (str.length > 4 && textField.tag == 102) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        if (textField.returnKeyType == UIReturnKeyNext) {
        
            UITextField *txtField = [self.view viewWithTag:textField.tag+1];
            [txtField becomeFirstResponder];
    }
        else
            [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIButton Action

- (IBAction)quoteButtonAction:(UIButton*)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    
    [self.crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    self.quoteButton.selected = !self.quoteButton.selected;
    
    if (self.quoteButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
    
    [self.crewTableView reloadData];
}

- (IBAction)crewButtonAction:(UIButton*)sender {
    
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    [self deselectAllButton:sender.tag];
    
    [self.crewTableView setFrame:rect];
    _crewButton.selected = !_crewButton.selected;
    
    if (self.crewButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
        
    [self.crewTableView reloadData];

}

- (IBAction)dateButtonAction:(UIButton*)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.dateTextField.text = [dateFormatter stringFromDate:[self.datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter1 stringFromDate:[self.datePicker date]];
    
    [self deselectAllButton:sender.tag];
    self.dateButton.selected = !self.dateButton.selected;
    
    if (self.dateButton.selected)
        [self.datePicker setHidden:NO];
    else
        [self.datePicker setHidden:YES];
    
    [self.crewTableView setHidden:YES];
    self.quoteButton.selected = NO;
    self.crewButton.selected = NO;
    self.hourButton.selected = NO;
    self.minuteButton.selected = NO;
    self.amButton.selected = NO;

}

- (IBAction)hourButtonAction:(UIButton*)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    
    rect.size.height = 130;
    rect.size.width = 55;
    
    self.hourButton.selected = !self.hourButton.selected;
    
    [self.crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    
    if (self.hourButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
        
    [self.crewTableView reloadData];
    
}

- (IBAction)minuteButtonAction:(UIButton*)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    rect.size.width = 55;
    rect.size.height = 130;
    
    [self.crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    self.minuteButton.selected = !self.minuteButton.selected;
    
    if (self.minuteButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
        
    [self.crewTableView reloadData];
}

- (IBAction)timeTypeButtonAction:(UIButton*)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    rect.size.height = 65;
    rect.size.width = 55;
    
    [self.crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    self.amButton.selected = !self.amButton.selected;
    
    if (self.amButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
        
    [self.crewTableView reloadData];

}

- (IBAction)expireMonthButtonAction:(UIButton*)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    
    [self.crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    self.expireMonthButton.selected = !self.expireMonthButton.selected;
    
    if (self.expireMonthButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
    
    [self.crewTableView reloadData];

}

- (IBAction)expireYearButtonAction:(UIButton*)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    
    [self.crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    self.expireYearButton.selected = !self.expireYearButton.selected;
    
    if (self.expireYearButton.selected)
        [self.crewTableView setHidden:NO];
    else
        [self.crewTableView setHidden:YES];
    
    [self.crewTableView reloadData];
}

- (IBAction)changeAndSetInstallButtonAction:(UIButton*)sender {
    
    [self.view endEditing:YES];
    if ([self isVerifiedAllField]) {
        
        [self callApiToSetInstallServiceIntegration];
    }
}

- (IBAction)dismisButtonAction:(UIButton*)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper Method

-(void) deselectAllButton :(NSInteger)buttonTag {
    
    for (int i = 5000; i<5008; i++) {
        if (i == buttonTag) {
            //[(UIButton *) [self.view viewWithTag:buttonTag] setSelected:YES];
        }else{
            [(UIButton *) [self.view viewWithTag:i] setSelected:NO];
            [self.datePicker setHidden:YES];
        }
    }
}

- (IBAction)dateSelectionn:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    self.dateTextField.text = [dateFormatter stringFromDate:[self.datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter1 stringFromDate:[self.datePicker date]];
}

#pragma mark - Validation Method

- (BOOL)isVerifiedAllField {
    
    if (![TRIM_SPACE(self.quoteTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select quote." onController:self];
    }else if (![TRIM_SPACE(self.crewTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select crew." onController:self];
    }else if (![TRIM_SPACE(self.dateTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select date." onController:self];
    }else if (![TRIM_SPACE(self.hourTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select hours." onController:self];
    }else if (![TRIM_SPACE(self.minuteTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select minutes." onController:self];
    }else if (![TRIM_SPACE(self.timeTypeTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select AM/PM." onController:self];
    }else if (![TRIM_SPACE(self.nameOnCardTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter credit card holder name." onController:self];
    }else if(![TRIM_SPACE(self.creditCardNumberTextfield.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter credit card number." onController:self];
    }else if(![TRIM_SPACE(self.cvvTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter cvv." onController:self];
    }else if(![TRIM_SPACE(self.monthTextfield.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter expire month." onController:self];
    }else if(![TRIM_SPACE(self.yearTextField.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter expire year." onController:self];
    }
    else
        return YES;

    return NO;
}


#pragma mark - Service Helper Method

-(void)callApiToGetCrewServiceIntegration{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getCrewList" forKey:@"action"];
    [dict setValue:self.modelInstall.strShopId forKey:@"shop_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [crewArray removeAllObjects];
                [quoteArray removeAllObjects];
                
                if (response && [response isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dispatchListDict = [response objectForKeyNotNull:@"crewList" expectedClass:[NSDictionary class]];
                    NSDictionary *orderListDict = [response objectForKeyNotNull:@"orderList" expectedClass:[NSDictionary class]];
                    
                    NSArray *dispatchListArray =[dispatchListDict objectForKeyNotNull:@"crewData" expectedClass:[NSArray class]];
                    NSArray *orderListArray=[orderListDict objectForKeyNotNull:@"orderData" expectedClass:[NSArray class]];
                    
                    
                    if (dispatchListDict && [dispatchListDict isKindOfClass:[NSDictionary class]]) {
                        
                        if (dispatchListArray && [dispatchListArray isKindOfClass:[NSArray class]]) {
                            for (NSMutableDictionary *dispatchDict in dispatchListArray) {
                                PFDispatchModel *dispatchInfo = [PFDispatchModel modelCrewDict:dispatchDict];
                                [crewArray addObject:dispatchInfo];
                            }
                        }
                    }
                    
                    if (orderListDict && [orderListDict isKindOfClass:[NSDictionary class]]) {
                        
                        if (orderListArray && [orderListArray isKindOfClass:[NSArray class]]) {
                            for (NSMutableDictionary *dispatchDict in orderListArray) {
                                PFDispatchModel *dispatchInfo = [PFDispatchModel modelOrderListDict:dispatchDict];
                                [quoteArray addObject:dispatchInfo];
                            }
                        }
                    }
                }
                
                [self.crewTableView reloadData];
                [self callApiToGetInstallServiceIntegration];

            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



-(void)callApiToGetInstallServiceIntegration{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"setInstallation" forKey:@"action"];
    [dict setValue:self.modelInstall.strOrderId forKey:@"order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                NSDictionary *paymentInfoDict = [response objectForKeyNotNull:@"paymentData" expectedClass:[NSDictionary class]];
                [paymentInfoArray addObject:[PFAppointmentModel getPaymentInfo:paymentInfoDict]];
                
                PFAppointmentModel *appointmentObject = [paymentInfoArray firstObject];
                
                self.nameOnCardTextField.text = appointmentObject.strCredit_card_person;
                self.creditCardNumberTextfield.text = appointmentObject.strCredit_card_number;
                self.cvvTextField.text = appointmentObject.strCvv;
                self.monthTextfield.text = appointmentObject.strCredit_card_month;
                self.yearTextField.text = appointmentObject.strCredit_card_year;
                
                self.chargedTodayLabel.text = [NSString stringWithFormat:@"$%@",appointmentObject.strCharged_today];
               
                self.chargedcompletionLabel.text =  [NSString stringWithFormat:@"$%@",appointmentObject.strCharged_at_completion];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



- (void)callApiToSetInstallServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    PFDispatchModel *dispatchInfo = [crewArray objectAtIndex:indexpath.row];

    
    [dict setValue:@"createAppointment" forKey:@"action"];
    [dict setValue:self.modelInstall.strOrderId forKey:@"order_id"];
    [dict setValue:@"0" forKey:@"apt_id"];
    [dict setValue:dispatchInfo.strCrew_id forKey:@"crew_id"];
    [dict setValue:selectedDate forKey:@"apt_date"];
    [dict setValue:modalObject.strHour forKey:@"date_1_hh"];
    [dict setValue:modalObject.strMin forKey:@"date_1_mm"];
    [dict setValue:([modalObject.strAM isEqualToString:@"AM"])?@"am":@"pm" forKey:@"date_1_ss"];
    [dict setValue:@"" forKey:@"change_notes"];
    [dict setValue:self.nameOnCardTextField.text forKey:@"cc_name_on_card"];
    [dict setValue:self.creditCardNumberTextfield.text forKey:@"cc_card_no"];
    [dict setValue:self.cvvTextField.text forKey:@"cc_cvv2"];
    [dict setValue:self.monthTextfield.text forKey:@"cc_expir_month"];
    [dict setValue:self.yearTextField.text forKey:@"cc_expir_year"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [self.delegate callTechCheckApi];
                [self dismissViewControllerAnimated:YES completion:nil];

            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
