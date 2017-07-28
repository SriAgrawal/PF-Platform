//
//  PFClientModelInfo.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 16/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFClientModelInfo.h"
#import "NSDictionary+NullChecker.h"
#import "PFUtility.h"

@implementation PFClientModelInfo

+(PFClientModelInfo*)modelCustomerListDict:(id)dict {
    
    
    PFClientModelInfo *clientObj = [[PFClientModelInfo alloc] init];
    clientObj.customer_id = [dict objectForKeyNotNull:@"customer_id" expectedClass:[NSString class]];
    clientObj.email = [dict objectForKeyNotNull:@"email" expectedClass:[NSString class]];
    clientObj.first_name = [dict objectForKeyNotNull:@"first_name" expectedClass:[NSString class]];
    clientObj.last_name = [dict objectForKeyNotNull:@"last_name" expectedClass:[NSString class]];
    clientObj.phone = [dict objectForKeyNotNull:@"phone" expectedClass:[NSString class]];
    clientObj.registered_on = [PFUtility timeStampToDate:[dict objectForKeyNotNull:@"registered_on" expectedClass:[NSString class]]];
    clientObj.is_active = [dict objectForKeyNotNull:@"is_active" expectedClass:[NSString class]];
    clientObj.address = [dict objectForKeyNotNull:@"address" expectedClass:[NSString class]];

    return clientObj;
}

+(PFClientModelInfo*)modelShopList:(id)dict {
    
    PFClientModelInfo *clientObj = [[PFClientModelInfo alloc] init];
    clientObj.shopName = [dict objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    clientObj.shopId   = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    
    return clientObj;

}



+(PFClientModelInfo*)modelBillingInfoListDict:(id)dict {
    
    PFClientModelInfo *clientObj = [[PFClientModelInfo alloc] init];
    clientObj.credit_card_person = [dict objectForKeyNotNull:@"credit_card_person" expectedClass:[NSString class]];
    clientObj.credit_card_number = [dict objectForKeyNotNull:@"credit_card_number" expectedClass:[NSString class]];
    clientObj.credit_card_month = [dict objectForKeyNotNull:@"credit_card_month" expectedClass:[NSString class]];
    clientObj.credit_card_year = [dict objectForKeyNotNull:@"credit_card_year" expectedClass:[NSString class]];
    clientObj.address_line1 = [dict objectForKeyNotNull:@"address_line1" expectedClass:[NSString class]];
    clientObj.address_line2 = [dict objectForKeyNotNull:@"address_line2" expectedClass:[NSString class]];
    clientObj.city = [dict objectForKeyNotNull:@"city" expectedClass:[NSString class]];
    clientObj.state = [dict objectForKeyNotNull:@"state" expectedClass:[NSString class]];
    clientObj.zip = [dict objectForKeyNotNull:@"zip" expectedClass:[NSString class]];
    clientObj.country = [dict objectForKeyNotNull:@"country" expectedClass:[NSString class]];
    clientObj.cvv = [dict objectForKeyNotNull:@"cvv" expectedClass:[NSString class]];

    return clientObj;
}


+(PFClientModelInfo*)modalStateInfoListDict:(id)dict {
    
    PFClientModelInfo *clientObj = [[PFClientModelInfo alloc] init];
    
    clientObj.stateId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    clientObj.stateName = [dict objectForKeyNotNull:@"name" expectedClass:[NSString class]];

    return clientObj;
}
+(PFClientModelInfo*)modalCountryInfoListDict:(id)dict {
    
    PFClientModelInfo *clientObj = [[PFClientModelInfo alloc] init];
    
    clientObj.countryId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    clientObj.countryName = [dict objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    
    return clientObj;
}

@end

@implementation PFClientOrderModelInfo

+(PFClientOrderModelInfo*)modelOrderList:(id)dict {
    
    PFClientOrderModelInfo *obj = [[PFClientOrderModelInfo alloc] init];

    obj.strId           = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];

    obj.strImage        = [dict objectForKeyNotNull:@"image" expectedClass:[NSString class]];

    obj.strOrder_type   = [dict objectForKeyNotNull:@"order_type" expectedClass:[NSString class]];

    obj.strOrder_code   = [dict objectForKeyNotNull:@"order_code" expectedClass:[NSString class]];

    obj.strOrder_status = [dict objectForKeyNotNull:@"order_status" expectedClass:[NSString class]];

    obj.strDate         = [dict objectForKeyNotNull:@"date" expectedClass:[NSString class]];

    obj.strPrice        = [dict objectForKeyNotNull:@"price" expectedClass:[NSString class]];

    obj.strTracking_url = [dict objectForKeyNotNull:@"tracking_url" expectedClass:[NSString class]];
    
    obj.strInvoice_url = [dict objectForKeyNotNull:@"invoice_url" expectedClass:[NSString class]];

    return obj;
}

@end
