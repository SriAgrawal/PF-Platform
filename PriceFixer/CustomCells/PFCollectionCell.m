//
//  PFCollectionCell.m
//  PriceFixer
//
//  Created by Anil Kumar on 27/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFCollectionCell.h"

@implementation PFCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _cellCountLabel.layer.cornerRadius = 2.5f;
    _cellCountLabel.layer.masksToBounds = YES;
}

@end
