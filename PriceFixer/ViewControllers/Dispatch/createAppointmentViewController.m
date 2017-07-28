//
//  createAppointmentViewController.m
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 28/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import "createAppointmentViewController.h"

@interface createAppointmentViewController ()<UITextFieldDelegate>{
    PFAppointmentModel *modalObject;
    NSIndexPath *indexpath;
    NSString *selectedDate;
    NSMutableArray *crewArray;
    NSMutableArray *orderArray;
    
}
@property (weak, nonatomic) IBOutlet UITextField *crewTextField;

@property (weak, nonatomic) IBOutlet UIButton *crewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTopConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewheightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *crewLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *createAppointmentLabel;

@end

@implementation createAppointmentViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - View controller life cycle method
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isFromEquipment) {
        
        [self.saveButton setTitle:@"Set Delivered" forState:UIControlStateNormal];
        self.saveButton.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:179.0/255.0 blue:53.0/255.0 alpha:1.0];
        self.dateTopConstraints.constant = 10.0;
        self.mainViewheightConstraint.constant = 400.0;
        _crewButton.hidden = YES;
        _crewTextField.hidden = YES;
        self.crewLabel.hidden = YES;
        self.createAppointmentLabel.text = [NSString stringWithFormat:@"%@ Mark Delivered",self.strAppOrderCode];
        _quoteBtn.userInteractionEnabled = NO;
        NSArray *strings = [self.objEditDetail.strInRoute componentsSeparatedByString:@" "];
        
        quoteTextField.text = self.objEditDetail.strOrderCode;
        if (strings.count) {
            NSString *strDate=[strings objectAtIndex:0];
            
            NSArray *timeArray = [[strings objectAtIndex:1] componentsSeparatedByString:@":"];
            if (timeArray.count) {
                NSString *strHour = [timeArray objectAtIndex:0];
                
                NSString *strMin = [timeArray objectAtIndex:1] ;
                
                if ([strHour integerValue] > 12) {
                    strHour = [NSString stringWithFormat:@"%ld",(long)[strHour integerValue] - 12];
                    [AMTextField setText:@"PM"];
                }else{
                    [AMTextField setText:@"AM"];
                    
                }
                
                if (strings.count == 3) {
                    
                    NSString *strAmPm = [strings objectAtIndex:2];
                    [AMTextField setText:([strAmPm isEqualToString:@"am"])?@"AM":@"PM"];
                }
                [hourTextField setText:strHour];
                [minTextField setText:strMin];
            }
            
            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MM/dd/yyyy"];
            NSDate *date = [dateFormatter1 dateFromString:strDate];
            
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            selectedDate = [dateFormatter2 stringFromDate:date];
            
            [dateTextField setText:strDate];
        }
    }
    else if (self.isFromEquipmentSetDelivery) {
        
        [self.saveButton setTitle:@"Set Delivery" forState:UIControlStateNormal];
        self.saveButton.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:179.0/255.0 blue:53.0/255.0 alpha:1.0];
        self.saveButton.layer.cornerRadius = 10.0;
        self.dateTopConstraints.constant = 10.0;
        self.mainViewheightConstraint.constant = 400.0;
        _crewButton.hidden = YES;
        _crewTextField.hidden = YES;
        self.crewLabel.hidden = YES;
        self.createAppointmentLabel.text = [NSString stringWithFormat:@"%@ Set Delivery",self.strAppOrderCode];
        
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    crewTableView=[[UITableView alloc]initWithFrame:CGRectMake(152, 370, 720, 100) style:UITableViewStylePlain];
    crewTableView.dataSource=self;
    crewTableView.delegate=self;
    [backgroundViewForTextView addSubview:crewTableView];
    
    quoteArray=[[NSMutableArray alloc] init];
    crewArray = [NSMutableArray array];
    hourArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    minArray=[[NSMutableArray alloc]initWithObjects:@"00",@"15",@"30",@"45", nil];
    AMArray=[[NSMutableArray alloc]initWithObjects:@"AM",@"PM", nil];
    
    crewTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    
    crewTableView.layer.cornerRadius = 6;
    crewTableView.layer.masksToBounds = YES;
    
    backgroundViewForTextView.layer.cornerRadius = 5;
    backgroundViewForTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backgroundViewForTextView.layer.borderWidth = 1.0f;
    backgroundViewForTextView.layer.masksToBounds = YES;
    
    editAppointmentView.layer.cornerRadius = 8;
    editAppointmentView.layer.masksToBounds = YES;
    
    crewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    crewTableView.hidden=YES;
    datePicker.hidden=YES;
    
    datePicker.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    [datePicker setMinimumDate: [NSDate date]];
    
    datePicker.layer.cornerRadius = 6;
    datePicker.layer.masksToBounds = YES;
    
    
    modalObject = [[PFAppointmentModel alloc]init];
    
    
    if (self.isFromCreateAppointmentBtn)
    {
        [self.quoteBtn setUserInteractionEnabled:YES];
        quoteTextField.text = @"";
    }
    else
    {
        _dropDownImage.hidden=YES;
        [self.quoteBtn setUserInteractionEnabled:NO];
        quoteTextField.text = self.strAppOrderCode;
        
    }
    if (!self.isFromEquipmentSetDelivery) {
        [self callApiToGetCrewServiceIntegration];
    }
    
}


