//
//  PFOrderDetailTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 17/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFOrderDetailTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblQuantityOfItems;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblitemsDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgOfItem;
@property (weak, nonatomic) IBOutlet UILabel *returnedLabel;

@end
