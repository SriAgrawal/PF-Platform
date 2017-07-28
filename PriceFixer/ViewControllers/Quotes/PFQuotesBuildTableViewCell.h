//
//  PFQuotesBuildTableViewCell.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 18/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFQuotesBuildTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnRemoveItem;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UIButton *lblPerMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;

@property (weak, nonatomic) IBOutlet UIButton *btnForDecreaseQty;
@property (weak, nonatomic) IBOutlet UIButton *btnForIncreaseQty;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;


@end
