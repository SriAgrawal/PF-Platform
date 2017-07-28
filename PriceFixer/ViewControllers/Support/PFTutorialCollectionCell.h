//
//  PFTutorialCollectionCell.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFTutorialCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *vedioTumpNailImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTagLineLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UIButton *watchedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *clikedBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
