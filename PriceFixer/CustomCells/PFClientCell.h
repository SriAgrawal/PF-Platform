//
//  PFClientCell.h
//  PriceFixer
//
//  Created by Ashish Kumar Gupta on 11/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFClientCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblClient;

@property (strong, nonatomic) IBOutlet UIButton *btnClient;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAppoinment;
@property (strong, nonatomic) IBOutlet UIButton *btnAggrement;
@property (strong, nonatomic) IBOutlet UIButton *btnCommunication;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;

@end
