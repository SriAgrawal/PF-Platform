//
//  PFClientOrderViewController.h
//  PriceFixer
//
//  Created by Tejas Pareek on 21/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFClientModelInfo.h"

@protocol clientOrderProtocol <NSObject>

-(void)setViewHeight:(NSInteger)height;

@end

@interface PFClientOrderViewController : UIViewController
@property (nonatomic,strong) PFClientModelInfo *orderInfo;

@property (nonatomic,strong)id <clientOrderProtocol> delegate;

@end
