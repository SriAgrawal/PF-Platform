//
//  PFQuotesListInfo.m
//  PriceFixer
//
//  Created by Tejas Pareek on 17/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFQuotesListInfo.h"
#import "Macro.h"

@implementation PFQuotesListInfo

+(PFQuotesListInfo *)getQuotesList:(NSDictionary *)dict{

    PFQuotesListInfo *obj = [PFQuotesListInfo new];

    obj.strId = [dict objectForKeyNotNull:@"quote_id" expectedClass:[NSString class]];
    obj.strDate = [dict objectForKeyNotNull:@"quote_date" expectedClass:[NSString class]];
    obj.strName = [dict objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]];
    obj.strPhoneNumber = [dict objectForKeyNotNull:@"customer_phone" expectedClass:[NSString class]];
    obj.strQuote = [dict objectForKeyNotNull:@"is_coupon" expectedClass:[NSString class]];
    obj.strEmail = [dict objectForKeyNotNull:@"customer_email" expectedClass:[NSString class]];
    obj.strStatus = [dict objectForKeyNotNull:@"quote_status" expectedClass:[NSString class]];
    obj.strRegisteredUser = [dict objectForKeyNotNull:@"is_registered" expectedClass:[NSString class]];
    obj.strPrintUrl = [dict objectForKeyNotNull:@"print_url" expectedClass:[NSString class]];


    return obj;
}

+(PFQuotesListInfo *)getNotesList:(NSDictionary *)dict {
    
    PFQuotesListInfo *obj = [PFQuotesListInfo new];
    
    obj.strDescription = [dict objectForKeyNotNull:@"description" expectedClass:[NSString class]];
    obj.strIncludeEmail = [dict objectForKeyNotNull:@"include_in_email" expectedClass:[NSString class]];
    
    return obj;
}

+(PFQuotesListInfo *)getItemsForEdit:(NSDictionary *)dict
{
    PFQuotesListInfo *obj = [PFQuotesListInfo new];
    obj.strCheck_title = [dict objectForKeyNotNull:@"check_title" expectedClass:[NSString class]];
    obj.strPer_month = [dict objectForKeyNotNull:@"per_month" expectedClass:[NSString class]];
    obj.strPlus_minue = [dict objectForKeyNotNull:@"plus_minue" expectedClass:[NSString class]];
    obj.strPrice = [dict objectForKeyNotNull:@"price" expectedClass:[NSString class]];
    obj.strProduct_id = [dict objectForKeyNotNull:@"product_id" expectedClass:[NSString class]];
    obj.strProduct_name = [dict objectForKeyNotNull:@"product_name" expectedClass:[NSString class]];
    obj.strQty = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];
    obj.strSub_total = [dict objectForKeyNotNull:@"sub_total" expectedClass:[NSString class]];
    obj.strDesc = [dict objectForKeyNotNull:@"desc" expectedClass:[NSString class]];
    obj.strProduct_detail_url = [dict objectForKeyNotNull:@"product_detail_url" expectedClass:[NSString class]];
    obj.strProduct_image_urlEmail = [dict objectForKeyNotNull:@"product_image_url" expectedClass:[NSString class]];
    return obj;
}
+(PFQuotesListInfo *)getColSpamList:(NSDictionary *)dict
{
    PFQuotesListInfo *obj = [PFQuotesListInfo new];
    obj.strProduct_name = [dict objectForKeyNotNull:@"product_name" expectedClass:[NSString class]];
    obj.strProduct_image_urlEmail = [dict objectForKeyNotNull:@"product_image_url" expectedClass:[NSString class]];
    obj.strProduct_id = [dict objectForKeyNotNull:@"product_id" expectedClass:[NSString class]];
    obj.strProduct_detail_url = [dict objectForKeyNotNull:@"product_detail_url" expectedClass:[NSString class]];
    obj.strPrice = [dict objectForKeyNotNull:@"price" expectedClass:[NSString class]];
    obj.strPer_month = [dict objectForKeyNotNull:@"per_month" expectedClass:[NSString class]];
    obj.strDesc = [dict objectForKeyNotNull:@"desc" expectedClass:[NSString class]];
    obj.strCheck_title = [dict objectForKeyNotNull:@"check_title" expectedClass:[NSString class]];
    obj.strTitle = [dict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
    obj.strIsInstall = [dict objectForKeyNotNull:@"is_install" expectedClass:[NSString class]];
    obj.strFigure = [dict objectForKeyNotNull:@"figure" expectedClass:[NSString class]];
    obj.strCatTitle = [dict objectForKeyNotNull:@"cat_title" expectedClass:[NSString class]];
    obj.strCatText = [dict objectForKeyNotNull:@"cat_text" expectedClass:[NSString class]];
    obj.strCatProductsAr = [dict objectForKeyNotNull:@"cat_products_ar" expectedClass:[NSString class]];
    return obj;
}

@end

@implementation PFQuotesProductListInfo

+(PFQuotesProductListInfo*)modelProductListDict:(id)dict{
    
    PFQuotesProductListInfo *obj = [PFQuotesProductListInfo new];
    obj.strTitleID = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    obj.strTitleLable = [dict objectForKeyNotNull:@"label" expectedClass:[NSString class]];
    obj.strTitleHTML = [dict objectForKeyNotNull:@"label_html" expectedClass:[NSString class]];
    
    return obj;
    
}


@end
