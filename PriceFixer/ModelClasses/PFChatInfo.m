//
//  PFChatInfo.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 24/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFChatInfo.h"
#import "NSDictionary+NullChecker.h"

@implementation PFChatInfo


+(PFChatInfo*)chatListDict:(id)dict {
    
    PFChatInfo *chatInfo = [[PFChatInfo alloc] init];
    
    chatInfo.title = [dict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
    chatInfo.is_private = [dict objectForKeyNotNull:@"is_private" expectedClass:[NSString class]];
    chatInfo.details = [dict objectForKeyNotNull:@"details" expectedClass:[NSString class]];
    chatInfo.date = [dict objectForKeyNotNull:@"date" expectedClass:[NSString class]];
    return chatInfo;
}

@end