-(void) deselectAllButton :(NSInteger)buttonTag {
    
    for (int i = 5000; i<5006; i++) {
        if (i == buttonTag) {
            //[(UIButton *) [self.view viewWithTag:buttonTag] setSelected:YES];
        }else{
            [(UIButton *) [self.view viewWithTag:i] setSelected:NO];
            [datePicker setHidden:YES];
        }
    }
}


#pragma mark -

#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_quoteBtn.selected){
        return [quoteArray count];
    }
    else if (_hourBtn.selected){
        return [hourArray count];
    }
    else if (_minButton.selected){
        return [minArray count];
    }
    else if (_amPMButton.selected){
        return [AMArray count];
    }
    else if (_crewButton.selected){
        return [crewArray count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
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
    
    if (_quoteBtn.selected)
    {
        PFDispatchModel *obj = [quoteArray objectAtIndex:indexPath.row];
        cell.textLabel.text=obj.strAppOrderCode;
        
    }
    else if (_hourBtn.selected)
    {
        cell.textLabel.text=[hourArray objectAtIndex:indexPath.row];
        
    }
    else if (_minButton.selected)
    {
        cell.textLabel.text=[minArray objectAtIndex:indexPath.row];
        
    }
    else if (_amPMButton.selected)
    {
        cell.textLabel.font=[UIFont systemFontOfSize:11];
        
        cell.textLabel.text=[AMArray objectAtIndex:indexPath.row];
        
    }
    else if (_crewButton.selected)
    {
        PFDispatchModel *obj = [crewArray objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:11];
        
        cell.textLabel.text = obj.strCrew_name;
        
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.quoteBtn.selected){
        crewTableView.hidden=YES;
        PFDispatchModel *obj = [quoteArray objectAtIndex:indexPath.row];
        quoteTextField.text=obj.strAppOrderCode;
        indexpath = indexPath;
    }
    else if (_hourBtn.selected){
        crewTableView.hidden=YES;
        hourTextField.text=[hourArray objectAtIndex:indexPath.row];
        _hourBtn.selected = !_hourBtn.selected;
        modalObject.strHour = [hourArray objectAtIndex:indexPath.row];
    }
    else if (_minButton.selected){
        crewTableView.hidden=YES;
        minTextField.text=[minArray objectAtIndex:indexPath.row];
        _minButton.selected = !_minButton.selected;
        modalObject.strMin = [minArray objectAtIndex:indexPath.row];
    }
    else if (_amPMButton.selected){
        crewTableView.hidden=YES;
        AMTextField.text=[AMArray objectAtIndex:indexPath.row];
        _amPMButton.selected = !_amPMButton.selected;
        modalObject.strAM = [AMArray objectAtIndex:indexPath.row];
    }
    else if (_crewButton.selected){
        crewTableView.hidden=YES;
        PFDispatchModel *obj = [crewArray objectAtIndex:indexPath.row];
        self.crewTextField.text = obj.strCrew_name;
        indexpath = indexPath;
    }
}

#pragma mark -


#pragma mark - IBActions
- (IBAction)openDatePickerTableView:(UIButton *)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    dateTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter1 stringFromDate:[datePicker date]];
    
    [self deselectAllButton:sender.tag];
    _dateButton.selected = !_dateButton.selected;
    
    if (self.dateButton.selected) {
        [datePicker setHidden:NO];
    }else{
        [datePicker setHidden:YES];
        
    }
    
    [crewTableView setHidden:YES];
    _quoteBtn.selected = NO;
    _crewButton.selected = NO;
    _hourBtn.selected = NO;
    _minButton.selected = NO;
    _amPMButton.selected = NO;
    
}

