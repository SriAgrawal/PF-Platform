//
//  PFBuildQuoteVC.m
//  PriceFixer
//
//  Created by Tejas Pareek on 10/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFBuildQuoteVC.h"
#import "PFUtility.h"
#import "Macro.h"
@interface PFBuildQuoteVC ()<UITableViewDelegate,UITableViewDataSource>{

    UserInfo *objModel;
    UITableView *findListTableView;
    NSMutableArray *findArray;

    NSString *distance;
    NSString *available;
    NSString *createdShopId;
    NSString *findString;


}
@property (weak, nonatomic) IBOutlet UITextField *txtCustomer;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblOR;
@property (weak, nonatomic) IBOutlet UIButton *btnBuildQuote;
@property (weak, nonatomic) IBOutlet UILabel *buildQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceAndInstallationLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnFind;
@property (weak, nonatomic) IBOutlet UITextField *txtFind;
@property (weak, nonatomic) IBOutlet UITextField *txtCallPrompted;



@property (weak, nonatomic) IBOutlet UIView *viewBuildPopUp;

@end

@implementation PFBuildQuoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark-  * * * HELPER METHOD * * *
-(void)initialSetup
{
    objModel = [UserInfo new];
    self.lblOR.layer.cornerRadius = self.lblOR.layer.frame.size.width / 2;
    self.lblOR.layer.masksToBounds = YES;
    self.btnBuildQuote.layer.cornerRadius = 20.0f;
    
    // Set Table View
    findListTableView=[[UITableView alloc]initWithFrame:CGRectMake(27, 450, 334, 200) style:UITableViewStylePlain];
    findListTableView.dataSource=self;
    findListTableView.delegate=self;
    [self.viewBuildPopUp addSubview:findListTableView];
    
    findListTableView.layer.cornerRadius = 6;
    findListTableView.layer.masksToBounds = YES;
    findListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    findListTableView.hidden=YES;
    findListTableView.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];

    // Alloc Array
    findArray = [[NSMutableArray alloc]initWithObjects:@"Google",@"Facebook",@"TV",@"Radio",@"Mail",@"Advertisement",@"Billboard",@"Vechicle",@"Friend",@"Other",nil ];


    [self callGetShopServiceIntegration];
}


#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return findArray.count;
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
    cell.textLabel.text = [findArray objectAtIndex:indexPath.row];
        
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        findListTableView.hidden=YES;
        [self.btnFind setSelected:NO];
    self.txtFind.text = [findArray objectAtIndex:indexPath.row];
}


#pragma mark -

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;

    switch (textField.tag) {
        case 100:
        {
            [objModel setStrCustomer:TRIM_SPACE(self.txtCustomer.text)];
        }
            break;
        case 101:
        {
            [objModel setStrFirstName:TRIM_SPACE(self.txtFirstName.text)];
        }
            break;
        case 102:
        {
            [objModel setStrLastName:TRIM_SPACE(self.txtLastName.text)];
        }
            break;
        case 103:
        {
            [objModel setStrEmail:TRIM_SPACE(self.txtEmail.text)];
        }
            break;
        case 104:
        {
            [objModel setStrPhoneNumber:TRIM_SPACE(self.txtPhone.text)];
        }
            break;
        case 105:
        {
            [objModel setStrFind:TRIM_SPACE(self.txtPhone.text)];
        }
            break;
        case 106:
        {
            [objModel setStrCallPrompted:TRIM_SPACE(self.txtPhone.text)];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length > 20 && (textField.tag == 101 || textField.tag == 102))
        return NO;
    else if (str.length > 60 && textField.tag == 103)
        return NO;
    else if (str.length > 60 && textField.tag == 105)
        return NO;
    else if (str.length > 60 && textField.tag == 106)
        return NO;

    else if (str.length > 14 && textField.tag == 104)
        return NO;
    //**************************
    
    else if (textField.tag == 104) {
        NSString *newString = [_txtPhone.text stringByReplacingCharactersInRange:range withString:string];
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
        
        return NO;
        
    }
    
    
    //***************************

    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;
    findListTableView.hidden=YES;
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


#pragma mark -

#pragma mark - UITouch Method

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    findListTableView.hidden = YES;
}


