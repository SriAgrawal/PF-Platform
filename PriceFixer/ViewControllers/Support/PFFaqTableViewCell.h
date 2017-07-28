//
//  PFFaqTableViewCell.h
//  PriceFixer
//
//  Created by Ankit Kumar Gupta on 19/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Macro.h"
@interface PFFaqTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *faqView;
@property (weak, nonatomic) IBOutlet UILabel *faqTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UILabel *faqDescriptionLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet UIButton  *dropDownBtn;

@end
