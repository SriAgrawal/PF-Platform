//
//  editAppointmentViewController.m
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 26/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import "editAppointmentViewController.h"

@interface editAppointmentViewController () <UITextViewDelegate>{
    
    NSString *selectedDate;
    NSDate *selectDate;
    NSMutableArray *crewArray;

}
@property (weak, nonatomic) IBOutlet UIButton *crewButton;
@property (weak, nonatomic) IBOutlet UITextField *crewTextField;

@end

@implementation editAppointmentViewController

@synthesize strAppoinmentId;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    
    quoteTableView=[[UITableView alloc]initWithFrame:CGRectMake(152, 190, 720, 30) style:UITableViewStylePlain];
    quoteTableView.dataSource=self;
    quoteTableView.delegate=self;
    [backgroundViewForTextView addSubview:quoteTableView];
    
    quoteArray=[[NSMutableArray alloc]init];
    crewArray = [NSMutableArray array];

    hourArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    minArray=[[NSMutableArray alloc]initWithObjects:@"00",@"15",@"30",@"45", nil];
    AMArray=[[NSMutableArray alloc]initWithObjects:@"AM",@"PM", nil];

    
     quoteTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    
     hourTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
     minTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
     AMTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    
    quoteTableView.layer.cornerRadius = 6;
    quoteTableView.layer.masksToBounds = YES;
    
    hourTableView.layer.cornerRadius = 6;
    hourTableView.layer.masksToBounds = YES;
    
    minTableView.layer.cornerRadius = 6;
    minTableView.layer.masksToBounds = YES;
    
    AMTableView.layer.cornerRadius = 6;
    AMTableView.layer.masksToBounds = YES;
    
    backgroundViewForTextView.layer.cornerRadius = 5;
    backgroundViewForTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backgroundViewForTextView.layer.borderWidth = 1.0f;
    backgroundViewForTextView.layer.masksToBounds = YES;
    
    messageTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    messageTextView.layer.borderWidth = 1.0f;

    quoteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    hourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    minTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AMTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    quoteTableView.hidden=YES;
    datePicker.hidden=YES;
    hourTableView.hidden=YES;
    minTableView.hidden=YES;
    AMTableView.hidden=YES;



    datePicker.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    [datePicker setMinimumDate: [NSDate date]];

    datePicker.layer.cornerRadius = 6;
    datePicker.layer.masksToBounds = YES;


    if (self.isFromTechCheck) {
        
        NSArray *strings = [self.objEditDetail.strAptDate componentsSeparatedByString:@" "];
        
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
    }else {
      NSArray *strings = [self.obj_editDetail.strApointmenttDate componentsSeparatedByString:@" "];
        quoteTextField.text = self.obj_editDetail.strOrderCode;

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
    [self callApiToGetCrewServiceIntegration];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.quoteBtn.selected)
    {
        return [quoteArray count];
    }
    else if (self.hourBtn.selected)
    {
        return [hourArray count];
    }
    else if (self.minButton.selected)
    {
        return [minArray count];
    }
    else if (self.amPMButton.selected)
    {
        return [AMArray count];
    }else if (_crewButton.selected) {
        return [crewArray count];
    }
    
    else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    cell.textLabel.font=[UIFont systemFontOfSize:13];

    if (self.quoteBtn.selected)
    {
        cell.textLabel.text=[quoteArray objectAtIndex:indexPath.row];
    }
    else if (self.hourBtn.selected)
    {
        cell.textLabel.text=[hourArray objectAtIndex:indexPath.row];
        
    }
    else if (self.minButton.selected)
    {
        cell.textLabel.text=[minArray objectAtIndex:indexPath.row];
    }
    else if (self.amPMButton.selected)
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.quoteBtn.selected)
    {
        quoteTableView.hidden=YES;
        quoteTextField.text=[quoteArray objectAtIndex:indexPath.row];
        
    }
    else if (self.hourBtn.selected)
    {
        quoteTableView.hidden=YES;
        hourTextField.text=[hourArray objectAtIndex:indexPath.row];
    }
    else if (self.minButton.selected)
    {
        quoteTableView.hidden=YES;
        minTextField.text=[minArray objectAtIndex:indexPath.row];
    }
    else if (self.amPMButton.selected)
    {
        quoteTableView.hidden=YES;
        AMTextField.text=[AMArray objectAtIndex:indexPath.row];
    }
    else if (_crewButton.selected){
        quoteTableView.hidden=YES;
        PFDispatchModel *obj = [crewArray objectAtIndex:indexPath.row];
        self.crewTextField.text = obj.strCrew_name;
        self.strCrewId  = obj.strCrew_id;
    }
    
}

