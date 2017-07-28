//
//  PFProcessReturnsVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 24/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol processReturnEquipmentProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface PFProcessReturnsVC : UIViewController
@property (strong , nonatomic) NSString *orderId;
@property (strong , nonatomic) NSString *orderCode;
@property (nonatomic,weak)id<processReturnEquipmentProtocol> delegate;

@end
