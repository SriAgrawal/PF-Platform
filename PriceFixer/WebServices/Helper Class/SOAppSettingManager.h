//
//  SOAppSettingManager.h
//  So
//
//  Created by Yogita Joshi on 03/06/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface SOAppSettingManager : NSObject

@property (nonatomic,strong) SOAppSettingManager *appUserInfo;


+ (SOAppSettingManager *) sharedinstance;


@end
