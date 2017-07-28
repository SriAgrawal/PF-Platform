//
//  PFClientCollectionCell.m
//  PriceFixer
//
//  Created by Ashish Kumar Gupta on 11/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFClientCollectionCell.h"

@implementation PFClientCollectionCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _cellCountLabel.layer.cornerRadius = 2.5f;
    _cellCountLabel.layer.masksToBounds = YES;
}

@end
