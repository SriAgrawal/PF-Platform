//
//  PFInstallsMainTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 16/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFOrderDetailTVC.h"


@protocol orderDelegate <NSObject>

@optional
-(void)presentProductDetail:(NSString *)productId;
-(void)buttonClick:(NSInteger)index btnTitle:(NSString *)title;
@end

@interface PFInstallsMainTVC : UITableViewCell

@property (assign, nonatomic) id <orderDelegate> delegate;

@property (strong, nonatomic) NSArray *orderArray;
@property (strong, nonatomic) NSArray *buttonArray;

@property (strong, nonatomic) NSString *strTechOrderId;

@property (strong, nonatomic) UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTVHeightConstraint;


@property (weak, nonatomic) IBOutlet UIView *viewForCustomerDetails;
@property (weak, nonatomic) IBOutlet UIView *viewForOrderDetails;
@property (weak, nonatomic) IBOutlet UIView *viewForTime;
@property (weak, nonatomic) IBOutlet UIButton *btnOrderPlased;
@property (weak, nonatomic) IBOutlet UIButton *btnApproved;
@property (weak, nonatomic) IBOutlet UIButton *btnInstallDate;
@property (weak, nonatomic) IBOutlet UIButton *btnInRoute;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnWalkThrough;

@property (weak, nonatomic) IBOutlet UILabel *lblApproved;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallDate;
@property (weak, nonatomic) IBOutlet UILabel *lblInRoute;
@property (weak, nonatomic) IBOutlet UILabel *lblComplete;
@property (weak, nonatomic) IBOutlet UILabel *lblWalkThrough;

//**********
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPlacedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblApprovedSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallDateThird;
@property (weak, nonatomic) IBOutlet UILabel *lblInRouteFourth;
@property (weak, nonatomic) IBOutlet UILabel *lblCompleteFifth;
@property (weak, nonatomic) IBOutlet UILabel *lblWalkThroughSixth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walkThroughRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appointmentLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxesTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customerViewheightConstraint;

@property (assign, nonatomic) BOOL fromInstall;

@property (weak, nonatomic) IBOutlet UILabel *installCustomerLabel;
@property (weak, nonatomic) IBOutlet UILabel *labourCustomerLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentClientLabel;

//@property (weak, nonatomic) IBOutlet UIView *tblFooterViewForTV;

// * * * FIRST VIEW OUTLET * * *
@property (weak, nonatomic) IBOutlet UILabel *lblNameFV;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumberFV;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressFV;
@property (weak, nonatomic) IBOutlet UILabel *lblEquipmentFV;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallationFV;
@property (weak, nonatomic) IBOutlet UILabel *lblLabourFV;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxesFV;
@property (weak, nonatomic) IBOutlet UILabel *lblPermitFeeFV;
@property (weak, nonatomic) IBOutlet UILabel *lblPermitFeeF;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalFV;
@property (weak, nonatomic) IBOutlet UIButton *btnEditFV;

// * * * SECOND VIEW OUTLET * * *
@property (weak, nonatomic) IBOutlet UILabel *lblOrderIdSV;
@property (weak, nonatomic) IBOutlet UILabel *lblInstallationNoSV;
@property (weak, nonatomic) IBOutlet UITableView *tblViewSV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantHightSV;
@property (weak, nonatomic) IBOutlet UIView *equipmentTopView;

// * * * THIRD VIEW OUTLET * * *
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantHeightTV;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTV;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailTV;
@property (weak, nonatomic) IBOutlet UITableView *tblViewTV;

@property (weak, nonatomic) IBOutlet UILabel *installationStaticLabel;


// Equipment Section

@property (weak, nonatomic) IBOutlet UILabel *orderProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullfilmentProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *setdeliverProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryProgressLabel;

@property (weak, nonatomic) IBOutlet UILabel *equipmentOrderPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentFullfilmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentSetDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *equipmentReturnLabel;

@property (weak, nonatomic) IBOutlet UIButton *fullfillmentButton;
@property (weak, nonatomic) IBOutlet UIButton *setDeliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *deliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@property (weak, nonatomic) IBOutlet UILabel *moreItemlabel;



@end
