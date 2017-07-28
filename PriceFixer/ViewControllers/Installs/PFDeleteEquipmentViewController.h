//
//  PFDeleteEquipmentViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 03/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFInstallModel.h"

@protocol deleteEquipmentProtocol <NSObject>

- (void)callTechCheckApi;

@end

@interface PFDeleteEquipmentViewController : UIViewController

@property (nonatomic,weak)id<deleteEquipmentProtocol> delegate;

@property (nonatomic,strong) PFInstallModel *installModel;
@end
