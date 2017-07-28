//
//  PFProcessReturnsTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 24/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFProcessReturnsTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblProductTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnForCheckAndUnCheck;

@end
