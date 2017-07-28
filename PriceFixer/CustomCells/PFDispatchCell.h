//
//  PFDispatchCell.h
//  PriceFixer
//
//  Created by Yogita Joshi on 27/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFDispatchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblAppoinment;
@property (strong, nonatomic) IBOutlet UILabel *lblClient;
@property (strong, nonatomic) IBOutlet UILabel *lblTask;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAppoinment;
@property (strong, nonatomic) IBOutlet UIButton *btnAggrement;
@property (strong, nonatomic) IBOutlet UIButton *btnCommunication;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnAppDate;
@property (weak, nonatomic) IBOutlet UILabel *orderCode;


@end
