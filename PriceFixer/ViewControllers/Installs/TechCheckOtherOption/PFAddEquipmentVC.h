//
//  PFAddEquipmentVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 02/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFInstallModel.h"

@protocol addEquipmentProtocol <NSObject>

- (void)callTechCheckApi;

@end

@interface PFAddEquipmentVC : UIViewController

@property (nonatomic,strong) PFInstallModel *modelInstall;

@property (nonatomic,strong)id<addEquipmentProtocol> delegate;
@property (nonatomic,assign) BOOL fromAddPart;

@end
