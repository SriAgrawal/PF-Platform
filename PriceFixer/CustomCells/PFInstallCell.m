//
//  PFInstallCell.m
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFInstallCell.h"

@implementation PFInstallCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Initialization code
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"PFInstallproductCell" bundle:nil] forCellWithReuseIdentifier:@"PFInstallproductCell"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
