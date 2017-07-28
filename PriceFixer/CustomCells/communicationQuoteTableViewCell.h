//
//  communicationQuoteTableViewCell.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 27/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface communicationQuoteTableViewCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *messageLabel;
@property(nonatomic,retain)IBOutlet UILabel *dateNtimeLabel;
@property(nonatomic,retain)IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *viewChatLabel;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;
@property (weak, nonatomic) IBOutlet UIButton *clickToViewButton;

@end
