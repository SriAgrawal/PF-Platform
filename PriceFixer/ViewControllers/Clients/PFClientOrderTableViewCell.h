//
//  PFClientOrderTableViewCell.h
//  PriceFixer
//
//  Created by Tejas Pareek on 21/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFClientOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblOrderDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderType;
@property (weak, nonatomic) IBOutlet UIImageView *imgOrderImage;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnTracking;
@property (weak, nonatomic) IBOutlet UIButton *btnInvoice;
@property (weak, nonatomic) IBOutlet UIButton *btnCommuniction;
@property (weak, nonatomic) IBOutlet UIButton *btnOrderStatus;

@end
