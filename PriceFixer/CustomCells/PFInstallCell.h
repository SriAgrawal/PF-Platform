//
//  PFInstallCell.h
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface PFInstallCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblInspectionStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderId;
@property (strong, nonatomic) IBOutlet UILabel *lbldate;

@property (strong, nonatomic) IBOutlet UIButton *btnEditAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAppoinment;
@property (strong, nonatomic) IBOutlet UIButton *btnAggrement;
@property (strong, nonatomic) IBOutlet UIButton *btnCommunication;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;
@property (strong, nonatomic) IBOutlet UIButton *clickToInstall;


@property (strong, nonatomic) IBOutlet UIButton *communicationMidButton;

@property (strong, nonatomic) IBOutlet UICollectionView *productCollectionView;

@end
