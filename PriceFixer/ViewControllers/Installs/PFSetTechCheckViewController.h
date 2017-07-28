//
//  PFSetTechCheckViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 28/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFInstallModel.h"

@protocol setTechCheckProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface PFSetTechCheckViewController : UIViewController

@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) PFInstallModel *modelInstall;
@property (nonatomic,weak) id <setTechCheckProtocol> delegate;

@end
