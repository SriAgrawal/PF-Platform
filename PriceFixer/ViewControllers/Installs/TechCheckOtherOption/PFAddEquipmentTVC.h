//
//  PFAddEquipmentTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 02/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFAddEquipmentTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtView;
@property (weak, nonatomic) IBOutlet UIButton *btnforUp;
@property (weak, nonatomic) IBOutlet UIButton *btnForDown;
@property (weak, nonatomic) IBOutlet UIImageView *imgDropDown;
@property (weak, nonatomic) IBOutlet UIView *viewForTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeftSideConstraint;

@end
