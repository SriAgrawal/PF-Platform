//
//  PFInvoiceCell.h
//  PriceFixer
//
//  Created by Yogita Joshi on 08/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFInvoiceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblOrderName;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitCost;
@property (strong, nonatomic) IBOutlet UILabel *lblUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblCost;


@end
