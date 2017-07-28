//
//  PFResetPasswordCell.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFResetPasswordCell.h"

@implementation PFResetPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cellTextField.layer.cornerRadius =10.0f;
    _cellTextField.layer.masksToBounds = YES;
    _cellTextField.layer.borderColor = [UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1.0f].CGColor;
    [_cellTextField setLeftViewMode:UITextFieldViewModeAlways];
    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 16)];
    _cellTextField.leftView = tmp;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
