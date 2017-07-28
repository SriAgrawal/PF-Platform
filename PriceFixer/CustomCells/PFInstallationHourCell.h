//
//  PFInstallationHourCell.h
//  PriceFixer
//
//  Created by Yogita Joshi on 10/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFInstallationHourCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblOrderName;
@property (strong, nonatomic) IBOutlet UITextField *txtQty;
@property (strong, nonatomic) IBOutlet UIButton *btnUp;
@property (strong, nonatomic) IBOutlet UIButton *btnDown;

@end
