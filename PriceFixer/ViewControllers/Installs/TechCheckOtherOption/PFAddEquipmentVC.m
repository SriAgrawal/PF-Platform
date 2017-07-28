//
//  PFAddEquipmentVC.m
//  PriceFixer
//
//  Created by Tejas Pareek on 02/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFAddEquipmentVC.h"
#import "Macro.h"
#import "PFAddEquipmentTVC.h"
#import "PFAddCustomEquipmentTVC.h"
#import "PFInstallModel.h"
#import "TextField.h"
@interface PFAddEquipmentVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIScrollViewDelegate>{

    __weak IBOutlet UILabel *lblTitle;
    UITableView *titleListTableView;
    PFAddEquipmentModel *modelObject;
    NSMutableArray *customerArray;
    NSString *newProductText;
    NSString *orderId;

}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *btnProductOrCustom;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeightConstraint;
@end

@implementation PFAddEquipmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    customerArray = [NSMutableArray new];
    modelObject = [PFAddEquipmentModel new];
    modelObject.strQty = @"1";
    _mainView.frame = CGRectMake(105, 16, _mainView.frame.size.width, 470);
    _mainView.layer.cornerRadius = 5;
    
    // Set Table View
    titleListTableView=[[UITableView alloc]initWithFrame:CGRectMake(16,90, _tblView.frame.size.width-50, 150) style:UITableViewStylePlain];
    titleListTableView.borderColor = [UIColor lightGrayColor];
    titleListTableView.dataSource=self;
    titleListTableView.delegate=self;
    [self.tblView addSubview:titleListTableView];

    titleListTableView.layer.cornerRadius = 6;
    titleListTableView.layer.masksToBounds = YES;
    titleListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    titleListTableView.hidden=YES;
    

    [self.tblView registerNib:[UINib nibWithNibName:@"PFAddEquipmentTVC" bundle:nil] forCellReuseIdentifier:@"PFAddEquipmentTVC"];
    [self.tblView registerNib:[UINib nibWithNibName:@"PFAddCustomEquipmentTVC" bundle:nil] forCellReuseIdentifier:@"PFAddCustomEquipmentTVC"];
    _tblView.tableFooterView = _footerView;
    self.btnProductOrCustom.layer.cornerRadius = 10;
    _btnSave.layer.cornerRadius = 10;
    
    if (self.fromAddPart) {
        
        self.btnProductOrCustom.selected = YES;
        self.btnProductOrCustom.hidden = YES;
        lblTitle.text = @"Change Installation Hours";
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tblView]){
        return self.btnProductOrCustom.selected ? 3:2;

    }else{
        return customerArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tblView]) {
        
        PFAddEquipmentTVC *cell = (PFAddEquipmentTVC *)[self.tblView dequeueReusableCellWithIdentifier:@"PFAddEquipmentTVC"];
        PFAddCustomEquipmentTVC *cellCustomView = (PFAddCustomEquipmentTVC *)[self.tblView dequeueReusableCellWithIdentifier:@"PFAddCustomEquipmentTVC"];
        
        cell.lblTitle.hidden = NO;
        
        cell.viewForTextField.layer.cornerRadius = 10;
        cell.btnForDown.hidden = YES;
        cell.btnforUp.hidden = YES;
        cell.viewLeftConstraint.constant = 28;
        cell.viewTopConstraint.constant = 42.0;
        cell.viewLeftSideConstraint.constant = 12.0;
        cell.lblTitle.textAlignment = NSTextAlignmentLeft;

        if (!self.btnProductOrCustom.selected) {
            
            self.mainViewHeightConstraint.constant = 370.0;
            cell.txtView.tag = indexPath.row+300;
            cell.txtView.delegate = self;
            switch (indexPath.row) {
                case 0:
                {
                    cell.lblTitle.hidden = YES;
                    cell.txtView.placeholder = @"New Product";
                    cell.txtView.text = newProductText;
                    cell.viewTopConstraint.constant = 22;
                    cell.textFieldTopConstraint.constant = 25;
                    
                }
                    break;
                case 1:
                {
                    cell.lblTitle.text      = @"Qty";
                    cell.txtView.text  = modelObject.strQty;
                    cell.btnForDown.hidden = NO;
                    cell.btnforUp.hidden = NO;
                    cell.viewLeftConstraint.constant = 650;
                    cell.lblTitle.textAlignment = NSTextAlignmentCenter;
                    cell.viewLeftSideConstraint.constant = 50.0;
                    cell.btnforUp.tag       = indexPath.row;
                    cell.btnForDown.tag     = indexPath.row;
                    [cell.btnforUp addTarget:self action:@selector(btnUpForQtyAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btnForDown addTarget:self action:@selector(btndownForQtyAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    return cell;
            }
        }
        else
        {
            cell.txtView.tag = indexPath.row + 100;
            cellCustomView.txtCost.tag = indexPath.row + 200;
            cellCustomView.txtQty.tag = indexPath.row + 500;
            cell.txtView.delegate = self;
            cellCustomView.txtCost.delegate = self;
            cellCustomView.txtQty.delegate = self;
            self.mainViewHeightConstraint.constant = 470.0;

            switch (indexPath.row) {
                case 0:
                {
                    
                    cell.lblTitle.text = @"Title";
                    cell.txtView.placeholder = @"";
                    cell.txtView.text = modelObject.strTitle;
                    
                }
                    return cell;
                    break;
                case 1:
                {
                    cell.lblTitle.text = @"Description";
                    cell.txtView.text = modelObject.strDescription;
                    
                }
                    return cell;
                    break;
                case 2:
                {
                    cellCustomView.btnUpForCost.tag     = indexPath.row;
                    cellCustomView.btnDownForCost.tag   = indexPath.row;
                    cellCustomView.btnUpForQty.tag      = indexPath.row;
                    cellCustomView.btndownForQty.tag    = indexPath.row;
                    [cellCustomView.txtCost setText:modelObject.strCost];
                    [cellCustomView.txtQty setText:modelObject.strQty];
                    
                    [cellCustomView.btnUpForCost addTarget:self action:@selector(btnUpForCostAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cellCustomView.btnDownForCost addTarget:self action:@selector(btnDownForCostAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cellCustomView.btnUpForQty addTarget:self action:@selector(btnUpForQtyAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cellCustomView.btndownForQty addTarget:self action:@selector(btndownForQtyAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                    return cellCustomView;
                    break;
                default:
                    break;
            }
        }
        return cell;
    }
    else
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
        
        PFAddEquipmentModel *modelTempObject = [customerArray objectAtIndex:indexPath.row];
        
        if ([modelTempObject.strTitleID isEqualToString:@"#"]) {
            cell.textLabel.textColor = KAppGreenColor;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",modelTempObject.strTitleLable];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",modelTempObject.strTitleLable,modelTempObject.strTitleHTML];
        }
        return cell;
       }
    return nil;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![tableView isEqual:self.tblView]){
    PFAddEquipmentModel *modelTempObject = [customerArray objectAtIndex:indexPath.row];
    if (![modelTempObject.strTitleID isEqualToString:@"#"]) {
        newProductText = [NSString stringWithFormat:@"%@",modelTempObject.strTitleLable];
        orderId = modelTempObject.strTitleID;
        titleListTableView.hidden = YES;
        [_tblView reloadData];
    }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self->titleListTableView])
        {
            return 30;
        }
    else
        {
            if (!self.btnProductOrCustom.selected && indexPath.row == 0) {
                return 80;
            }
            else
                return 90;
        }
}


// TABGESTURE
-(void)dismissTblView:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
    titleListTableView.hidden = YES;
}



#pragma mark -

#pragma mark - UITextField Delegate -

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (textField.tag == 202 && !stringIsValid)
        return NO;
    
    if (textField.tag == 300) {
        [self callAPIForProduct:str];
    }
    else if ((textField.tag == 202 || textField.tag == 502 || textField.tag == 301) && str.length > 10)
        return NO;
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;

    switch (textField.tag) {
        case 100:
        {
            [modelObject setStrTitle:TRIM_SPACE(textField.text)];
        }
            break;
        case 101:
        {
            [modelObject setStrDescription:TRIM_SPACE(textField.text)];
        }
            break;
        case 202:
        {
            [modelObject setStrCost:TRIM_SPACE(textField.text)];
        }
            break;

        case 502:
        {
            [modelObject setStrQty:TRIM_SPACE(textField.text)];
        }
            break;

        case 300:
        {
            [modelObject setStrNewProduct:TRIM_SPACE(textField.text)];
        }
            break;

        case 301:
        {
            [modelObject setStrQty:TRIM_SPACE(textField.text)];
        }
            break;

            default:
            break;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;

    if (textField.tag != 100) {
        titleListTableView.hidden = YES;
    }
}

-(BOOL)isFieldVerified{
    
    if (!self.btnProductOrCustom.selected) {
        if (!newProductText.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter product name." onController:self];
        }
        else if (!modelObject.strQty.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter quantity." onController:self];
        }
        else {
            return YES;
        }
    }else{
        if (!modelObject.strTitle.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter title." onController:self];
        }
        else if (!modelObject.strDescription.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter description." onController:self];
        }
        else if (!modelObject.strCost.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter cost." onController:self];
        }

        else if (!modelObject.strQty.length) {
            [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter qty." onController:self];
        }
        else {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UITouch Method


#pragma mark - * * * BUTTON ACTION * * *

-(IBAction)btnUpForCostAction:(id)sender{
    [self.view endEditing:YES];
    modelObject.strCost = [NSString stringWithFormat:@"%ld",[modelObject.strCost integerValue] + 1];
    [self.tblView reloadData];
    
    
}
-(IBAction)btnDownForCostAction:(id)sender{
    [self.view endEditing:YES];
    if ([modelObject.strCost integerValue] > 1) {
        modelObject.strCost = [NSString stringWithFormat:@"%ld",[modelObject.strCost integerValue] - 1];
        [self.tblView reloadData];
    }

}
-(IBAction)btnUpForQtyAction:(id)sender{
    [self.view endEditing:YES];
    modelObject.strQty = [NSString stringWithFormat:@"%ld",[modelObject.strQty integerValue] + 1];
    [self.tblView reloadData];
}
-(IBAction)btndownForQtyAction:(id)sender{
    [self.view endEditing:YES];
    if ([modelObject.strQty integerValue] > 1) {
        modelObject.strQty = [NSString stringWithFormat:@"%ld",[modelObject.strQty integerValue] - 1];
        [self.tblView reloadData];
    }
}


- (IBAction)btnCloseAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnProductOrCustomAction:(id)sender {
    [self.view endEditing:YES];
    titleListTableView.hidden = YES;
    modelObject.strQty = @"1";
    self.btnProductOrCustom.selected =! self.btnProductOrCustom.selected;
    _mainView.frame = self.btnProductOrCustom.selected ? CGRectMake(105, 16, _mainView.frame.size.width,380):CGRectMake(105, 16, _mainView.frame.size.width, 470);
    
    
    [self.tblView reloadData];
}
- (IBAction)btnSaveAction:(id)sender {
    
    [self.view endEditing:YES];
    if([self isFieldVerified])
    {
        if (!self.btnProductOrCustom.selected)
        {
            [self callAPIForAddEquipment:@"changeOrderLineItem"];
        }
        else
        {
            [self callAPIForAddEquipment:@"changeOrderLineItemCustom"];
        }
    }
}

#pragma mark - * * * SERVICE HELPER * * * 
-(void)callAPIForProduct:(NSString*)searchText{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setValue:@"productQuickLookup"forKey:@"action"];
    [dict setValue:searchText forKey:@"term"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [customerArray removeAllObjects];
                NSArray *customerList = [response objectForKeyNotNull:@"product" expectedClass:[NSArray class]];
                
                for (NSDictionary *tempDict in customerList) {
                    
                  PFAddEquipmentModel  *modelTempObject = [PFAddEquipmentModel modelProductListDict:tempDict];
                    [customerArray addObject:modelTempObject];
                }
                if (customerArray.count) {
                    titleListTableView.hidden=NO;
                    titleListTableView.dataSource = self;
                    titleListTableView.delegate = self;
                    [titleListTableView reloadData];
                }
            }
            else {
                [customerArray removeAllObjects];
                titleListTableView.hidden = YES;
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

-(void)callAPIForAddEquipment:(NSString *)action{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if ([action isEqualToString: @"changeOrderLineItem"]) {
        [dict setValue:action forKey:@"action"];
        [dict setValue:orderId forKey:@"product_id"];
        [dict setValue:self.modelInstall.strParentOrderId forKey:@"parent_order_id"];
        [dict setValue:modelObject.strQty forKey:@"qty"];
    }else{

        [dict setValue:action forKey:@"action"];
        
        if (self.fromAddPart)
            [dict setValue:self.modelInstall.strOrderId forKey:@"parent_order_id"];
        else
            [dict setValue:self.modelInstall.strParentOrderId forKey:@"parent_order_id"];
        
        [dict setValue:modelObject.strTitle forKey:@"title"];
        [dict setValue:modelObject.strQty forKey:@"qty"];
        [dict setValue:modelObject.strDescription forKey:@"description"];
        [dict setValue:modelObject.strCost forKey:@"price"];
    }
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate callTechCheckApi];
                }];
              }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
