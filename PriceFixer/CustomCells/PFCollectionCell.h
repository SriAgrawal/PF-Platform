//
//  PFCollectionCell.h
//  PriceFixer
//
//  Created by Anil Kumar on 27/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *cellCountButton;
@property (weak, nonatomic) IBOutlet UILabel *cellCountLabel;

@end
