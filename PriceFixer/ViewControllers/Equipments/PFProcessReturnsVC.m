//
//  PFProcessReturnsVC.m
//  PriceFixer
//
//  Created by Tejas Pareek on 24/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFProcessReturnsVC.h"
#import "PFEquipmentModelInfo.h"
#import "Macro.h"
@interface PFProcessReturnsVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *itemsArray;
    PFEquipmentModelInfo *processInfo;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblReturnAmount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblAmountInfo;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewheightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *returnAmountLabel;

@end

@implementation PFProcessReturnsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
    // Do any additional setup after loading the view from its nib.
}
-(void)initialSetup
{
    itemsArray = [NSMutableArray array];
    [_tblView registerNib:[UINib nibWithNibName:@"PFProcessReturnsTVC" bundle:nil] forCellReuseIdentifier:@"PFProcessReturnsTVC"];
    self.lblTitle.text = [NSString stringWithFormat:@"%@ Process Returns",self.orderCode];
    self.tblView.estimatedRowHeight = 65.0;
    
    // Alloc Model Class
    processInfo = [[PFEquipmentModelInfo alloc] init];
    self.lblAmountInfo.hidden = YES;
    
    [self callApiForItemsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - * * * TABLE VIEW DATASOURCE AND DELEGATE METHOD
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [itemsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFProcessReturnsTVC *cell = (PFProcessReturnsTVC *)[_tblView dequeueReusableCellWithIdentifier:@"PFProcessReturnsTVC"];
    PFEquipmentModelInfo *processTempInfo = [itemsArray objectAtIndex:indexPath.row];
    
    if (processTempInfo.isSelect)
        [cell.btnForCheckAndUnCheck setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    else
        [cell.btnForCheckAndUnCheck setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];

    
    cell.lblProductTitle.text = processTempInfo.strItem_title;
    cell.lblProductDesc.text = processTempInfo.strItem_desc;
    cell.btnForCheckAndUnCheck.tag = indexPath.row;
    [cell.btnForCheckAndUnCheck addTarget:self action:@selector(btnCheckUncheck:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - * * * BUTTON ACTION * * *
- (IBAction)btnCancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnUpdateAction:(id)sender {
    
    [self callApiForUpdate];
}

-(IBAction)btnCheckUncheck :(UIButton*)sender{

    PFEquipmentModelInfo *obj = [itemsArray objectAtIndex:sender.tag];
    
    self.lblAmountInfo.hidden = NO;
    obj.isSelect = !obj.isSelect;
    
    NSString *sub_total = [processInfo.strSubTotal stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *tax_total = @"0.0";

    if (![processInfo.strTotalTax isEqualToString:@""]) {
        tax_total = [processInfo.strTotalTax stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    NSString *shipping_charges = [processInfo.strShippingCharge stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *os_amount = [processInfo.strOsAmount stringByReplacingOccurrencesOfString:@"," withString:@""];

    double ship_total = 0;
    double line_total_return = 0;
    double tax_per = [tax_total doubleValue] / [sub_total doubleValue];
    double sh_per = ([shipping_charges doubleValue] / [sub_total doubleValue]);

    NSMutableArray *lineArray = [NSMutableArray array];
    NSMutableArray *qtyArray = [NSMutableArray array];

    for (PFEquipmentModelInfo *tempObj in itemsArray) {
        
        if (tempObj.isSelect) {
            [lineArray addObject:tempObj.strTotalLine];
            [qtyArray addObject:[NSString stringWithFormat:@"%ld",(long)tempObj.strQty]];
        }
    }
    
    for (int index = 0; index < qtyArray.count ; index++) {
        
        double lineTax = [[lineArray objectAtIndex:index] doubleValue]*tax_per;
        double linesh = [[qtyArray objectAtIndex:index] doubleValue]* sh_per;
        ship_total += [[qtyArray objectAtIndex:index]doubleValue] * [os_amount doubleValue];
        line_total_return += [[lineArray objectAtIndex:index] doubleValue] + (lineTax + linesh);

    }
    
    double total_returns = line_total_return - ship_total;
    double less_shipping = ship_total;
    
    self.lblReturnAmount.text = (total_returns == 0)?@"$0":[NSString stringWithFormat:@"$%.2f",total_returns];
    self.lblAmountInfo.text = (less_shipping == 0)?@"Less Shipping $0":[NSString stringWithFormat:@"Less Shipping $%.2f",less_shipping];

    
        
    [self.tblView reloadData];
}

#pragma mark - * * * SERVICE HELPER METHOD * * * 
-(void)callApiForItemsList{
    
    [self.view endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"processReturnDetail" forKey:@"action"];
    [dict setObject:_orderId forKey:@"order_id"];
    
    [[ServiceHelper_AF3 instance]makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response)
    {
        if (suceeded)
        {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200)
            {
                [itemsArray removeAllObjects];
                
                NSDictionary *tempDict = [response objectForKeyNotNull:@"responseData" expectedClass:[NSDictionary class]];

                NSArray *tempArray = [tempDict objectForKeyNotNull:@"item" expectedClass:[NSArray class]];
                
                for (NSDictionary *dict in tempArray) {
                    
                    [itemsArray addObject:[PFEquipmentModelInfo modelDeleteEquipmentListDict:dict]];
                }
                processInfo.strNetTotal = [tempDict objectForKeyNotNull:@"net_total" expectedClass:[NSString class]];
                processInfo.strReturnAmount = [tempDict objectForKeyNotNull:@"return_amount" expectedClass:[NSString class]];
                processInfo.strOsAmount = [tempDict objectForKeyNotNull:@"os_amount" expectedClass:[NSString class]];
                processInfo.strSubTotal = [tempDict objectForKeyNotNull:@"sub_total" expectedClass:[NSString class]];
                processInfo.strTotalTax = [tempDict objectForKeyNotNull:@"total_tax" expectedClass:[NSString class]];
                processInfo.strShippingCharge = [tempDict objectForKeyNotNull:@"shipping_charges" expectedClass:[NSString class]];

                self.lblTotalOrder.text = processInfo.strNetTotal;
                self.lblReturnAmount.text = processInfo.strReturnAmount;
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                [self.tblView reloadData];
                
            }
            else
            {
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];

}

-(void)callApiForUpdate{
    
    [self.view endEditing:YES];
    
    NSMutableArray *idsArray = [NSMutableArray array];
    
    for (PFEquipmentModelInfo *tempObj in itemsArray) {
        if (tempObj.isSelect)
            [idsArray addObject:tempObj.strId];
    }

    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"processReturns" forKey:@"action"];
    [dict setObject:_orderId forKey:@"order_id"];
    [dict setObject:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setObject:idsArray forKey:@"ids"];
    
    [[ServiceHelper_AF3 instance]makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response)
     {
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
             [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
     }];
}

#pragma mark - Selector Method

-(void)afterSomeTime {
    
    if (self.tblView.contentSize.height <= 257)
        self.tableViewHeightConstraint.constant = self.tblView.contentSize.height;
    
    self.viewheightConstraint.constant = self.tblView.contentSize.height + 320;
    self.orderTotalLabel.text = @"Order Total";
    self.returnAmountLabel.text = @"Returns Amount";
}


@end
