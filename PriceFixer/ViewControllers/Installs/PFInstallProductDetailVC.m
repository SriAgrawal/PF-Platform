//
//  PFInstallProductDetailVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 11/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFInstallProductDetailVC.h"
static NSString * cellIdentifier = @"PFInstallProductDetailCell";

@interface PFInstallProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *resultArray;
    NSDictionary *productListDict;
}

@property (strong, nonatomic) IBOutlet UITableView *productDetailTableView;

@end

@implementation PFInstallProductDetailVC

#pragma mark - View controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.productDetailTableView registerNib:[UINib nibWithNibName:@"PFInstallProductDetailCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.productDetailTableView setTableFooterView:[UIView new]];
    
    [self callgetInstallProductServiceIntegration];

}
#pragma mark -

#pragma mark - IBActions
- (IBAction)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
#pragma mark -

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFInstallProductDetailCell * cell = (PFInstallProductDetailCell *)[self.productDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *strKey = [resultArray objectAtIndex:indexPath.row];
    [cell.lblKey setText:strKey];
    [cell.lblValue setText:[productListDict objectForKey:strKey]];

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
    return 50.f;
}
#pragma mark -


#pragma mark - Service Helper Method
-(void)callgetInstallProductServiceIntegration {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"productDetail"forKey:@"action"];
    [dict setValue:self.strProductID forKey:@"productId"];
    
    [[BDServiceHelper sharedInstance] PostAPICallWithParameter:dict AndAPIName:@"" withprogresHud:BDProgressShown WithComptionBlock:^(id result, NSError *error) {
        if (!error) {
           productListDict = [result objectForKeyNotNull:@"responseMessage" expectedClass:[NSDictionary class]];
            NSMutableSet *set1 = [NSMutableSet setWithArray: [productListDict allKeys]];
            NSSet *set2 = [NSSet setWithArray: [productListDict allKeys]];
            [set1 intersectSet: set2];
            resultArray = [NSMutableArray array];
            [[productListDict allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[set1 allObjects] containsObject:obj]) {
                    [resultArray addObject:obj];
                }
            }];

            [self.productDetailTableView reloadData];
        }
    }];
}

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

@end
