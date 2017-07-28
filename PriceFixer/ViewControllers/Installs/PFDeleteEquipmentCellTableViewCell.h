//
//  PFDeleteEquipmentCellTableViewCell.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 03/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFDeleteEquipmentCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UITextField *unitTextField;
@property (weak, nonatomic) IBOutlet UILabel *equipmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *textFieldLabel;

@end
