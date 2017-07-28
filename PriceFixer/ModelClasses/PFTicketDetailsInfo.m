//
//  PFTicketDetailsInfo.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 18/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFTicketDetailsInfo.h"
#import "Macro.h"

@implementation PFTicketDetailsInfo

+(PFTicketDetailsInfo *)getTicketDetails:(NSMutableDictionary *)dic{
        PFTicketDetailsInfo *obj = [PFTicketDetailsInfo new];
        obj.strId = [dic objectForKeyNotNull:@"id" expectedClass:[NSString class]];
        obj.strIndex = [dic objectForKeyNotNull:@"index" expectedClass:[NSString class]];
        obj.strDate = [dic objectForKeyNotNull:@"created_on" expectedClass:[NSString class]];
        obj.strAssignTo = [dic objectForKeyNotNull:@"assign_to" expectedClass:[NSString class]];
        obj.strTitle = [dic objectForKeyNotNull:@"title" expectedClass:[NSString class]];
        obj.strMessage = [dic objectForKeyNotNull:@"tickets_no" expectedClass:[NSString class]];
        obj.strPriorty = [dic objectForKeyNotNull:@"priority" expectedClass:[NSString class]];
        obj.strStatus = [dic objectForKeyNotNull:@"status" expectedClass:[NSString class]];
        obj.strCreatedBy = [dic objectForKeyNotNull:@"created_by" expectedClass:[NSString class]];
        obj.strClosedStatus = [dic objectForKeyNotNull:@"btn" expectedClass:[NSString class]];
        obj.strMessageArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *messageDic in [dic objectForKeyNotNull:@"messages" expectedClass:[NSArray class]]) {
        PFTicketDetailsInfo *messageObj = [[PFTicketDetailsInfo alloc] init];
        messageObj.strMessageUserName = [messageDic objectForKeyNotNull:@"user_name" expectedClass:[NSString class]];
        messageObj.strDate = [messageDic objectForKeyNotNull:@"created_on" expectedClass:[NSString class]];
        messageObj.strMessageDescription = [messageDic objectForKeyNotNull:@"description" expectedClass:[NSString class]];
        messageObj.strMessageType_id = [messageDic objectForKeyNotNull:@"type_id" expectedClass:[NSString class]];
        messageObj.strMessageFile_name = [messageDic objectForKeyNotNull:@"file_name" expectedClass:[NSString class]];
        [obj.strMessageArray addObject:messageObj];
    }
    
    return obj ;
}


@end
