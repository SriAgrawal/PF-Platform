//
//  PFClientOrderViewController.m
//  PriceFixer
//
//  Created by Tejas Pareek on 21/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFClientOrderViewController.h"
#import "PFClientOrderTableViewCell.h"
#import "Macro.h"
#import "PFClientModelInfo.h"

@interface PFClientOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *orderDetailArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)btnArchieveOrderAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnArchiveOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;


@end

@implementation PFClientOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self callAPIForOrderDetails:1];
    [_tblView registerNib:[UINib nibWithNibName:@"PFClientOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"PFClientOrderTableViewCell"];
    orderDetailArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderDetailArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFClientOrderTableViewCell *cell = (PFClientOrderTableViewCell *)[self.tblView dequeueReusableCellWithIdentifier:NSStringFromClass([PFClientOrderTableViewCell class])];
    if (indexPath.row%2==0)
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
    }
    
    PFClientOrderModelInfo *modelObject = [orderDetailArray objectAtIndex:indexPath.row];
    [cell.imgOrderImage setImageWithURL:[NSURL URLWithString:modelObject.strImage]];
    [cell.lblOrderDate setText:modelObject.strDate];
    [cell.lblOrderPrice setText:[NSString stringWithFormat:@"$%@",modelObject.strPrice]];
    [cell.lblOrderType setText:modelObject.strOrder_type];
    
    if ([modelObject.strOrder_status isEqualToString:@"Pending"]) {
        [cell.btnOrderStatus setBackgroundColor:[UIColor colorWithRed:203/255.0f green:96/255.0f blue:84/255.0f alpha:1.0f]];
    }
    else if([modelObject.strOrder_status isEqualToString:@"Pre-Inspection Set"]){
        [cell.btnOrderStatus setBackgroundColor:[UIColor colorWithRed:235/255.0f green:175/255.0f blue:95/255.0f alpha:1.0f]];
    }
    else if([modelObject.strOrder_status isEqualToString:@"In Route"]){
        [cell.btnOrderStatus setBackgroundColor:[UIColor colorWithRed:68/255.0f green:122/255.0f blue:179/255.0f alpha:1.0f]];
    }
    else
    {
        [cell.btnOrderStatus setBackgroundColor:[UIColor colorWithRed:68/255.0f green:157/255.0f blue:68/255.0f alpha:1.0f]];
    }
    cell.btnInvoice.tag = indexPath.row;
    cell.btnTracking.tag = indexPath.row;
    cell.btnCommuniction.tag = indexPath.row;
    [cell.btnOrderStatus setTitle:[NSString stringWithFormat:@"  %@  ",modelObject.strOrder_status]forState:UIControlStateNormal];
    [cell.lblOrderDetail setText:[NSString stringWithFormat:@"Invoice #%@",modelObject.strOrder_code]];
    [cell.btnInvoice addTarget:self action:@selector(btnInvoice:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnTracking addTarget:self action:@selector(btnTracking:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCommuniction addTarget:self action:@selector(btnCommunicationAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - * * * BUTTON ACTION * * * 

- (IBAction)btnArchieveOrderAction:(id)sender {

    self.btnArchiveOrder.selected =! self.btnArchiveOrder.selected;
    self.btnArchiveOrder.selected ? [_btnArchiveOrder setTitle:@"View Active Orders" forState:UIControlStateNormal]:[_btnArchiveOrder setTitle:@"View Archieved Orders" forState:UIControlStateNormal];
    [self callAPIForOrderDetails:1];
}
-(IBAction)btnInvoice:(UIButton *)sender
{
      PFClientOrderModelInfo *modelObject = [orderDetailArray objectAtIndex:sender.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:modelObject.strInvoice_url]];
}
-(IBAction)btnTracking:(UIButton *)sender
{
    PFClientOrderModelInfo *modelObject = [orderDetailArray objectAtIndex:sender.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:modelObject.strTracking_url]];
}
- (void)btnCommunicationAction:(UIButton *)sender
{
    PFClientOrderModelInfo *obj = [orderDetailArray objectAtIndex:sender.tag];
    communicationQuoteViewController *objVC = [[communicationQuoteViewController alloc]initWithNibName:@"communicationQuoteViewController" bundle:nil];
    objVC.strOrderId = obj.strId;
    objVC.strEmployeId = @"0";
    objVC.fromOrder = YES;
    objVC.strOrderCode = obj.strOrder_code;
    objVC.providesPresentationContextTransitionStyle = YES;
    objVC.definesPresentationContext = YES;
    [objVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.navigationController presentViewController:objVC animated:NO completion:nil];
}

#pragma mark - * * * SERVICE HELPER * * *

-(void)callAPIForOrderDetails : (NSInteger) pageNumber{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"clientOrder"forKey:@"action"];
    [dict setValue:self.orderInfo.customer_id forKey:@"customer_id"];
    [dict setValue:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:self.btnArchiveOrder.selected]] forKey:@"status"];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
            [orderDetailArray removeAllObjects];
            NSArray *activeOrder = [response objectForKeyNotNull:@"active_order" expectedClass:[NSArray class]];

            for (NSDictionary *dict in activeOrder) {
                [orderDetailArray addObject:[PFClientOrderModelInfo modelOrderList:dict]];
            }
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
            [_tblView reloadData];
        }
            else {
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
            
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


#pragma mark -

#pragma mark - Selector Method

-(void)afterSomeTime {
    
    int tableHeight = self.tblView.contentSize.height;
    self.tableHeightConstraint.constant = tableHeight - 10;
    [self.delegate setViewHeight:tableHeight];

}

@end
