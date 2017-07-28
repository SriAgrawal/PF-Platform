//
//  PFEquipmentClaimViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 24/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol claimEquipmentProtocol <NSObject>

- (void)callTechCheckApi;

@end

@interface PFEquipmentClaimViewController : UIViewController

@property(nonatomic,strong) NSString *orderId;
@property (nonatomic,weak)id<claimEquipmentProtocol> delegate;

@end
