//
//  PFFaqInfo.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 18/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFFaqInfo : NSObject
@property (strong, nonatomic) NSString *strId;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strDescription;

@property (assign) BOOL isExpand;

@end
