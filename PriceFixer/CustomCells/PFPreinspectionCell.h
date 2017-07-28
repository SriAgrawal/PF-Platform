//
//  PFPreinspectionCell.h
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"



@interface PFPreinspectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblInspectionStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderId;

@property (strong, nonatomic) IBOutlet UIButton *btnClickPreInspection;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateAppoinment;

@property (strong, nonatomic) IBOutlet UICollectionView *productCollectionView;

@property (strong, nonatomic) IBOutlet UILabel *lblApointmentID;

@property (strong, nonatomic) IBOutlet UIView *viewSingleButton;
@property (strong, nonatomic) IBOutlet UIView *viewShowContrct;
@property (strong, nonatomic) IBOutlet UIButton *btnViewContract;
@property (strong, nonatomic) IBOutlet UIButton *btncancelAndRefund;
@property (strong, nonatomic) IBOutlet UIButton *btnCommunication;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnEditAppoinment;
@property (strong, nonatomic) IBOutlet UIButton *addNewProductBtn;

@end
