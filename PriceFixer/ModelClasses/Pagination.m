//
//  Pagination.m
//  CalendarApp
//
//  Created by Yogita Joshi on 14/10/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "Pagination.h"

@implementation Pagination

+(Pagination *)getPaginationInfoFromDict : (NSDictionary *)data {
    
    Pagination *page = [[Pagination alloc] init];
    page.pageNo = [data objectForKeyNotNull:@"pageNumber" expectedClass:[NSString class]];
    page.maxPageNo = [data objectForKeyNotNull:@"maximumPages" expectedClass:[NSString class]];
    page.totalNumberOfRecords = [data objectForKeyNotNull:@"total_no_records" expectedClass:[NSString class]];
    
    return page;
}

@end

