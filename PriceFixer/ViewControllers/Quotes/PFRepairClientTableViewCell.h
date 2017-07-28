//
//  PFRepairClientTableViewCell.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 20/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFRepairClientTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *repairImageView;
@property (weak, nonatomic) IBOutlet UILabel *anyRepairLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantitylabel;

@end
