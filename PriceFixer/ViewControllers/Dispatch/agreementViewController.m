//
//  agreementViewController.m
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 27/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import "agreementViewController.h"
#import "agreementTextViewController.h"
#import "PFApproveEquipmentInfo.h"

@interface agreementViewController ()
    @property (weak, nonatomic) IBOutlet UILabel *lblEquipment;
    @property (weak, nonatomic) IBOutlet UILabel *lblInstallationKits;
    @property (weak, nonatomic) IBOutlet UILabel *lblLabour;
    @property (weak, nonatomic) IBOutlet UILabel *lblDueInstallation;
    @property (weak, nonatomic) IBOutlet UILabel *lblPaidAmount;
    @property (weak, nonatomic) IBOutlet UILabel *lblDueToday;

@property (weak, nonatomic) IBOutlet UIView *viewForApprovedEquipment;
@property (weak, nonatomic) IBOutlet UIView *viewForApprovedLabour;
@property (weak, nonatomic) IBOutlet UILabel *lbltotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTax;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtotal;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerSaving;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerSavingValue;

@property (weak, nonatomic) IBOutlet UILabel *lblStaticText;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIView *viewInTable;


@end

@implementation agreementViewController
@synthesize strOrderId;
@synthesize strOrderCode;
#pragma mark - Table View Delegate and Data source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==monthTableView)
    {
        return [monthArray count];
    }
    else if (tableView==yearTableView)
    {
        return [yearArray count];
    }
    else
    {
        return [name count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableviewIndicator isEqualToString:@"month"])
    {
        monthTableView.hidden=YES;
        credeitCardExpireMonTextField.text=[monthArray objectAtIndex:indexPath.row];
        
    }
    else  if ([tableviewIndicator isEqualToString:@"year"])
    {
        yearTableView.hidden=YES;
        credeitCardExpireYearTextField.text=[yearArray objectAtIndex:indexPath.row];
    }
    else
    {
        [self.view endEditing:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==monthTableView || tableView==yearTableView)
    {
        return 30;
    }
    else
    {
        return 40;
    }
    
    
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
    
    
    if (tableView==monthTableView)
    {
        cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        cell.textLabel.text=[monthArray objectAtIndex:indexPath.row];
    }
    else if (tableView==yearTableView)
    {
        cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        cell.textLabel.text=[yearArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if ([[arrayIndicator objectAtIndex:indexPath.row]isEqualToString:@"0"])
        {
            
            UILabel *itemLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 370, 20)];
            itemLabel.text=[name objectAtIndex:indexPath.row];
            itemLabel.numberOfLines=1;
            itemLabel.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:itemLabel];
            
            UILabel *unitCostLabel=[[UILabel alloc]initWithFrame:CGRectMake(405, 10, 100, 20)];
            unitCostLabel.text=[@"$" stringByAppendingString:[unitCost objectAtIndex:indexPath.row]];
            unitCostLabel.numberOfLines=1;
            unitCostLabel.backgroundColor=[UIColor clearColor];
            unitCostLabel.textAlignment=NSTextAlignmentCenter;
            unitCostLabel.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:unitCostLabel];
            
            UILabel *unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(570, 10, 50, 20)];
            unitLabel.text=[unit objectAtIndex:indexPath.row];
            unitLabel.numberOfLines=1;
            unitLabel.textAlignment=NSTextAlignmentCenter;
            unitLabel.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:unitLabel];
            
            UILabel *costLabel=[[UILabel alloc]initWithFrame:CGRectMake(634, 10, 100, 20)];
            costLabel.text=[@"$" stringByAppendingString:[cost objectAtIndex:indexPath.row]];
            costLabel.numberOfLines=1;
            costLabel.textAlignment=NSTextAlignmentRight;
            costLabel.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:costLabel];
            
        }
        
        else
        {
            NSString *itemLabelValue=itemTextField.text;
            NSString *unitCostValue=unitCostTextField.text;
            NSString *unitValue=unitLabelTextField.text;

            
            itemTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, 370, 30)];
            itemTextField.textAlignment=NSTextAlignmentCenter;
            itemTextField.delegate=self;
            itemTextField.returnKeyType=UIReturnKeyNext;
            itemTextField.layer.cornerRadius = 4;
            itemTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            itemTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            itemTextField.layer.borderWidth = 1.0f;
            itemTextField.layer.masksToBounds = YES;
            
            itemTextField.tag=1;
            [cell.contentView addSubview:itemTextField];
            
            unitCostTextField=[[UITextField alloc]initWithFrame:CGRectMake(405, 5, 100, 30)];
            unitCostTextField.returnKeyType=UIReturnKeyNext;
            
            unitCostTextField.textAlignment=NSTextAlignmentCenter;
            unitCostTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            
            unitCostTextField.delegate=self;
            unitCostTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
            
            unitCostTextField.layer.cornerRadius = 4;
            unitCostTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            unitCostTextField.layer.borderWidth = 1.0f;
            unitCostTextField.layer.masksToBounds = YES;
            unitCostTextField.tag=2;
            [cell.contentView addSubview:unitCostTextField];
            
            unitLabelTextField=[[UITextField alloc]initWithFrame:CGRectMake(570, 5, 50, 30)];
            unitLabelTextField.returnKeyType=UIReturnKeyDone;
            
            unitLabelTextField.autocorrectionType=UITextAutocorrectionTypeNo;
            unitLabelTextField.textAlignment=NSTextAlignmentCenter;
            unitLabelTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
            unitLabelTextField.delegate=self;
            unitLabelTextField.layer.cornerRadius = 4;
            unitLabelTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            unitLabelTextField.layer.borderWidth = 1.0f;
            unitLabelTextField.layer.masksToBounds = YES;
            unitLabelTextField.tag=3;
            [cell.contentView addSubview:unitLabelTextField];
            
            itemTextField.text=itemLabelValue;
            unitCostTextField.text=unitCostValue;
            unitLabelTextField.text=unitValue;
            
        }
        
    }
    
    return cell;
}


