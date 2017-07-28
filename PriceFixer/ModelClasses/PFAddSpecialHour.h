//
//  PFAddSpecialHour.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 08/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFAddSpecialHour : NSObject

+(PFAddSpecialHour*)modelAddSpecialHourDict:(id)dict;

// Order list
@property(strong,nonatomic) NSString * strId;
@property(strong,nonatomic) NSString * strItemTitle;
@property(strong,nonatomic) NSString * strUnitPrice;
@property(strong,nonatomic) NSString * strHours;
@property(strong,nonatomic) NSString * strCost;

@property(strong,nonatomic) NSString * strTotalCost;
@property(assign,nonatomic) BOOL isPrefilled;

//@property(strong,nonatomic) NSString * strAddSpecialHours;

@end
