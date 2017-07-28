//
//  PFAddSpecialHour.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 08/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFAddSpecialHour.h"
#import "NSDictionary+NullChecker.h"

@implementation PFAddSpecialHour

+(PFAddSpecialHour*)modelAddSpecialHourDict:(id)dict{
    
    PFAddSpecialHour *tempDict = [[PFAddSpecialHour alloc] init];
    
    tempDict.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    tempDict.strItemTitle = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    tempDict.strUnitPrice = [dict objectForKeyNotNull:@"unit_price" expectedClass:[NSString class]];
    tempDict.strHours = [dict objectForKeyNotNull:@"hours" expectedClass:[NSString class]];
    tempDict.strCost = [dict objectForKeyNotNull:@"cost" expectedClass:[NSString class]];
    tempDict.isPrefilled = YES;
    
    return tempDict;
}

@end
