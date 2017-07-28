//
//  PFChangeInstallationHourVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 09/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFChangeInstallationHourVC.h"
static NSString * cellIdentifier = @"PFInstallationHourCell";

@interface PFChangeInstallationHourVC ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate> {
    
    NSMutableArray *changeHoursArray;
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblViewInstallationHour;

@end

@implementation PFChangeInstallationHourVC

#pragma mark - View controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Alloc Array
    changeHoursArray = [NSMutableArray array];
    
    [self.tblViewInstallationHour registerNib:[UINib nibWithNibName:@"PFInstallationHourCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tblViewInstallationHour setTableFooterView:[UIView new]];
    
    [self callGetServiceIntegration];
    
}
#pragma mark -

#pragma mark - IBActions
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (IBAction)updateBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self callUpdateHoursServiceIntegration];
}

- (void)btnDecreaseQtyAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    NSIndexPath * indexPath = [self.tblViewInstallationHour indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.tblViewInstallationHour]];
    PFInstallModel *obj = [changeHoursArray objectAtIndex:indexPath.row];
    if ([obj.strQuantity floatValue] > 0) {
        obj.strQuantity = [NSString stringWithFormat:@"%.2f",[obj.strQuantity floatValue] - 1];
        [self.tblViewInstallationHour reloadData];
    }
    
}

- (void)btnIncreaseQtyAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    NSIndexPath * indexPath = [self.tblViewInstallationHour indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.tblViewInstallationHour]];
    PFInstallModel *obj = [changeHoursArray objectAtIndex:indexPath.row];

    NSLog(@"%ld",(long)indexPath.row);

    obj.strQuantity = [NSString stringWithFormat:@"%.2f",[obj.strQuantity floatValue] + 1];
    [self.tblViewInstallationHour reloadData];

}
#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                              toView:self.tblViewInstallationHour];
    NSIndexPath *tappedIP = [self.tblViewInstallationHour indexPathForRowAtPoint:buttonPosition];
    PFInstallModel *obj = [changeHoursArray objectAtIndex:tappedIP.row];
    obj.strQuantity = textField.text;
    [self.tblViewInstallationHour reloadData];

}


#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return changeHoursArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFInstallationHourCell * cell = (PFInstallationHourCell *)[self.tblViewInstallationHour dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PFInstallModel *obj = [changeHoursArray objectAtIndex:indexPath.row];
    
    [cell.lblOrderName setText:obj.strItemTitle];
    [cell.txtQty setText:obj.strQuantity];
    
    cell.txtQty.delegate = self;
    cell.txtQty.returnKeyType = UIReturnKeyDone;
    cell.txtQty.keyboardType = UIKeyboardTypeNumberPad;
    [cell.btnDown addTarget:self action:@selector(btnDecreaseQtyAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnUp addTarget:self action:@selector(btnIncreaseQtyAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73.f;
}
#pragma mark -


#pragma mark - Service helper method
-(void)callUpdateHoursServiceIntegration {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"changeOrderHour"forKey:@"action"];
    [dict setValue:self.installInfo.strOrderId forKey:@"orderId"];
    NSMutableArray *productArr = [[NSMutableArray alloc] init];

    for (PFInstallModel *obj in changeHoursArray) {
        NSMutableDictionary *productDict = [[NSMutableDictionary alloc] init];
        [productDict setValue:obj.strId forKey:@"id"];
        [productDict setValue:obj.strQuantity forKey:@"qty"];

        [productArr addObject:productDict];
    }
    [dict setValue:productArr forKey:@"prdArr"];

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


-(void)callGetServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"equipmentList"forKey:@"action"];
    [dict setValue:self.installInfo.strOrderId forKey:@"order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [changeHoursArray removeAllObjects];
                NSArray *installArray = [response objectForKeyNotNull:@"responseData" expectedClass:[NSArray class]];
                for (NSMutableDictionary *ichangeHourDict in installArray)
                {
                    PFInstallModel *installInfo = [PFInstallModel modelChangeHoursListDict:ichangeHourDict];
                    [changeHoursArray addObject:installInfo];
                }
                [_tblViewInstallationHour reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

@end
