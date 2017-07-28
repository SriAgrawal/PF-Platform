//
//  PFTicketInfo.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 18/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFTicketInfo : NSObject

@property (strong, nonatomic) NSString *strId;
@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strAssignTo;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *strMessage;
@property (strong, nonatomic) NSString *strStatus;
@property (strong, nonatomic) NSString *strPriorty;
@property (strong, nonatomic) NSString *strIndex;

+(NSMutableArray *)getTicketList:(NSMutableArray *)dataArray;
@end