#pragma mark -

#pragma mark - IB Actions
- (IBAction)hideKeyboardAction:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)getImageBtnPressed:(id)sender
{

}

- (IBAction)closeBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)termsReadAction:(UIButton *)sender
{
    agreementTextViewController *objVC = [[agreementTextViewController alloc]initWithNibName:@"agreementTextViewController" bundle:nil];
    
    objVC.agreementTextString=[listArray  valueForKey:@"agreement_text"];
    objVC.strOrderCode = strOrderCode;
    [self addChildViewController:objVC];
    [self.view addSubview:objVC.view];
    [objVC didMoveToParentViewController:self];
    

}

- (IBAction)monthAction:(id)sender
{
    if (monthTableView.hidden==NO)
    {
        monthTableView.hidden=YES;
    }
    else
    {
        tableviewIndicator=@"month";
        
        monthTableView.hidden=NO;
        yearTableView.hidden=YES;
        
    }
}
- (IBAction)yearAction:(id)sender
{
    if (yearTableView.hidden==NO)
    {
        yearTableView.hidden=YES;
    }
    else
    {
        tableviewIndicator=@"year";
        
        yearTableView.hidden=NO;
        monthTableView.hidden=YES;
        
    }
 }

- (IBAction)updateAction:(id)sender
{
    monthTableView.hidden=YES;
    yearTableView.hidden=YES;
    
    
    alertTitle=@"Information";
    
    
    [self.view endEditing:YES];
    
    
    valueForViewMoveUp=0;
    [self moveViewUp];

     if (self.agreementViewType == repeatAgreementType_ApprovedEquipment)
    {
        [self callAPIForConfirmApprovedEquipment];
    }
     else if ((self.agreementViewType == repeatAgreementType_ApprovedLabour && self.isViewFromInstallFinalBill) || self.isViewFromRepairFinalBill)
     {
         [self callAPIForPaymentFinalBill];
         
     }
     else if (self.agreementViewType == repeatAgreementType_ApprovedLabour)
    {
        [self callAPIForConfirmApprovedLabour];
      
    }

}

