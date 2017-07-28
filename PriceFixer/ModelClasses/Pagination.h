//
//  Pagination.h
//  CalendarApp
//
//  Created by Yogita Joshi on 14/10/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "Macro.h"

@interface Pagination : NSObject

@property (nonatomic, strong) NSString  *pageNo;
@property (nonatomic, strong) NSString  *maxPageNo;
@property (nonatomic, strong) NSString  *pageSize;
@property (nonatomic, strong) NSString  *totalNumberOfRecords;

+(Pagination *)getPaginationInfoFromDict : (NSDictionary *)data;

@end