- (IBAction)openQuoteTableView:(UIButton *)sender{
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    
    [crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    _quoteBtn.selected = !_quoteBtn.selected;
    
    if (_quoteBtn.selected) {
        [crewTableView setHidden:NO];
        
    }else{
        [crewTableView setHidden:YES];
        
    }
    
    [crewTableView reloadData];
}


- (IBAction)hideTableView:(id)sender{
    
    quoteTableView.hidden=YES;
    hourTableView.hidden=YES;
    crewTableView.hidden=YES;
    
    minTableView.hidden=YES;
    AMTableView.hidden=YES;
    datePicker.hidden=YES;
    
    _quoteBtn.selected = NO;
    _crewButton.selected = NO;
    _dateButton.selected = NO;
    
    
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0,0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


- (IBAction)HourSelection:(UIButton *)sender{
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    
    rect.size.height = 85;
    rect.size.width = 55;
    
    _hourBtn.selected = !_hourBtn.selected;
    
    [crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    
    if (_hourBtn.selected) {
        [crewTableView setHidden:NO];
        
    }else{
        [crewTableView setHidden:YES];
        
    }
    [crewTableView reloadData];
}

- (IBAction)minSelection:(UIButton *)sender{
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    
    rect.size.width = 55;
    rect.size.height = 85;
    
    
    [crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    _minButton.selected = !_minButton.selected;
    
    if (_minButton.selected) {
        [crewTableView setHidden:NO];
        
    }else{
        [crewTableView setHidden:YES];
        
    }
    [crewTableView reloadData];
    
}

- (IBAction)AMSelection:(UIButton *)sender{
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    rect.size.height = 80;
    rect.size.width = 55;
    
    [crewTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    _amPMButton.selected = !_amPMButton.selected;
    
    if (_amPMButton.selected) {
        [crewTableView setHidden:NO];
        
    }else{
        [crewTableView setHidden:YES];
        
    }
    [crewTableView reloadData];
    
}

- (IBAction)saveSelection:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [self.view endEditing:YES];
    
    alertTitle=@"Information";
    
    if ([quoteTextField.text length]==0){
        alertMessage=@"Please select quote.";
        [self callAlertView];
    }
    else if ([self.crewTextField.text length]==0 && !self.isFromEquipment && !self.isFromEquipmentSetDelivery){
        alertMessage=@"Please select crew.";
        [self callAlertView];
        
    }
    else if ([dateTextField.text length]==0){
        alertMessage=@"Please select date.";
        [self callAlertView];
        
    }
    else if ([hourTextField.text length]==0){
        alertMessage=@"Please select HH.";
        [self callAlertView];
        
    }
    else if ([minTextField.text length]==0){
        alertMessage=@"Please select MM.";
        [self callAlertView];
        
    }
    else if ([AMTextField.text length]==0){
        alertMessage=@"Please select time period.";
        [self callAlertView];
        
    }
    else{
        if (self.isFromEquipment || self.isFromEquipmentSetDelivery)
            [self createAppoinmentFromEquipmentServiceIntegration];
        else
            [self createAppoinmentServiceIntegration];
    }
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (IBAction)dateSelectionn:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    dateTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter1 stringFromDate:[datePicker date]];
}

- (void) onKeyboardHide:(NSNotification *)notification{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)crewButtonAction:(UIButton *)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    [self deselectAllButton:sender.tag];
    
    
    [crewTableView setFrame:rect];
    _crewButton.selected = !_crewButton.selected;
    
    if (_crewButton.selected) {
        [crewTableView setHidden:NO];
        
    }else{
        [crewTableView setHidden:YES];
        
    }
    [crewTableView reloadData];
    
}


#pragma mark -


#pragma mark - UITextFileld delegate
- (void)textViewDidBeginEditing:(UITextField *)textField{
    
    quoteTableView.hidden=YES;
    datePicker.hidden=YES;
    hourTableView.hidden=YES;
    minTableView.hidden=YES;
    AMTableView.hidden=YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, -300.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark -

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



#pragma mark - Service Helper Method

-(void)createAppoinmentServiceIntegration{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"newAppointment"forKey:@"action"];
    
    if (self.isFromCreateAppointmentBtn) {
        PFDispatchModel *obj = [quoteArray objectAtIndex:indexpath.row];
        
        [dict setValue:obj.strAppCustomerId forKey:@"customerId"];
        [dict setValue:obj.strAppShopId forKey:@"shopId"];
        [dict setValue:obj.strAppOrderId forKey:@"orderId"];
    }else{
        [dict setValue:self.strAppCustomerId forKey:@"customerId"];
        [dict setValue:self.strAppShopId forKey:@"shopId"];
        [dict setValue:self.strAppOrderId forKey:@"orderId"];
    }
    
    if ([AMTextField.text isEqualToString:@"AM"]) {
        [dict setValue:[NSString stringWithFormat:@"%@ %@:%@:%@",selectedDate,hourTextField.text,minTextField.text,@"00"] forKey:@"appointmentDate"];
    }else{
        NSString *strHour = [NSString stringWithFormat:@"%ld",(long)[hourTextField.text integerValue] + 12];
        [dict setValue:[NSString stringWithFormat:@"%@ %@:%@:%@",selectedDate,strHour,minTextField.text,@"00"] forKey:@"appointmentDate"];
    }
    
    [dict setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"createdDate"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"createdById"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Appointment created successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if(index == 0)
                     {
                         if ([self.strScreenIndicator isEqualToString:@"install"])
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"refershInstallList" object:nil];
                         }
                         else if ([self.strScreenIndicator isEqualToString:@"preinspection"])
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"refershPreInspectionList" object:nil];
                         }
                         else
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"refershDispatchList" object:nil];
                         }
                         
                         [self dismissViewControllerAnimated:NO completion:^{
                             
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

-(void)callgetDispatchServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"pendingAppointment"forKey:@"action"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                [quoteArray removeAllObjects];
                
                NSArray *DispatchListArray = [response objectForKeyNotNull:@"orderList" expectedClass:[NSArray class]];
                for (NSMutableDictionary *dispatchDict in DispatchListArray) {
                    PFDispatchModel *dispatchInfo = [PFDispatchModel modelOrderListDict:dispatchDict];
                    [quoteArray addObject:dispatchInfo];
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


-(void)callApiToGetCrewServiceIntegration{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getCrewList" forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kShop_id] forKey:@"shop_id"];
    
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
                
                [crewTableView reloadData];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}



-(void)createAppoinmentFromEquipmentServiceIntegration{
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormatter1 dateFromString:dateTextField.text];
    
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter2 stringFromDate:date];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.isFromEquipmentSetDelivery)
        [dict setValue:@"setEquipmentOrderDelivery"forKey:@"action"];
    else
        [dict setValue:@"markeEquipmentDelivered"forKey:@"action"];
    
    [dict setValue:self.objEditDetail.strOrderId forKey:@"order_id"];
    [dict setValue:selectedDate forKey:@"apt_date"];
    [dict setValue:hourTextField.text forKey:@"date_1_hh"];
    [dict setValue:minTextField.text forKey:@"date_1_mm"];
    [dict setValue:([AMTextField.text isEqualToString:@"AM"])?@"am":@"pm" forKey:@"date_1_ss"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Appointment created successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
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


#pragma mark -

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

@end
