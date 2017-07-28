//
//  PFAddSpecialHoursViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 08/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol specialHourProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface PFAddSpecialHoursViewController : UIViewController

@property (nonatomic,weak) id <specialHourProtocol> delegate;
@property (nonatomic,strong) NSString *orderId;

@end
