//
//  PFAddSpecialHourTableViewCell.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 08/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFAddSpecialHourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UIButton *unitCostButton;
@property (weak, nonatomic) IBOutlet UITextField *hoursTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage;
@property (weak, nonatomic) IBOutlet UITextField *unitCostTextField;

@end
