//
//  PFOrderInvoiceVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 08/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFOrderInvoiceVC.h"

static NSString * cellIdentifier = @"PFInvoiceCell";


@interface PFOrderInvoiceVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *orderInvoiceDataSourceArray;
}


@property (strong, nonatomic) IBOutlet UILabel *lblCustomer;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UITextView *txtViewTerms;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTax;
@property (strong, nonatomic) IBOutlet UILabel *lblShipping;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblDueInstallation;
@property (strong, nonatomic) IBOutlet UILabel *lblPaidAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblDueToday;

@property (strong, nonatomic) IBOutlet UITableView *tblViewOrder;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@end

@implementation PFOrderInvoiceVC

#pragma mark - View controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderInvoiceDataSourceArray = [[NSMutableArray alloc] init];
    
    [self.tblViewOrder registerNib:[UINib nibWithNibName:@"PFInvoiceCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tblViewOrder setTableFooterView:self.viewFooter];
    
    [self callGetAgreementServiceIntegration];
}
#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderInvoiceDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFInvoiceCell * cell = (PFInvoiceCell *)[self.tblViewOrder dequeueReusableCellWithIdentifier:cellIdentifier];
    PFOrderInvoiceModel *obj = [orderInvoiceDataSourceArray objectAtIndex:indexPath.row];
    cell.lblOrderName.text = obj.strItem_title;
    cell.lblUnitCost.text = [NSString stringWithFormat:@"$%@",obj.strUnit_price];
    cell.lblUnit.text = obj.strQty;
    cell.lblCost.text = [NSString stringWithFormat:@"$%@",obj.strLine_total];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cellAvail forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cellAvail respondsToSelector:@selector(setLayoutMargins:)]) {
        [cellAvail setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark -

#pragma mark - IBActions
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (IBAction)agreeContractBtnAction:(UIButton *)sender {
    
    [self callAgreeContractServiceIntegration];
}
#pragma mark -

#pragma mark - Service helper method
-(void)callAgreeContractServiceIntegration {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"agreeContract"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"orderId"];
    [dict setValue:self.strAppoinmentId forKey:@"apptmentId"];

    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            
            [[AlertView sharedManager] presentAlertWithTitle:@"Information" message:@"Agreement updated successfully." andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                if(index == 0){
                   
                    [self dismissViewControllerAnimated:NO completion:^{
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"refershPreInspectionList" object:nil];
                    }];
                }
            }];

          
        }
    }];
}


-(void)callGetAgreementServiceIntegration {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"viewContractDetails"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"orderId"];
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
            [orderInvoiceDataSourceArray removeAllObjects];
            NSDictionary *responceDict = [result objectForKeyNotNull:@"responseData" expectedClass:[NSDictionary class]];
            
            self.lblName.text = [NSString stringWithFormat:@"%@ %@",[responceDict objectForKeyNotNull:@"customer_first_name" expectedClass:[NSString class]],[responceDict objectForKeyNotNull:@"customer_last_name" expectedClass:[NSString class]]];
            
            self.lblAddress.text = [NSString stringWithFormat:@"%@ %@, %@ %@",[responceDict objectForKeyNotNull:@"billing_address1" expectedClass:[NSString class]],[responceDict objectForKeyNotNull:@"billing_city" expectedClass:[NSString class]],[responceDict objectForKeyNotNull:@"billing_state" expectedClass:[NSString class]],[responceDict objectForKeyNotNull:@"billing_zip" expectedClass:[NSString class]]];
            
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyyMMdd";
            NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[[responceDict objectForKeyNotNull:@"customer_since" expectedClass:[NSString class]] doubleValue]];
            dateFormatter.dateFormat=@"MMMM";
            NSString *monthString = [[dateFormatter stringFromDate:date1] capitalizedString];
            dateFormatter.dateFormat=@"yyyy";
            NSString *yearString = [[dateFormatter stringFromDate:date1] capitalizedString];
            self.lblCustomer.text=[@"Customer Since " stringByAppendingString:[[monthString stringByAppendingString:@" "]stringByAppendingString:yearString]];
            
            
            self.txtViewTerms.editable=NO;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[[responceDict objectForKeyNotNull:@"agreement_text" expectedClass:[NSString class]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:14.0]
                                     range:NSMakeRange(0, attributedString.length)];
            self.txtViewTerms.attributedText = attributedString;
            
            self.lblSubTotal.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"total_amount" expectedClass:[NSString class]] floatValue]];
            self.lblTax.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"total_tax" expectedClass:[NSString class]] floatValue]];
            self.lblShipping.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"shipping_charges" expectedClass:[NSString class]] floatValue]];
            self.lblTotal.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"net_total" expectedClass:[NSString class]] floatValue]];
            self.lblDueInstallation.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"due_at_install" expectedClass:[NSString class]] floatValue]];
            self.lblPaidAmount.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"paid_amount" expectedClass:[NSString class]] floatValue]];
            self.lblDueToday.text = [NSString stringWithFormat:@"$%0.2f",[[responceDict objectForKeyNotNull:@"due_today" expectedClass:[NSString class]] floatValue]];
            
            
            
            NSArray *orderInvoiceListArray = [responceDict objectForKeyNotNull:@"items" expectedClass:[NSArray class]] ;
            for (NSMutableDictionary *orderinvoiceDict in orderInvoiceListArray) {
                PFOrderInvoiceModel *orderInvoiceInfo = [PFOrderInvoiceModel modelOrderInvoiceListDict:orderinvoiceDict];
                [orderInvoiceDataSourceArray addObject:orderInvoiceInfo];
            }
            [self.tblViewOrder reloadData];
        }
    }];
}
#pragma mark -

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

@end
