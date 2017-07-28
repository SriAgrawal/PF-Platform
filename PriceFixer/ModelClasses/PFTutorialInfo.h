//
//  PFTutorialInfo.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface PFTutorialInfo : NSObject
@property (strong, nonatomic) NSString *strId;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strDescription;
@property (strong, nonatomic) NSString *strVideoUrl;
@property (assign, nonatomic) BOOL isWatched;
@property (strong, nonatomic) NSString *strThumbImage;

@property (assign, nonatomic) BOOL isSelected;




+ (PFTutorialInfo *)parseDataforTutorial:(NSDictionary *)dict;

-(NSString *)convertHTML:(NSString *)html;

@end