-(void) deselectAllButton :(NSInteger)buttonTag {
    
    for (int i = 5000; i<5006; i++) {
        if (i == buttonTag) {

        }else{
            [(UIButton *) [self.view viewWithTag:i] setSelected:NO];
            [datePicker setHidden:YES];
        }
    }
}


- (IBAction)dateSelection:(id)sender
{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"M/d/yy"];
    
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter1 stringFromDate:[datePicker date]];
    

    dateTextField.text = [dateFormatter stringFromDate:[datePicker date]];
}

- (IBAction)openDatePickerTableView:(id)sender
{
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    selectDate = [dateFormatter1 dateFromString:selectedDate];
    
    if (dateTextField.text.length) {
        [datePicker setDate:selectDate];
    }else{
        [datePicker setMinimumDate: [NSDate date]];
        
    }
    
    if (datePicker.hidden==NO)
    {
        datePicker.hidden=YES;
    }
    else
    {
        tableviewIndicator=@"date";
        
        datePicker.hidden=NO;
        quoteTableView.hidden=YES;
        hourTableView.hidden=YES;
        minTableView.hidden=YES;
        AMTableView.hidden=YES;
        
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

- (IBAction)openQuoteTableView:(UIButton *)sender
{
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    
    [quoteTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    _quoteBtn.selected = !_quoteBtn.selected;
    
    if (_quoteBtn.selected) {
        [quoteTableView setHidden:NO];
        
    }else{
        [quoteTableView setHidden:YES];
        
    }
    
    [quoteTableView reloadData];

}

- (IBAction)hideTableView:(id)sender
{
    quoteTableView.hidden=YES;
    hourTableView.hidden=YES;
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


- (IBAction)crewButtonAction:(UIButton *)sender {
    
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    [self deselectAllButton:sender.tag];
    
    // if (!crewArray.count) {
    //    [self callApiToGetCrewServiceIntegration];
    // }
    
    [quoteTableView setFrame:rect];
    _crewButton.selected = !_crewButton.selected;
    
    if (_crewButton.selected) {
        [quoteTableView setHidden:NO];
        
    }else{
        [quoteTableView setHidden:YES];
        
    }
    [quoteTableView reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)closeBtnAction:(UIButton *)sender {
    
    // [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    
}

- (IBAction)HourSelection:(UIButton *)sender
{
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    
    rect.size.height = 120;
    rect.size.width = 55;
    
    _hourBtn.selected = !_hourBtn.selected;
    
    [quoteTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    
    if (_hourBtn.selected) {
        [quoteTableView setHidden:NO];
        
    }else{
        [quoteTableView setHidden:YES];
    }
    [quoteTableView reloadData];
}

- (IBAction)minSelection:(UIButton *)sender{

    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    
    rect.size.width = 55;
    rect.size.height = 120;
    
    [quoteTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    _minButton.selected = !_minButton.selected;
    
    if (_minButton.selected) {
        [quoteTableView setHidden:NO];
        
    }else{
        [quoteTableView setHidden:YES];
    }
    [quoteTableView reloadData];
}

- (IBAction)AMSelection:(UIButton *)sender{
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.origin.x =rect.origin.x-5;
    rect.size.height = 80;
    rect.size.width = 55;
    
    [quoteTableView setFrame:rect];
    [self deselectAllButton:sender.tag];
    _amPMButton.selected = !_amPMButton.selected;
    
    if (_amPMButton.selected) {
        [quoteTableView setHidden:NO];
        
    }else{
        [quoteTableView setHidden:YES];
        
    }
    [quoteTableView reloadData];
}

- (void)textViewDidBeginEditing:(UITextField *)textField {
    
    quoteTableView.hidden=YES;
    datePicker.hidden=YES;
    hourTableView.hidden=YES;
    minTableView.hidden=YES;
    AMTableView.hidden=YES;
    messageTextView.layer.borderColor = KHomeTextFieldBorderColor;
    
   
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(0, -300.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    messageTextView.layer.borderColor = KHomeTextFieldGrayBorderColor;

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

- (IBAction)saveSelection:(id)sender{
    
    datePicker.hidden=YES;
    hourTableView.hidden=YES;
    minTableView.hidden=YES;
    AMTableView.hidden=YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(0, 0.0,
                                 self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    [self.view endEditing:YES];
    
    alertTitle=@"Information";

    if ([quoteTextField.text length]==0)
    {
        alertMessage=@"Please select quote.";
        [self callAlertView];
        
    }
    else if ([_crewTextField.text length]==0)
    {
        alertMessage=@"Please select crew.";
        [self callAlertView];
        
    }
    else if ([dateTextField.text length]==0)
    {
        alertMessage=@"Please select date.";
        [self callAlertView];
        
    }
    else if ([hourTextField.text length]==0 || [hourTextField.text isEqualToString:@"00"])
    {
        alertMessage=@"Please select HH.";
        [self callAlertView];
        
    }
    else if ([minTextField.text length]==0)
    {
        alertMessage=@"Please select MM.";
        [self callAlertView];
        
    }
    else if ([AMTextField.text length]==0)
    {
        alertMessage=@"Please select time period.";
        [self callAlertView];
        
    }
//    else if ([messageTextView.text length]==0)
//    {
//        alertMessage=@"Please enter reason for changing appointment time.";
//        [self callAlertView];
// 
//    }
    else
    {
        if (self.isFromTechCheckForEdit) {
            [self updateAppoinmentFromInstallServiceIntegration];

        }else{
        [self updateAppoinmentServiceIntegration];
        }
    }
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



#pragma mark

#pragma mark - Service Helper Method
-(void)getAppoinmentServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getAppointment"forKey:@"action"];
    [dict setValue:self.strAppoinmentId forKey:@"appointmentId"];
    
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            NSDictionary *appoinmentDict = [response objectForKeyNotNull:@"appointmentDetail" expectedClass:[NSDictionary class]];
           
            [quoteTextField setText:[appoinmentDict objectForKeyNotNull:@"order_code" expectedClass:[NSString class]]];
            //1970\/1\/1 00:00:00
                
            NSString *appointDate = [PFUtility timeStampToDateOnlyShowYY:[appoinmentDict objectForKeyNotNull:@"apt_date" expectedClass:[NSString class]]];
            NSArray *strings = [appointDate componentsSeparatedByString:@" "];
            
            NSString *strDate=[strings objectAtIndex:0];
            
            NSString *strHour = [[strings objectAtIndex:1] substringWithRange:NSMakeRange(0, 2)];
            
            NSString *strMin = [[strings objectAtIndex:1] substringWithRange:NSMakeRange(3, 2)];

            if ([strHour integerValue] > 12) {
                strHour = [NSString stringWithFormat:@"%ld",(long)[strHour integerValue] - 12];
                [AMTextField setText:@"PM"];
            }else{
                [AMTextField setText:@"AM"];

            }

            NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"MM/dd/yyyy"];
            NSDate *date = [dateFormatter1 dateFromString:strDate];
            
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            selectedDate = [dateFormatter2 stringFromDate:date];
            
            //selectedDate = [NSString stringWithFormat:@"%@",date];
            [dateTextField setText:strDate];
            [hourTextField setText:strHour];
            [minTextField setText:strMin];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


-(void)callApiToGetCrewServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getCrewList" forKey:@"action"];
    
    if (self.isFromRepair) {
        [dict setValue:[NSUSERDEFAULTS valueForKey:kShop_id] forKey:@"shop_id"];
    }else
    [dict setValue:(self.isFromTechCheck)?self.objEditDetail.strShopId:self.obj_editDetail.strShopId forKey:@"shop_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            
            [crewArray removeAllObjects];
            
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dispatchListDict = [response objectForKeyNotNull:@"crewList" expectedClass:[NSDictionary class]];
                
                NSArray *dispatchListArray =[dispatchListDict objectForKeyNotNull:@"crewData" expectedClass:[NSArray class]];
                
                
                if (dispatchListDict && [dispatchListDict isKindOfClass:[NSDictionary class]]) {
                    
                    if (dispatchListArray && [dispatchListArray isKindOfClass:[NSArray class]]) {
                        for (NSMutableDictionary *dispatchDict in dispatchListArray) {
                            PFDispatchModel *dispatchInfo = [PFDispatchModel modelCrewDict:dispatchDict];
                            [crewArray addObject:dispatchInfo];
                        }
                    }
                }
                
                [self getAppoinmentServiceIntegration];
                
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



-(void)updateAppoinmentServiceIntegration
{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"editAppointments"forKey:@"action"];
    
    [dict setValue:self.strAppoinmentId forKey:@"appointmentId"];
    [dict setValue:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]] forKey:@"date"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"updatedById"];
    [dict setValue:messageTextView.text forKey:@"notes"];
    [dict setValue:self.strCrewId forKey:@"crew_id"];

    
    if ([AMTextField.text isEqualToString:@"AM"]) {
        [dict setValue:[NSString stringWithFormat:@"%@ %@:%@:%@",selectedDate,hourTextField.text,minTextField.text,@"00"] forKey:@"appointDate"];
        
    }else{
        NSString *strHour = [NSString stringWithFormat:@"%ld",(long)[hourTextField.text integerValue] + 12];
        
        [dict setValue:[NSString stringWithFormat:@"%@ %@:%@:%@",selectedDate,strHour,minTextField.text,@"00"] forKey:@"appointDate"];
        
    }
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
            
            [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Appointment updated successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                
                if(index == 0)
                {
                    if (self.isFromTechCheck) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self.delegate callTechCheckApi];
                         }];
                    }
                    
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


-(void)updateAppoinmentFromInstallServiceIntegration
{
    //    {"action":"createAppointment","apt_date":"2017-11-12","apt_id":"120","crew_id":"Install Crew","date_1_hh":"08","date_1_mm":"45","date_1_ss":"PM","order_id":"125"}
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"createAppointment"forKey:@"asd"];
    
    
    [dict setValue:@"createAppointment" forKey:@"action"];
    [dict setValue:_strOrderId forKey:@"order_id"];
    [dict setValue:@"0" forKey:@"apt_id"];
    [dict setValue:self.strCrewId forKey:@"crew_id"];
    [dict setValue:selectedDate forKey:@"apt_date"];
    [dict setValue:hourTextField.text forKey:@"date_1_hh"];
    [dict setValue:minTextField.text forKey:@"date_1_mm"];
    [dict setValue:[AMTextField.text isEqualToString:@"AM"]?@"am":@"pm" forKey:@"date_1_ss"];
    [dict setValue:messageTextView.text forKey:@"change_notes"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    
    
    //    [dict setValue:self.strAppoinmentId forKey:@"appointmentId"];
    //    [dict setValue:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]] forKey:@"date"];
    //    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"updatedById"];
    //    [dict setValue:messageTextView.text forKey:@"notes"];
    //    [dict setValue:self.strCrewId forKey:@"crew_id"];
    //
    //
    //    if ([AMTextField.text isEqualToString:@"AM"]) {
    //        [dict setValue:[NSString stringWithFormat:@"%@ %@:%@:%@",selectedDate,hourTextField.text,minTextField.text,@"00"] forKey:@"appointDate"];
    //
    //    }else{
    //        NSString *strHour = [NSString stringWithFormat:@"%ld",(long)[hourTextField.text integerValue] + 12];
    //
    //        [dict setValue:[NSString stringWithFormat:@"%@ %@:%@:%@",selectedDate,strHour,minTextField.text,@"00"] forKey:@"appointDate"];
    //
    //    }
    //
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Appointment updated successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    if(index == 0)
                    {
                        if (self.isFromTechCheck) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                [self.delegate callTechCheckApi];
                            }];
                        }
                        
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

#pragma mark


@end
