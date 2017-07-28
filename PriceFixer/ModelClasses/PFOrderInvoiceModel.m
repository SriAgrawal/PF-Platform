//
//  PFOrderInvoiceModel.m
//  PriceFixer
//
//  Created by Yogita Joshi on 08/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFOrderInvoiceModel.h"

@implementation PFOrderInvoiceModel

+(PFOrderInvoiceModel*)modelOrderInvoiceListDict:(id)dict{
    PFOrderInvoiceModel *itemObj = [[PFOrderInvoiceModel alloc] init];
    itemObj.strProduct_id = [dict objectForKeyNotNull:@"product_id" expectedClass:[NSString class]];
    itemObj.strItem_code = [dict objectForKeyNotNull:@"item_code" expectedClass:[NSString class]];
    itemObj.strItem_title = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    itemObj.strItem_desc = [dict objectForKeyNotNull:@"item_desc" expectedClass:[NSString class]];
    itemObj.strQty = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];
    itemObj.strUnit_price = [dict objectForKeyNotNull:@"unit_price" expectedClass:[NSString class]];
    itemObj.strLine_total = [dict objectForKeyNotNull:@"line_total" expectedClass:[NSString class]];
    itemObj.strCreated_on = [dict objectForKeyNotNull:@"created_on" expectedClass:[NSString class]];
    itemObj.strIs_equipment = [dict objectForKeyNotNull:@"is_equipment" expectedClass:[NSString class]];

    return itemObj;
}


+(PFOrderInvoiceModel*)modelOrderListDict:(id)dict {
    
    PFOrderInvoiceModel *orderObj = [[PFOrderInvoiceModel alloc] init];
    
    orderObj.strOrder_id = [dict objectForKeyNotNull:@"order_id" expectedClass:[NSString class]];
    orderObj.strOrder_date = [dict objectForKeyNotNull:@"order_date" expectedClass:[NSString class]];
    orderObj.strOrder_code = [dict objectForKeyNotNull:@"order_code" expectedClass:[NSString class]];
    orderObj.strCustomer_name = [dict objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]];
    orderObj.strOrder_status = [dict objectForKeyNotNull:@"order_status" expectedClass:[NSString class]];
    orderObj.strNet_total = [dict objectForKeyNotNull:@"net_total" expectedClass:[NSString class]];
    orderObj.strOwed = [dict objectForKeyNotNull:@"owed" expectedClass:[NSString class]];
    orderObj.strAction_btn = [dict objectForKeyNotNull:@"action_btn" expectedClass:[NSString class]];
    orderObj.strPrint_url = [dict objectForKeyNotNull:@"print_url" expectedClass:[NSString class]];
    
    return orderObj;

}

@end
