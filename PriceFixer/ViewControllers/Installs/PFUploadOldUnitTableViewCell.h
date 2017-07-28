//
//  PFUploadOldUnitTableViewCell.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 04/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFUploadOldUnitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgOld;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadOldImg;

@end