- (IBAction)addRowAction:(id)sender
{
    
    if ([checkForFirstTimeAddition length]==0)
    {
        checkForFirstTimeAddition=@"selected";
        
        [arrayIndicator addObject:@"1"];
        [name addObject:@""];
        [unitCost addObject:@""];
        [unit addObject:@""];
        [cost addObject:@""];

        [productTableView reloadData];
        
    }
    
    else if ([itemTextField.text length]>0 &&[unitCostTextField.text length]>0 &&[unitLabelTextField.text length]>0)
    {
        checkForFirstTimeAddition=@"";
        
        [arrayIndicator removeLastObject];
        [name removeLastObject];
        [unitCost removeLastObject];
        [unit removeLastObject];
        [cost removeLastObject];
        
        [arrayIndicator addObject:@"0"];
        [name addObject:itemTextField.text];
        [unitCost addObject:unitCostTextField.text];
        [unit addObject:unitLabelTextField.text];
        
        float totalCost=[unitLabelTextField.text integerValue]*[unitCostTextField.text floatValue];
        
        subTotalValue=subTotalValue+totalCost;
        
        subTotalLabel.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",subTotalValue]];
        TotalLabel.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",subTotalValue]];
        
        [cost addObject:[NSString stringWithFormat:@"%.02f",totalCost]];
        
        itemTextField.text=@"";
        unitCostTextField.text=@"";
        unitLabelTextField.text=@"";
        
        [productTableView reloadData];
        
    }
    else
    {
        
    }
}

#pragma mark -

#pragma mark - Custom methods for notifying Actions

-(void)disableScroll
{
    productTableView.scrollEnabled=NO;

}

-(void)enableScroll
{
    productTableView.scrollEnabled=YES;

}


#pragma mark - Common Method

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

#pragma mark - View Controller Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    signatureView= [[PJRSignatureView alloc] initWithFrame:CGRectMake(2, 2,349, 124)];
    [signatureBackGroundView addSubview:signatureView];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [self.lblCustomerSavingValue setHidden:YES];
    [self.lblCustomerSaving setHidden:YES];
    if(self.agreementViewType == repeatAgreementType_Dispach)
    {
         [self callAPIForApprovedEquipment:@"approveEquipment"];
        self.viewForApprovedLabour.hidden = YES;
        self.viewForApprovedEquipment.hidden = NO;
        orderCodeAgreementLabel.text=[[strOrderCode stringByAppendingString:@" "]stringByAppendingString:@"Agreement"];

    }
    else if (self.agreementViewType == repeatAgreementType_ApprovedEquipment)
    {
        [self callAPIForApprovedEquipment:@"approveEquipment"];
        self.viewForApprovedLabour.hidden = YES;
        _btnConfirm.hidden = NO;
        _lblStaticText.hidden = NO;
        _lblStaticText.text = @"Please confirm that this is the equipment that is required for the property and that the home owner understands any changes.";
        orderCodeAgreementLabel.text=@"Order Invoice";
        [self.lblCustomerSavingValue setHidden:NO];
        [self.lblCustomerSaving setHidden:NO];

    }
    else if (self.agreementViewType == repeatAgreementType_ApprovedLabour){
        [self callAPIForApprovedLabour:@"approveLabor"];
        self.viewForApprovedLabour.hidden = NO;
        self.viewForApprovedEquipment.hidden = YES;
        _btnConfirm.hidden = NO;
        _lblStaticText.hidden = NO;
        orderCodeAgreementLabel.text=[[strOrderCode stringByAppendingString:@" "]stringByAppendingString:@"Agreement"];

        self.lblStaticText.frame = CGRectMake(8, 150, productTableView.frame.size.width-16, 46);
        _btnConfirm.frame = CGRectMake(293, 220, 173, 53);
    }
    else
        orderCodeAgreementLabel.text=[[strOrderCode stringByAppendingString:@" "]stringByAppendingString:@"Agreement"];

    
    if (self.isViewFromInstall) {
        orderCodeAgreementLabel.text=[[strOrderCode stringByAppendingString:@" "]stringByAppendingString:@"Agreement"];
        _btnConfirm.hidden = YES;
        _lblStaticText.hidden = YES;
      }
    else if (self.isViewFromInstallFinalBill) {
        orderCodeAgreementLabel.text = [NSString stringWithFormat:@"Process Final Bill for %@",strOrderCode];
        _btnConfirm.hidden = NO;
        _lblStaticText.hidden = NO;
        _lblStaticText.text = @"Please walkthrough the installation with the homeowner and answer any question. Once completed you will submit for final payment pressing the button below.";
        [_btnConfirm setTitle:@"Process Final Payment" forState:UIControlStateNormal];
        _btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    else if(self.isViewFromRepairFinalBill){
        
        orderCodeAgreementLabel.text = [NSString stringWithFormat:@"Process Final Bill for %@",strOrderCode];
        _btnConfirm.hidden = NO;
        _lblStaticText.hidden = NO;
        _lblStaticText.text = @"Please walkthrough the repair with the homeowner and answer any questions. Once completed and you have received the walkthrough signature you will submit for final payment pressing the button below.";
        [_btnConfirm setTitle:@"Process Final Payment" forState:UIControlStateNormal];
        _btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppDelegate * appDelegate = APPDELEGATE;
    appDelegate.signatureViewTappedIndicator=@"yes";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableScroll) name:@"disableScroll" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableScroll) name:@"enableScroll" object:nil];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    termsReadButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"terms"
                                                             attributes:underlineAttribute];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    textViewAgreement.editable=NO;

    productTableView.backgroundColor=[UIColor clearColor];
    productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    subTotalValue=0.00;
    
    name=[[NSMutableArray alloc]init];
    unitCost=[[NSMutableArray alloc]init];
    unit=[[NSMutableArray alloc]init];
    cost=[[NSMutableArray alloc]init];
    arrayIndicator=[[NSMutableArray alloc]init];
    
    
    monthArray=[[NSMutableArray alloc]initWithObjects:@"January 01",@"February 02",@"March 03",@"April 04",@"May 05",@"June 06",@"July 07",@"August 08",@"September 09",@"October 10",@"November 11",@"December 12", nil];
    
    yearArray=[[NSMutableArray alloc]initWithObjects:@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027", nil];


    agreementView.layer.cornerRadius = 8;
    agreementView.layer.masksToBounds = YES;
    
    signatureBackGroundView.layer.borderColor = [UIColor blackColor].CGColor;
    signatureBackGroundView.layer.borderWidth = 2.0f;
    
   // agreementView.hidden=YES;
    monthTableView.hidden=YES;
    yearTableView.hidden=YES;
    
    monthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    yearTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    monthTableView.layer.cornerRadius = 6;
    monthTableView.layer.masksToBounds = YES;

    yearTableView.layer.cornerRadius = 6;
    yearTableView.layer.masksToBounds = YES;

}

