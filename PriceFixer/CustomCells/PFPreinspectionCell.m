//
//  PFPreinspectionCell.m
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFPreinspectionCell.h"

@implementation PFPreinspectionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [self.productCollectionView registerNib:[UINib nibWithNibName:@"PFProdeuctCell" bundle:nil] forCellWithReuseIdentifier:@"PFProdeuctCell"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
