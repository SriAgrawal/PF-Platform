//
//  PFTicketInfo.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 18/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFTicketInfo.h"
#import "Macro.h"

@implementation PFTicketInfo

+(NSMutableArray *)getTicketList:(NSMutableArray *)dataArray{

    NSMutableArray *dataSourceArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in dataArray) {
        PFTicketInfo *obj = [PFTicketInfo new];
        obj.strId = [dic objectForKeyNotNull:@"id" expectedClass:[NSString class]];
        obj.strIndex = [dic objectForKeyNotNull:@"index" expectedClass:[NSString class]];
        obj.strDate = [dic objectForKeyNotNull:@"created_on" expectedClass:[NSString class]];
        obj.strAssignTo = [dic objectForKeyNotNull:@"assign_to" expectedClass:[NSString class]];
        obj.strTitle = [dic objectForKeyNotNull:@"title" expectedClass:[NSString class]];
        obj.strMessage = [dic objectForKeyNotNull:@"tickets_no" expectedClass:[NSString class]];
        obj.strPriorty = [dic objectForKeyNotNull:@"priority" expectedClass:[NSString class]];
        obj.strStatus = [dic objectForKeyNotNull:@"status" expectedClass:[NSString class]];
        [dataSourceArray addObject:obj];
    }

    return dataSourceArray ;
}
@end