#pragma mark -


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark - Text Field Delegate Methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==unitLabelTextField ||textField==unitCostTextField ||textField==credeitCardNumberTextField ||textField==credeitCardCVVTextField)
    {
        if (textField==credeitCardCVVTextField ||textField==credeitCardNumberTextField)
        {
            if (textField==credeitCardCVVTextField)
            {
                if (textField.text.length >=3 && range.length == 0)
                {
                    return NO; // return NO to not change text
                }
                else
                {
                    
                }
            }
            else
            {
                if (textField.text.length >=16 && range.length == 0)
                {
                    return NO; // return NO to not change text
                }
                else
                {
                    
                }
            }
        }
        if([string length]==0)
        {
            return YES;
        }
        
        /*  limit to only numeric characters  */
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if ([myCharSet characterIsMember:c])
            {
                return YES;
            }
        }
        
        return NO;
    }
    else
    {
        return YES;
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField==unitLabelTextField)
    {
        if ([itemTextField.text length]>0 &&[unitCostTextField.text length]>0 &&[unitLabelTextField.text length]>0)
        {
            checkForFirstTimeAddition=@"";

            [arrayIndicator removeLastObject];
            [name removeLastObject];
            [unitCost removeLastObject];
            [unit removeLastObject];
            [cost removeLastObject];

            [arrayIndicator addObject:@"0"];
            [name addObject:itemTextField.text];
            [unitCost addObject:unitCostTextField.text];
            [unit addObject:unitLabelTextField.text];

            float totalCost=[unitLabelTextField.text integerValue]*[unitCostTextField.text floatValue];
            
            subTotalValue=subTotalValue+totalCost;

            subTotalLabel.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",subTotalValue]];
            TotalLabel.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",subTotalValue]];

            [cost addObject:[NSString stringWithFormat:@"%.02f",totalCost]];

            itemTextField.text=@"";
            unitCostTextField.text=@"";
            unitLabelTextField.text=@"";

            [productTableView reloadData];
        }
    }
    
    if (textField==itemTextField)
    {
        [itemTextField resignFirstResponder];
        [unitCostTextField becomeFirstResponder];
    }
    else if (textField==unitCostTextField)
    {
        [unitCostTextField resignFirstResponder];
        [unitLabelTextField becomeFirstResponder];
        
    }
    else if (textField==unitLabelTextField)
    {
        [unitLabelTextField resignFirstResponder];
        
    }

   else if (textField==credeitCardNameTextField)
    {
        [credeitCardNameTextField resignFirstResponder];
        [credeitCardNumberTextField becomeFirstResponder];
    }
    else if (textField==credeitCardNumberTextField)
    {
        [credeitCardNumberTextField resignFirstResponder];
        [credeitCardCVVTextField becomeFirstResponder];
        
    }
    else if (textField==credeitCardCVVTextField)
    {
        [credeitCardCVVTextField resignFirstResponder];
        
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    yearTableView.hidden=YES;
    monthTableView.hidden=YES;

    valueForViewMoveUp=-330;
    [self moveViewUp];

    
}