-(BOOL)istextFieldValidate{
    
    
    NSString *allZeroInMobile = [objModel.strPhoneNumber stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    if (!self.txtCustomer.text.length && (!objModel.strFirstName.length && !objModel.strLastName.length && !objModel.strEmail.length && !objModel.strPhoneNumber.length)) {
        
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select customer name or enter user details." onController:self];
    }
    else if (self.txtCustomer.text.length){
        return YES;
    }
    else if (!objModel.strFirstName.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter first name." onController:self];
    }
    else if (!objModel.strLastName.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter last name." onController:self];
    }
    else if (!objModel.strEmail.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter email." onController:self];
    }
    else if ([PFUtility validateEmailAddress:objModel.strEmail]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid email." onController:self];
    }
    else if (!objModel.strPhoneNumber.length) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter phone number." onController:self];
    }
    else if (objModel.strPhoneNumber.length < 14 || allZeroInMobile.length == 0){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter valid phone number." onController:self];
    }
    else
        return YES;
    
    return NO;
}


#pragma mark -

#pragma mark - UIButton Action Method

- (IBAction)btnBuildQuoteAction:(id)sender {
   
    [self.view endEditing:YES];
    if ([self istextFieldValidate]) {
        
        [self callBuildQuoteNewServiceIntegration];
    }
    
}

- (IBAction)findUsButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    CGRect rect = sender.frame;
    rect.origin.y = rect.origin.y+sender.frame.size.height;
    rect.size.height = 100;
    
    [findListTableView setFrame:rect];
    _btnFind.selected = !_btnFind.selected;
    if (_btnFind.selected) {
        [findListTableView setHidden:NO];
    }else{
        [findListTableView setHidden:YES];
    }
    
}


- (IBAction)canclePageButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark

#pragma mark - Service Helper Method
-(void)callGetShopServiceIntegration{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"getShopByZipCode"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:self.zipCode forKey:@"zipcode"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            distance = [response objectForKeyNotNull:@"shop_distance" expectedClass:[NSString class]];
            available = [response objectForKeyNotNull:@"installation" expectedClass:[NSString class]];
            createdShopId = [response objectForKeyNotNull:@"created_shop_id" expectedClass:[NSString class]];

            self.buildQuoteLabel.text = [NSString stringWithFormat:@"Build Quotes for %@",[response objectForKeyNotNull:@"shop_name" expectedClass:[NSString class]]];
            self.distanceAndInstallationLabel.text = [NSString stringWithFormat:@"%@ miles away | %@ | %@ Miles",[response objectForKeyNotNull:@"shop_distance" expectedClass:[NSString class]],([[response objectForKeyNotNull:@"installation" expectedClass:[NSString class]] boolValue])?@"Installation Available":@"Installation Not-Available",[response objectForKeyNotNull:@"installation_distance" expectedClass:[NSString class]]];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        
    }];
}


-(void)callCustomerNameServiceIntegration:(NSString*)searchText{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"searchCustomer"forKey:@"action"];
    [dict setValue:searchText forKey:@"keyword"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:@"1" forKey:@"status"];
    [dict setValue:@"1" forKey:@"pageNumber"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {

            NSArray *customerList = [response objectForKeyNotNull:@"customerData" expectedClass:[NSArray class]];

            for (NSDictionary *tempDict in customerList) {
                
                objModel = [UserInfo modelCustomerListDict:tempDict];
            }
            findListTableView.hidden=NO;
            [findListTableView reloadData];
        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callBuildQuoteNewServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"sendQuote"forKey:@"action"];
    [dict setValue:self.txtFirstName.text forKey:kFirst_name];
    [dict setValue:@"0" forKey:kCustomer_id];
    [dict setValue:self.txtLastName.text forKey:kLast_name];
    [dict setValue:self.txtEmail.text forKey:kEmail];
    [dict setValue:self.txtPhone.text forKey:kPhone];
    [dict setValue:self.zipCode forKey:kZip_code];
    [dict setValue:distance forKey:kDistance];
    [dict setValue:([available boolValue])?@"1":@"0" forKey:kIs_install];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kUserId]  forKey:kShop_userId];
    [dict setValue:createdShopId forKey:kCreated_shop_id];
    [dict setValue:[NSUSERDEFAULTS valueForKey:kShop_id] forKey:kShop_id];
    
    [dict setValue:self.txtFind.text forKey:kHow_find];
    [dict setValue:self.txtCallPrompted.text forKey:kPrompted];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    //*********
                    if (self && self.delegate && [self.delegate respondsToSelector:@selector(dismissControllerWith:)]) {
                        [self.delegate dismissControllerWith:[response objectForKey:@"quoteId"]];
                    }
                    
                    //**********
                    
                }];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
        {
            NSLog(@"\n\n\n\n\n\n\n\n\n\n\n\n%@\n\n\n\n\n\n", error);
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];
}

@end
