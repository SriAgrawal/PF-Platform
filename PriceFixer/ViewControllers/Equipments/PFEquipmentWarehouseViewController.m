//
//  PFEquipmentWarehouseViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 24/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFEquipmentWarehouseViewController.h"
#import "Macro.h"

@interface PFEquipmentWarehouseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *warehouseSeoLabel;
@property (weak, nonatomic) IBOutlet UILabel *warehouseRebateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wareHouseBenifitLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullfillEquipmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fulfillDeliveryFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fulfillSeoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fulfillRebateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fulfillTotalDepositeLabel;

@end

@implementation PFEquipmentWarehouseViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self callAPIToGetWarehouseData];
}


#pragma mark - Memory Mangement Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIButton Action
- (IBAction)fulfillButtonAction:(id)sender {
    
}

- (IBAction)acceptWarehouseButtonAction:(id)sender {
    
}

- (IBAction)dismissButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Service Helper Method
- (void)callAPIToGetWarehouseData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"claim" forKey:@"action"];
    [dict setValue:self.orderId forKey:@"order_id"];
    [dict setValue:@"0" forKey:@"is_own"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                NSDictionary *tempDict = [response objectForKeyNotNull:@"responseData" expectedClass:[NSDictionary class]];
                self.titleLabel.text = [tempDict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
                self.warehouseSeoLabel.text = [tempDict objectForKeyNotNull:@"seo1" expectedClass:[NSString class]];
                self.warehouseRebateLabel.text = [tempDict objectForKeyNotNull:@"rebate1" expectedClass:[NSString class]];
                self.wareHouseBenifitLabel.text = [tempDict objectForKeyNotNull:@"benefit" expectedClass:[NSString class]];
                self.fullfillEquipmentLabel.text = [tempDict objectForKeyNotNull:@"equipment" expectedClass:[NSString class]];
                self.fulfillDeliveryFeeLabel.text = [tempDict objectForKeyNotNull:@"delivery_fee" expectedClass:[NSString class]];
                self.fulfillSeoLabel.text = [tempDict objectForKeyNotNull:@"seo2" expectedClass:[NSString class]];
                self.fulfillRebateLabel.text = [tempDict objectForKeyNotNull:@"rebate2" expectedClass:[NSString class]];
                self.fulfillTotalDepositeLabel.text = [tempDict objectForKeyNotNull:@"total_deposit" expectedClass:[NSString class]];

            }
            else {
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


@end