#pragma mark -

#pragma mark - Status Bar Visibility Setting

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Keyboard notification

- (void) onKeyboardHide:(NSNotification *)notification
{
    valueForViewMoveUp=0;
    [self moveViewUp];
    
}

#pragma mark -

#pragma mark - service helper method


-(void)callGetAgreementServiceIntegration
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"getAgreementDetails"forKey:@"action"];
    [dict setValue:strOrderId forKey:@"orderId"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                 listArray= [response valueForKey:@"responseData"];
                 itemListArray= [listArray  valueForKey:@"items"];
                 
                 for (int count=0; count<[itemListArray count]; count++)
                 {
                     [name addObject:[[itemListArray objectAtIndex:count]valueForKey:@"item_title"]];
                     [unitCost addObject:[[itemListArray objectAtIndex:count]valueForKey:@"unit_price"]];
                     [unit addObject:[[itemListArray objectAtIndex:count]valueForKey:@"qty"]];
                     [cost addObject:[[itemListArray objectAtIndex:count]valueForKey:@"line_total"]];

                     [arrayIndicator addObject:@"0"];
                }
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 dateFormatter.dateFormat = @"yyyyMMdd";
                 NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[[listArray valueForKey:@"customer_since"] doubleValue]];
                 
                 
                 dateFormatter.dateFormat=@"MMMM";
                 NSString *monthString = [[dateFormatter stringFromDate:date1] capitalizedString];
                 
                 dateFormatter.dateFormat=@"yyyy";
                 NSString *yearString = [[dateFormatter stringFromDate:date1] capitalizedString];
                 
                customerJoiningDateString=[[monthString stringByAppendingString:@" "]stringByAppendingString:yearString];
                 
                 customerJoiningDateLabel.text=[@"Customer Since " stringByAppendingString:customerJoiningDateString];
                 
                 
                 textViewAgreement.text=[listArray  valueForKey:@"agreement_text"];
              
                 address=[[[listArray valueForKey:@"billing_address1"]stringByAppendingString:[listArray valueForKey:@"billing_address2"]]stringByAppendingString:@" "];

                 
                 cityStateZip=[[[listArray valueForKey:@"billing_city"]stringByAppendingString:@", "]stringByAppendingString:[[listArray valueForKey:@"billing_state"] stringByAppendingString:[@" " stringByAppendingString:[listArray valueForKey:@"billing_zip"]]]];
                 
                 addressLabel.text=[address stringByAppendingString:cityStateZip];
                 nameLabel.text=[[[listArray valueForKey:@"customer_first_name"]stringByAppendingString:@" "]stringByAppendingString:[listArray valueForKey:@"customer_last_name"]];
                 
                 credeitCardNameTextField.text=[listArray valueForKey:@"credit_card_person"];
                 credeitCardNumberTextField.text=[listArray valueForKey:@"credit_card_number"];
                 credeitCardCVVTextField.text=@"";
              
                 fetchedMothValue=[[listArray valueForKey:@"credit_card_month"]intValue];
                 
                 NSLog(@"%i",fetchedMothValue);
                 
                 
                 if (fetchedMothValue!=0)
                 {
 credeitCardExpireMonTextField.text=[monthArray objectAtIndex:fetchedMothValue-1];                 }
                 
                 if ([[listArray valueForKey:@"credit_card_year"] isKindOfClass:[NSString class]])
                 {
                     credeitCardExpireYearTextField.text=[listArray valueForKey:@"credit_card_year"];
                 }
                 else if ([[listArray valueForKey:@"credit_card_year"] isKindOfClass:[NSNumber class]])
                 {
                    credeitCardExpireYearTextField.text=[[listArray valueForKey:@"credit_card_year"]stringValue];
                 }
                
               

                 _lblSubtotal.text=[@"$" stringByAppendingString:[listArray valueForKey:@"net_total"]];
                _lblTax.text=[@"$" stringByAppendingString:[listArray valueForKey:@"total_tax"]];
                 _lbltotal.text=[@"$" stringByAppendingString:[listArray valueForKey:@"total_amount"]];
                
                 subTotalValue=[[listArray valueForKey:@"net_total"] floatValue];
                 [productTableView reloadData];

             }
             else
             {
                 [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
             }
         }
         else
         {
                [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
         }
     }];
}

