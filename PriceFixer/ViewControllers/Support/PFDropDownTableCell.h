//
//  PFDropDownTableCell.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFDropDownTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLbl;
@property (weak, nonatomic) IBOutlet UIButton *clikedBtn;

@end
