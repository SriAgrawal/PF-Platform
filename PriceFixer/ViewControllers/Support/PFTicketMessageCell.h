//
//  PFTicketMessageCell.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 18/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFTicketMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *messageWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraints;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;

@end
