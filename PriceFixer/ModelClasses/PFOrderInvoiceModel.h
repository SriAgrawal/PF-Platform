//
//  PFOrderInvoiceModel.h
//  PriceFixer
//
//  Created by Yogita Joshi on 08/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface PFOrderInvoiceModel : NSObject


@property(strong,nonatomic) NSString * strProduct_id;
@property(strong,nonatomic) NSString * strItem_code;
@property(strong,nonatomic) NSString * strItem_title;
@property(strong,nonatomic) NSString * strItem_desc;
@property(strong,nonatomic) NSString * strQty;
@property(strong,nonatomic) NSString * strUnit_price;
@property(strong,nonatomic) NSString * strLine_total;
@property(strong,nonatomic) NSString * strCreated_on;
@property(strong,nonatomic) NSString * strIs_equipment;


+(PFOrderInvoiceModel*)modelOrderInvoiceListDict:(id)dict;
+(PFOrderInvoiceModel*)modelOrderListDict:(id)dict;



// Order Section
@property(strong,nonatomic) NSString * strOrder_id;
@property(strong,nonatomic) NSString * strOrder_date;
@property(strong,nonatomic) NSString * strOrder_code;
@property(strong,nonatomic) NSString * strCustomer_name;
@property(strong,nonatomic) NSString * strOrder_status;
@property(strong,nonatomic) NSString * strNet_total;
@property(strong,nonatomic) NSString * strOwed;
@property(strong,nonatomic) NSString * strAction_btn;
@property(strong,nonatomic) NSString * strPrint_url;

@property(strong,nonatomic) NSString * strTodate;
@property(strong,nonatomic) NSString * strFromDate;

@property(strong,nonatomic) NSString * strOrderShow;
@property(strong,nonatomic) NSString * strRange;
@property(strong,nonatomic) NSString * strOrderType;


@end
