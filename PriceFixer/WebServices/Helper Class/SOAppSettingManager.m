//
//  SOAppSettingManager.m
//  So
//
//  Created by Yogita Joshi on 03/06/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "SOAppSettingManager.h"

@implementation SOAppSettingManager

- (id) initSingleton {
    if ((self = [super init])) {
    }
    return self;
}

+ (SOAppSettingManager *) sharedinstance {
    
    // Persistent instance.
    static SOAppSettingManager *_default = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (_default != nil)
        return _default;
    
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void){
        _default = [[SOAppSettingManager alloc] initSingleton];
    });
    return _default;
}

@end
