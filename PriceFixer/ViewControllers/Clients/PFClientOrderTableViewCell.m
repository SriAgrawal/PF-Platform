//
//  PFClientOrderTableViewCell.m
//  PriceFixer
//
//  Created by Tejas Pareek on 21/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFClientOrderTableViewCell.h"

@implementation PFClientOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnOrderStatus.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
