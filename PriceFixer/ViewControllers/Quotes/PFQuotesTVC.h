//
//  PFQuotesTVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 17/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFQuotesTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblId;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblQuotes;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblRegisteredUser;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;
@property (weak, nonatomic) IBOutlet UIButton *btnResentEmail;

@end
