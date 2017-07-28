//
//  PFClientTableViewCell.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 10/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFClientTableViewCell.h"

@implementation PFClientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.editButton.layer.cornerRadius = self.editButton.frame.size.width/2;
    self.editButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
