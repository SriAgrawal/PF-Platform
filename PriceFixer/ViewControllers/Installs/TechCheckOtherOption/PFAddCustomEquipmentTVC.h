//
//  PFAddCustomEquipmentTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 02/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFAddCustomEquipmentTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnUpForCost;
@property (weak, nonatomic) IBOutlet UIButton *btnDownForCost;
@property (weak, nonatomic) IBOutlet UIButton *btnUpForQty;
@property (weak, nonatomic) IBOutlet UIButton *btndownForQty;
@property (weak, nonatomic) IBOutlet UITextField *txtCost;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;

@end