-(void)callPostAgreementServiceIntegration
{
  /* Setting up new data/rows into json format in order to send it on server */
    
    
    NSMutableArray *newItemInfoArray = [[NSMutableArray alloc] init];

    for (long count=[itemListArray count]; count<[name count]; count++)
    {
        if ([[name objectAtIndex:count] length]>0)
        {
            
            NSMutableDictionary *newItemInfoDictionary = [[NSMutableDictionary alloc] init];

            [newItemInfoDictionary setObject:[name objectAtIndex:count] forKey:@"item_title"];
            [newItemInfoDictionary setObject:[unit objectAtIndex:count] forKey:@"qty"];
            [newItemInfoDictionary setObject:[unitCost objectAtIndex:count] forKey:@"unit_price"];
            [newItemInfoDictionary setObject:[cost objectAtIndex:count] forKey:@"line_total"];
            
            [newItemInfoArray addObject:newItemInfoDictionary];

        }
    }
    
    
    /* Web servce call in order to send all required/ or new record info on server */

    
    
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
            [dict setValue:@"updateAgreementDetails"forKey:@"action"];
            [dict setValue:strOrderId forKey:@"orderId"];
    
            if ([newItemInfoArray count]>=1)
            {
                [dict setValue:newItemInfoArray forKey:@"updateitems"];
                [dict setValue:[NSString stringWithFormat:@"%0.2f", subTotalValue] forKey:@"net_total"];
                [dict setValue:[NSString stringWithFormat:@"%0.2f", subTotalValue] forKey:@"total_amount"];
                [dict setValue:@"0.00" forKey:@"total_tax"];

            }
    
    
    
    /* check for credit card info send process on server if and only if credit card number is changed by user */


    if (![[listArray valueForKey:@"credit_card_number"]isEqualToString:credeitCardNumberTextField.text])
    {
        [dict setValue:credeitCardNameTextField.text forKey:@"name"];
        [dict setValue:credeitCardNumberTextField.text forKey:@"card_number"];
        [dict setValue:credeitCardExpireYearTextField.text forKey:@"year"];
        [dict setValue:credeitCardCVVTextField.text forKey:@"cvv_number"];
        [dict setValue:[NSString stringWithFormat:@"%d",[credeitCardExpireMonTextField.text intValue]] forKey:@"month"];
 
    }

         NSLog(@"%@",dict);

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {

                     if ([[[response valueForKey:@"responseCode"]stringValue]isEqualToString:@"200"])
                     {
                        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Data saved successfully." onController:self];
                     }
                 }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];

             }];
}

