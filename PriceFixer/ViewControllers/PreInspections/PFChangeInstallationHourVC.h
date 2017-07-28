//
//  PFChangeInstallationHourVC.h
//  PriceFixer
//
//  Created by Yogita Joshi on 09/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol changeAddHourProtocol <NSObject>

- (void)callTechCheckApi;

@end

@class PFPreInspectionModel;
@class PFInstallModel;

@interface PFChangeInstallationHourVC : UIViewController

@property (strong, nonatomic) PFInstallModel *installInfo;

@property (nonatomic,strong)id<changeAddHourProtocol> delegate;

@end
