//
//  PFClientModelInfo.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 16/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFClientModelInfo : NSObject

@property(strong,nonatomic) NSString * customer_id;
@property(strong,nonatomic) NSString * email;
@property(strong,nonatomic) NSString * strItem_title;
@property(strong,nonatomic) NSString * first_name;
@property(strong,nonatomic) NSString * last_name;
@property(strong,nonatomic) NSString * phone;
@property(strong,nonatomic) NSString * registered_on;
@property(strong,nonatomic) NSString * is_active;
@property(strong,nonatomic) NSString * address;

@property(strong,nonatomic) NSString * shopName;
@property(strong,nonatomic) NSString * shopId;


// Billing Info
@property(strong,nonatomic) NSString * credit_card_person;
@property(strong,nonatomic) NSString * credit_card_number;
@property(strong,nonatomic) NSString * credit_card_month;
@property(strong,nonatomic) NSString * credit_card_year;
@property(strong,nonatomic) NSString * address_line1;
@property(strong,nonatomic) NSString * address_line2;
@property(strong,nonatomic) NSString * city;
@property(strong,nonatomic) NSString * state;
@property(strong,nonatomic) NSString * zip;
@property(strong,nonatomic) NSString * country;
@property(strong,nonatomic) NSString * credit_card_cvv;

@property(strong,nonatomic) NSString * cvv;

@property(strong,nonatomic) NSString * stateId;
@property(strong,nonatomic) NSString * stateName;

@property(strong,nonatomic) NSString * countryId;
@property(strong,nonatomic) NSString * countryName;

@property(strong,nonatomic) NSMutableArray * stateArray;
@property(strong,nonatomic) NSMutableArray * countryArray;

+(PFClientModelInfo*)modelCustomerListDict:(id)dict;
+(PFClientModelInfo*)modelShopList:(id)dict;
+(PFClientModelInfo*)modelBillingInfoListDict:(id)dict;
+(PFClientModelInfo*)modalStateInfoListDict:(id)dict;
+(PFClientModelInfo*)modalCountryInfoListDict:(id)dict;

@end

@interface PFClientOrderModelInfo : NSObject

@property(strong,nonatomic) NSString * strImage;
@property(strong,nonatomic) NSString * strOrder_type;
@property(strong,nonatomic) NSString * strOrder_code;
@property(strong,nonatomic) NSString * strOrder_status;
@property(strong,nonatomic) NSString * strDate;
@property(strong,nonatomic) NSString * strPrice;
@property(strong,nonatomic) NSString * strTracking_url;
@property(strong,nonatomic) NSString * strId;
@property(strong,nonatomic) NSString * strInvoice_url;


+(PFClientOrderModelInfo*)modelOrderList:(id)dict;


@end
