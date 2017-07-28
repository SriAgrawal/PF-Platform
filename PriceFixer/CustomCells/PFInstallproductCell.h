//
//  PFInstallproductCell.h
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@class TAIndexPathButton;
@interface PFInstallproductCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet TAIndexPathButton *productDetailBtn;

@end
