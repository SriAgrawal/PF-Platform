//
//  PFDispatchModel.m
//  PriceFixer
//
//  Created by Yogita Joshi on 29/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFDispatchModel.h"

@implementation PFDispatchModel

//2016-07-25 02:30:00

+(PFDispatchModel*)modelDispatchListDict:(id)dict{
       
    
    PFDispatchModel *disObj = [[PFDispatchModel alloc] init];
    
    disObj.strDateTimeStamp = [dict objectForKeyNotNull:@"aptDateTimestamp" expectedClass:[NSString class]];
    disObj.strOrderId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    disObj.strCustomerId = [dict objectForKeyNotNull:@"customerId" expectedClass:[NSString class]];
    disObj.strShopId = [dict objectForKeyNotNull:@"shopId" expectedClass:[NSString class]];
    disObj.strOrderType = [dict objectForKeyNotNull:@"orderType" expectedClass:[NSString class]];
    disObj.strOrderStatus = [dict objectForKeyNotNull:@"orderStatus" expectedClass:[NSString class]];
    disObj.strOrderCode = [dict objectForKeyNotNull:@"orderCode" expectedClass:[NSString class]];
    disObj.strApointmenttDate = [dict objectForKeyNotNull:@"aptDate" expectedClass:[NSString class]];
    disObj.strApointmenttId = [dict objectForKeyNotNull:@"aptId" expectedClass:[NSString class]];
    disObj.strCustomerName = [dict objectForKeyNotNull:@"customerName" expectedClass:[NSString class]];
    disObj.strShippingAddress1 = [dict objectForKeyNotNull:@"shipping_address1" expectedClass:[NSString class]];
    disObj.strShippingAddress2 = [dict objectForKeyNotNull:@"shipping_address2" expectedClass:[NSString class]];
    disObj.strShippingCity = [dict objectForKeyNotNull:@"shipping_city" expectedClass:[NSString class]];
    disObj.strShippingState = [dict objectForKeyNotNull:@"shipping_state" expectedClass:[NSString class]];
    disObj.strShippingZip = [dict objectForKeyNotNull:@"shipping_zip" expectedClass:[NSString class]];
    
    disObj.strParentOrderId = [dict objectForKeyNotNull:@"parent_order_id" expectedClass:[NSString class]];

    disObj.strCrew_id = [dict objectForKeyNotNull:@"crew_id" expectedClass:[NSString class]];
    disObj.strCrew_name = [dict objectForKeyNotNull:@"crew" expectedClass:[NSString class]];

    return disObj;
    
}

+(PFDispatchModel*)modelOrderListDict:(id)dict{
    
    PFDispatchModel *disObj = [[PFDispatchModel alloc] init];
    disObj.strAppOrderId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    disObj.strAppOrderCode = [dict objectForKeyNotNull:@"orderCode" expectedClass:[NSString class]];
    disObj.strAppShopId = [dict objectForKeyNotNull:@"shopId" expectedClass:[NSString class]];
    disObj.strAppCustomerId = [dict objectForKeyNotNull:@"customerId" expectedClass:[NSString class]];

    return disObj;
}

+(PFDispatchModel*)modelCrewDict:(id)dict{
    
    PFDispatchModel *disObj = [[PFDispatchModel alloc] init];
    disObj.strCrew_id = [dict objectForKeyNotNull:@"crew_id" expectedClass:[NSString class]];
    disObj.strCrew_name = [dict objectForKeyNotNull:@"crew_name" expectedClass:[NSString class]];
    
    return disObj;
}


+(PFDispatchModel*)modelMessageOrderListDict:(id)dict{
    
    PFDispatchModel *disObj = [[PFDispatchModel alloc] init];
    disObj.strMessageOrderId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    disObj.strMessageCustomerId = [dict objectForKeyNotNull:@"customerId" expectedClass:[NSString class]];
    disObj.strMessageShopId = [dict objectForKeyNotNull:@"shopId" expectedClass:[NSString class]];
    disObj.strMessageOrderType = [dict objectForKeyNotNull:@"orderType" expectedClass:[NSString class]];
    disObj.strOrderStatus = [dict objectForKeyNotNull:@"orderStatus" expectedClass:[NSString class]];
    disObj.strMessageOrderCode = [dict objectForKeyNotNull:@"orderCode" expectedClass:[NSString class]];
    disObj.strMessageAppDate = [dict objectForKeyNotNull:@"aptDate" expectedClass:[NSString class]];
    disObj.strMessageAppId = [dict objectForKeyNotNull:@"aptId" expectedClass:[NSString class]];
    disObj.strMessageCustomerName = [dict objectForKeyNotNull:@"customerName" expectedClass:[NSString class]];
    
    return disObj;
}

+(PFDispatchModel*)quotesListDict:(id)dict{
    
    PFDispatchModel *disObj = [[PFDispatchModel alloc] init];
    disObj.strItemCount = [dict objectForKeyNotNull:@"item_count" expectedClass:[NSString class]];
    disObj.strItemTitle = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    
    return disObj;
}



@end