-(void)callAPIForApprovedEquipment:(NSString *)action
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:action forKey:@"action"];
    [dict setValue:self.strParentID forKey:@"parent_order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response)
    {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                NSDictionary*dict;
                dict = [response valueForKey:@"order_invoice"];
                listArray= [response valueForKey:@"responseData"];
                itemListArray= [dict  valueForKey:@"items"];

                for (int count=0; count<[itemListArray count]; count++)
                {
                    [name addObject:[[itemListArray objectAtIndex:count]valueForKey:@"item_title"]];
                    [unitCost addObject:[[itemListArray objectAtIndex:count]valueForKey:@"unit_price"]];
                    [unit addObject:[[itemListArray objectAtIndex:count]valueForKey:@"units"]];
                    [cost addObject:[[itemListArray objectAtIndex:count]valueForKey:@"cost"]];

                    [arrayIndicator addObject:@"0"];
                }
                
                customerJoiningDateLabel.text =[NSString stringWithFormat:@"Customer Since %@",[dict objectForKeyNotNull:@"customer_since" expectedClass:[NSString class]]];
               
                nameLabel.text=[dict objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]];

                _lblEquipment.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"equipment" expectedClass:[NSString class]]];
                _lblInstallationKits.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"install_kit" expectedClass:[NSString class]]];
                _lblLabour.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"labor" expectedClass:[NSString class]]];
                _lblDueInstallation.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"due_at_installation" expectedClass:[NSString class]]];
                _lblPaidAmount.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"amount_paid" expectedClass:[NSString class]]];
                _lblDueToday.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"due_today" expectedClass:[NSString class]]];
                taxTotal.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"taxes" expectedClass:[NSString class]]];
                
                if ([[dict objectForKeyNotNull:@"permit_fee" expectedClass:[NSString class]] length]) {
                    permitFeeLabel.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"permit_fee" expectedClass:[NSString class]]];
                }else {
                
                permitFeeLabel.text=[NSString stringWithFormat:@"$0.00"];
                }
                subTotalLabel.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"total" expectedClass:[NSString class]]];
                addressLabel.text = [dict objectForKeyNotNull:@"customer_address" expectedClass:[NSString class]];
                
                _lblCustomerSavingValue.text = [dict objectForKeyNotNull:@"average_saving" expectedClass:[NSString class]];
                
                if ([[dict objectForKeyNotNull:@"average_saving" expectedClass:[NSString class]] length]) {
                    _lblCustomerSavingValue.text = [dict objectForKeyNotNull:@"average_saving" expectedClass:[NSString class]];
                }else {
                    
                    _lblCustomerSavingValue.text =[NSString stringWithFormat:@"$0.00"];
                }

                [productTableView reloadData];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
        {
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];
}

-(void)callAPIForApprovedLabour:(NSString *)action
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:action forKey:@"action"];
    
    if (self.isViewFromRepairFinalBill) {
        [dict setValue:@"2" forKey:@"view"];
    }else
        [dict setValue:(self.isViewFromInstallFinalBill)?@"1":@"" forKey:@"view"];
    
    [dict setValue:self.strParentID forKey:@"order_id"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                NSDictionary*dict;
                dict = [response valueForKey:@"laborData"];
                listArray= [response valueForKey:@"responseData"];
                itemListArray= [dict  valueForKey:@"items"];
                
                for (int count=0; count<[itemListArray count]; count++)
                {
                    [name addObject:[[itemListArray objectAtIndex:count]valueForKey:@"item_title"]];
                    [unitCost addObject:[[itemListArray objectAtIndex:count]valueForKey:@"unit_price"]];
                    [unit addObject:[[itemListArray objectAtIndex:count]valueForKey:@"qty"]];
                    [cost addObject:[[itemListArray objectAtIndex:count]valueForKey:@"cost"]];

                    [arrayIndicator addObject:@"0"];
                }
                customerJoiningDateLabel.text =[NSString stringWithFormat:@"Customer Since %@",[dict objectForKeyNotNull:@"customer_since" expectedClass:[NSString class]]];

                addressLabel.text=[dict objectForKeyNotNull:@"customer_address" expectedClass:[NSString class]];

                nameLabel.text=[dict objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]];
                _lblSubtotal.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"subtotal" expectedClass:[NSString class]]];
                _lblTax.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"tax" expectedClass:[NSString class]]];
                _lbltotal.text=[NSString stringWithFormat:@"$%@",[dict objectForKeyNotNull:@"total" expectedClass:[NSString class]]];
                _lblStaticText.text = [dict objectForKeyNotNull:@"desc" expectedClass:[NSString class]];
                  addressLabel.text = [dict objectForKeyNotNull:@"customer_address" expectedClass:[NSString class]];
                
                
                [productTableView reloadData];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
        {
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];
}


-(void)callAPIForConfirmApprovedEquipment{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"moveOrderFromPreInsp" forKey:@"action"];
    [dict setValue:self.strParentID forKey:@"parent_order_id"];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate callTechCheckApi];
                }];
//                [self.view removeFromSuperview];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
        {
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];
}

-(void)callAPIForConfirmApprovedLabour{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"approveLaborStep" forKey:@"action"];
    [dict setValue:self.strParentID forKey:@"order_id"];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate callTechCheckApi];
                }];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
        {
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];
    
}

-(void)callAPIForPaymentFinalBill{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"processFinalPaymentInstall" forKey:@"action"];
    [dict setValue:self.strParentID forKey:@"order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Communication sent." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    if(index == 0)
                    {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self.delegate callTechCheckApi];
                        }];
                    }
                }];
            }
            else
            {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
        {
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];
    
}


@end
