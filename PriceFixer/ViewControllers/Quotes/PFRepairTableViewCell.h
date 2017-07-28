//
//  PFRepairTableViewCell.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 20/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@interface PFRepairTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *repairTableView;

@property (weak, nonatomic) IBOutlet UIButton *installEditButton;
@property (weak, nonatomic) IBOutlet UIButton *clientEditButton;
@property (weak, nonatomic) IBOutlet UIButton *currentStatusEditButton;
@property (weak, nonatomic) IBOutlet UIButton *contractIdEditButton;
@property (weak, nonatomic) IBOutlet UIButton *communicationEditButton;

@property (weak, nonatomic) IBOutlet UIButton *editAppointMentButton;
@property (weak, nonatomic) IBOutlet PFButton *inRouteButton;
@property (weak, nonatomic) IBOutlet PFButton *arrivedbutton;
@property (weak, nonatomic) IBOutlet PFButton *completeButton;

@property (weak, nonatomic) IBOutlet UILabel *installationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientMobileNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderPlacedLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *inRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivedLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@property (strong, nonatomic) PFInstallModel *repairInfo;

@property (weak, nonatomic) IBOutlet UILabel *approvedLabel;
@property (weak, nonatomic) IBOutlet UIButton *appointmentButton;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLabel;
@property (weak, nonatomic) IBOutlet UIButton *inRouteTopButton;
@property (weak, nonatomic) IBOutlet UILabel *inRouteTopLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrivedTopButton;
@property (weak, nonatomic) IBOutlet UILabel *arrivedTopLabel;



@end
