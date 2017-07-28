//
//  PFQuotesStepsTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 22/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFQuotesStepsTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitleAndFigure;
@property (weak, nonatomic) IBOutlet UIButton *btnForTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnForText;


@property (weak, nonatomic) IBOutlet UIButton *btnPerMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoProductImageView;

@end
