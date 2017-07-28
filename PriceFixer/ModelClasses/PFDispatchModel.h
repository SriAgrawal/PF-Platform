//
//  PFDispatchModel.h
//  PriceFixer
//
//  Created by Yogita Joshi on 29/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface PFDispatchModel : NSObject

@property(strong,nonatomic) NSString * strCustomerId;
@property(strong,nonatomic) NSString * strCustomerName;

@property(strong,nonatomic) NSString * strShopId;
@property(strong,nonatomic) NSString * strOrderType;
@property(strong,nonatomic) NSString * strOrderId;

@property(strong,nonatomic) NSString * strOrderStatus;
@property(strong,nonatomic) NSString * strOrderCode;
@property(strong,nonatomic) NSString * strApointmenttDate;
@property(strong,nonatomic) NSString * strApointmenttId;
@property(strong,nonatomic) NSString * strShippingAddress1;
@property(strong,nonatomic) NSString * strShippingAddress2;
@property(strong,nonatomic) NSString * strShippingCity;
@property(strong,nonatomic) NSString * strShippingState;
@property(strong,nonatomic) NSString * strShippingZip;
@property(strong,nonatomic) NSString * strShippingLat;
@property(strong,nonatomic) NSString * strShippingLong;
@property(strong,nonatomic) NSString * strDateTimeStamp;

@property(strong,nonatomic) NSString * strParentOrderId;


@property(strong,nonatomic) NSString * strItemCount;
@property(strong,nonatomic) NSString * strItemTitle;




// Order list
@property(strong,nonatomic) NSString * strAppOrderId;
@property(strong,nonatomic) NSString * strAppCustomerId;
@property(strong,nonatomic) NSString * strAppShopId;
@property(strong,nonatomic) NSString * strAppOrderCode;

// For message Quote
@property(strong,nonatomic) NSString * strMessageOrderId;
@property(strong,nonatomic) NSString * strMessageCustomerId;
@property(strong,nonatomic) NSString * strMessageCustomerName;
@property(strong,nonatomic) NSString * strMessageShopId;
@property(strong,nonatomic) NSString * strMessageOrderType;
@property(strong,nonatomic) NSString * strMessageOrderStatus;
@property(strong,nonatomic) NSString * strMessageOrderCode;
@property(strong,nonatomic) NSString * strMessageAppDate;
@property(strong,nonatomic) NSString * strMessageAppId;

@property(strong,nonatomic) NSString * strCrew_id;
@property(strong,nonatomic) NSString * strCrew_name;


// For paging
@property(nonatomic,assign) NSInteger  strCount;
@property (assign,nonatomic) BOOL isSelected;

+(PFDispatchModel*)modelDispatchListDict:(id)dict;
+(PFDispatchModel*)modelOrderListDict:(id)dict;
+(PFDispatchModel*)modelMessageOrderListDict:(id)dict;
+(PFDispatchModel*)quotesListDict:(id)dict;
+(PFDispatchModel*)modelCrewDict:(id)dict;
@end

