//
//  PFTicketDetailsInfo.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 18/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFTicketDetailsInfo : NSObject

@property (strong, nonatomic) NSString *strId;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strAssignTo;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strMessage;
@property (strong, nonatomic) NSString *strStatus;
@property (strong, nonatomic) NSString *strPriorty;
@property (strong, nonatomic) NSString *strIndex;
@property (strong, nonatomic) NSString *strCreatedBy;
@property (strong, nonatomic) NSMutableArray *strMessageArray;
@property (strong, nonatomic) NSString *strMessageUserName;
@property (strong, nonatomic) NSString *strMessageDescription;
@property (strong, nonatomic) NSString *strMessageFile_name;
@property (strong, nonatomic) NSString *strMessageType_id;
@property (strong, nonatomic) NSString *strClosedStatus;

+(PFTicketDetailsInfo *)getTicketDetails:(NSMutableDictionary *)dic;

@end
