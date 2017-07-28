//
//  PFChatInfo.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 24/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFChatInfo : NSObject

+(PFChatInfo*)chatListDict:(id)dict;

@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * is_private;
@property(strong,nonatomic) NSString * details;
@property(strong,nonatomic) NSString * date;

@end
