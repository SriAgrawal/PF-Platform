//
//  PFInstallModel.m
//  PriceFixer
//
//  Created by Ashish Kumar Gupta on 09/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFInstallModel.h"

@implementation PFInstallModel
+(PFInstallModel*)modelInstallListDict:(id)dict
{
    
    PFInstallModel *installObj = [[PFInstallModel alloc] init];
    installObj.strTechId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];

    //*****************************************************
    //FOR ORDER CUSTOMER
    //*****************************************************
    NSDictionary *customerDict = [dict objectForKeyNotNull:@"customer" expectedClass:[NSDictionary class]];
    installObj.strCustomerId = [customerDict objectForKeyNotNull:@"customer_id" expectedClass:[NSString class]];
    installObj.strEquipmentTotal = [customerDict objectForKeyNotNull:@"equipment_total" expectedClass:[NSString class]];
    installObj.strInstallKit = [customerDict objectForKeyNotNull:@"install_kit" expectedClass:[NSString class]];
    
    installObj.strAnyRepair = [customerDict objectForKeyNotNull:@"any_repair" expectedClass:[NSString class]];
    installObj.strParts = [customerDict objectForKeyNotNull:@"parts" expectedClass:[NSString class]];

    installObj.strPermitFee = [customerDict objectForKeyNotNull:@"permit_fee" expectedClass:[NSString class]];
    installObj.strTotal = [customerDict objectForKeyNotNull:@"total" expectedClass:[NSString class]];
    installObj.strTaxes = [customerDict objectForKeyNotNull:@"taxes" expectedClass:[NSString class]];
    installObj.strLabor = [customerDict objectForKeyNotNull:@"labor" expectedClass:[NSString class]];
    
    installObj.strCustomerName = [customerDict objectForKeyNotNull:@"customer_name" expectedClass:[NSString class]];
    installObj.strShippingName = [customerDict objectForKeyNotNull:@"shipping_name" expectedClass:[NSString class]];
    installObj.strShippingPhone = [customerDict objectForKeyNotNull:@"shipping_phone" expectedClass:[NSString class]];
    
    installObj.strShippingAddress1 = [customerDict objectForKeyNotNull:@"shipping_address1" expectedClass:[NSString class]];
    installObj.strShippingAddress2 = [customerDict objectForKeyNotNull:@"shipping_address2" expectedClass:[NSString class]];
    installObj.strShippingCity = [customerDict objectForKeyNotNull:@"shipping_city" expectedClass:[NSString class]];
    installObj.strShippingState = [customerDict objectForKeyNotNull:@"shipping_state" expectedClass:[NSString class]];
    installObj.strShippingZip = [customerDict objectForKeyNotNull:@"shipping_zip" expectedClass:[NSString class]];
    installObj.strShopId = [customerDict objectForKeyNotNull:@"shop_id" expectedClass:[NSString class]];
    
    
    //*****************************************************
    //FOR ACTION BUTTON
    //*****************************************************
        NSDictionary *btnDict = [dict objectForKeyNotNull:@"action_buttons" expectedClass:[NSDictionary class]];
        installObj.strActionDesc =[btnDict objectForKeyNotNull:@"action_desc" expectedClass:[NSString class]];
        installObj.strActionTitle =[btnDict objectForKeyNotNull:@"action_title" expectedClass:[NSString class]];
        installObj.arrayButtons = [btnDict objectForKeyNotNull:@"action_button" expectedClass:[NSArray class]];

    //*****************************************************
    //FOR ORDER DETAIL
    //*****************************************************
    
    NSDictionary *orderDict = [dict objectForKeyNotNull:@"order_details" expectedClass:[NSDictionary class]];
    installObj.strAptId =[orderDict objectForKeyNotNull:@"apt_id" expectedClass:[NSString class]];
    installObj.strAptDate =[orderDict objectForKeyNotNull:@"apt_date" expectedClass:[NSString class]];
    installObj.strOrderCode = [orderDict objectForKeyNotNull:@"order_code" expectedClass:[NSString class]];
    installObj.strOrderId = [orderDict objectForKeyNotNull:@"order_id" expectedClass:[NSString class]];
    installObj.strOrderStatus = [orderDict objectForKeyNotNull:@"order_status" expectedClass:[NSString class]];
    installObj.strParentOrderId = [orderDict objectForKeyNotNull:@"parent_order_id" expectedClass:[NSString class]];
    
    installObj.strSigned_image = [orderDict objectForKeyNotNull:@"signed_image" expectedClass:[NSString class]];
    installObj.strPickingImage = [orderDict objectForKeyNotNull:@"packing_url" expectedClass:[NSString class]];

    installObj.strTotalQty = [orderDict objectForKeyNotNull:@"total_qty" expectedClass:[NSString class]];
    
    //*****************************************************
    //FOR ORDER ITEMS
    //*****************************************************
    NSArray *items = [dict objectForKeyNotNull:@"order_items" expectedClass:[NSArray class]];
    installObj.arrayItems = [NSMutableArray new];
        for (NSMutableDictionary *installDict in items)
        {
            PFOrderDetail *installInfo = [PFOrderDetail getOrderDetails:installDict];
            [installObj.arrayItems addObject:installInfo];
        }
    
    //*****************************************************
    //FOR ORDER TRACK
    //*****************************************************
    NSDictionary *ordertrackDict = [dict objectForKeyNotNull:@"order_track" expectedClass:[NSDictionary class]];

    installObj.title1 = [ordertrackDict objectForKeyNotNull:@"title1" expectedClass:[NSString class]];
    installObj.strOrderPlaceDate = [ordertrackDict objectForKeyNotNull:@"title1_date" expectedClass:[NSString class]];

    
    installObj.title2 = [ordertrackDict objectForKeyNotNull:@"title2" expectedClass:[NSString class]];
    installObj.strIsSetTechCheckDate = [ordertrackDict objectForKeyNotNull:@"title2_date" expectedClass:[NSString class]];
    installObj.strIsSetTechCheck = [ordertrackDict objectForKeyNotNull:@"title2_complete" expectedClass:[NSString class]];

    
    installObj.title3 = [ordertrackDict objectForKeyNotNull:@"title3" expectedClass:[NSString class]];
    installObj.strInRoute = [ordertrackDict objectForKeyNotNull:@"title3_date" expectedClass:[NSString class]];
    installObj.strIsInRoute = [ordertrackDict objectForKeyNotNull:@"title3_complete" expectedClass:[NSString class]];
    
    
    installObj.title4 = [ordertrackDict objectForKeyNotNull:@"title4" expectedClass:[NSString class]];
    installObj.strReviewEqDate = [ordertrackDict objectForKeyNotNull:@"title4_date" expectedClass:[NSString class]];
    installObj.strIsReviewEq = [ordertrackDict objectForKeyNotNull:@"title4_complete" expectedClass:[NSString class]];

    
    installObj.title5 = [ordertrackDict objectForKeyNotNull:@"title5" expectedClass:[NSString class]];
    installObj.strIsReviewInstall = [ordertrackDict objectForKeyNotNull:@"title5_complete" expectedClass:[NSString class]];
    installObj.strIsReviewInstallDate = [ordertrackDict objectForKeyNotNull:@"title5_date" expectedClass:[NSString class]];

    
    installObj.title6 = [ordertrackDict objectForKeyNotNull:@"title6" expectedClass:[NSString class]];
    
    return installObj;

}


+(PFInstallModel*)modelChangeHoursListDict:(id)dict{
    PFInstallModel *itemObj = [[PFInstallModel alloc] init];
    itemObj.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    itemObj.strItemTitle = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];

    itemObj.strQuantity = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];

    return itemObj;

}


+(PFInstallModel*)modelRepairListDict:(id)dict
{
    
    PFInstallModel *installObj = [[PFInstallModel alloc] init];
    
    //FOR ORDER CUSTOMER
    //*****************************************************
    NSDictionary *customerDict = [dict objectForKeyNotNull:@"client_order" expectedClass:[NSDictionary class]];
    installObj.strOrderId = [customerDict objectForKeyNotNull:@"order_id" expectedClass:[NSString class]];
    installObj.strParentOrderId = [customerDict objectForKeyNotNull:@"parent_order_id" expectedClass:[NSString class]];
  //  installObj.insta = [customerDict objectForKeyNotNull:@"installation_action" expectedClass:[NSString class]];
    installObj.strAptDate = [customerDict objectForKeyNotNull:@"installation_date" expectedClass:[NSString class]];
    installObj.strShippingName = [customerDict objectForKeyNotNull:@"shipping_name" expectedClass:[NSString class]];
    installObj.strShippingPhone = [customerDict objectForKeyNotNull:@"shipping_phone" expectedClass:[NSString class]];
    
    installObj.strShippingAddress1 = [customerDict objectForKeyNotNull:@"shipping_address" expectedClass:[NSString class]];
   // installObj.strShippingName = [customerDict objectForKeyNotNull:@"current_status_action" expectedClass:[NSString class]];
    installObj.strCurrentStatus = [customerDict objectForKeyNotNull:@"current_status" expectedClass:[NSString class]];
    
  //  installObj.strShippingAddress1 = [customerDict objectForKeyNotNull:@"contract_action" expectedClass:[NSString class]];
    installObj.strOrderCode = [customerDict objectForKeyNotNull:@"order_code" expectedClass:[NSString class]];
    
    installObj.strR_val = [customerDict objectForKeyNotNull:@"r_val" expectedClass:[NSString class]];
    
    
    //FOR ORDER DETAIL
    //*****************************************************
    
    NSDictionary *orderDict = [dict objectForKeyNotNull:@"order_track" expectedClass:[NSDictionary class]];
    
    installObj.strInRouteStatusId =[orderDict objectForKeyNotNull:@"inroute_status_id" expectedClass:[NSString class]];
    installObj.strArrivedStatusId =[orderDict objectForKeyNotNull:@"arrived_status_id" expectedClass:[NSString class]];
    installObj.strCompleteStatusId =[orderDict objectForKeyNotNull:@"complete_status_id" expectedClass:[NSString class]];
    installObj.title1 = [orderDict objectForKeyNotNull:@"title1" expectedClass:[NSString class]];
    
    installObj.strOrderPlaceDate = [orderDict objectForKeyNotNull:@"title1_date" expectedClass:[NSString class]];
    installObj.title2 = [orderDict objectForKeyNotNull:@"title2" expectedClass:[NSString class]];
    installObj.strAppointmentDate = [orderDict objectForKeyNotNull:@"title2_date" expectedClass:[NSString class]];
    
    installObj.titleTwoComplete = [orderDict objectForKeyNotNull:@"title2_complete" expectedClass:[NSString class]];
    
    installObj.title3 = [orderDict objectForKeyNotNull:@"title3" expectedClass:[NSString class]];
    installObj.titleThreeComplete = [orderDict objectForKeyNotNull:@"title3_complete" expectedClass:[NSString class]];
    installObj.title4 = [orderDict objectForKeyNotNull:@"title4" expectedClass:[NSString class]];
    installObj.titleFourComplete = [orderDict objectForKeyNotNull:@"title4_complete" expectedClass:[NSString class]];
    installObj.title5 = [orderDict objectForKeyNotNull:@"title5" expectedClass:[NSString class]];
    installObj.strIsReviewInstall = [orderDict objectForKeyNotNull:@"title5_complete" expectedClass:[NSString class]];

    //FOR ORDER ITEMS
    //*****************************************************
    NSArray *items = [dict objectForKeyNotNull:@"product_detail" expectedClass:[NSArray class]];
    installObj.arrayItems = [NSMutableArray new];
    for (NSMutableDictionary *installDict in items)
    {
        PFInstallModel *installInfo = [PFInstallModel modelRepairProductDetailListDict:installDict];
        [installObj.arrayItems addObject:installInfo];
    }
    
        return installObj;
}

+(PFInstallModel*)modelRepairProductDetailListDict:(id)dict;
 {
    
     PFInstallModel *installObj = [[PFInstallModel alloc] init];
     installObj.strProductImageUrl = [dict objectForKeyNotNull:@"image_url" expectedClass:[NSString class]];
     installObj.strItemTitle = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
     installObj.strQuantity = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];
     
     return installObj;
}


@end

@implementation PFOrderDetail
+(PFOrderDetail*)getOrderDetails:(id)dict {
    
    PFOrderDetail *itemObj = [[PFOrderDetail alloc] init];
    itemObj.strCostPrice = [dict objectForKeyNotNull:@"cost_price" expectedClass:[NSString class]];
    itemObj.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    itemObj.strIsGodMan = [dict objectForKeyNotNull:@"is_goodman" expectedClass:[NSString class]];
    itemObj.strIsItem = [dict objectForKeyNotNull:@"is_item" expectedClass:[NSString class]];
    itemObj.strItemCode = [dict objectForKeyNotNull:@"item_code" expectedClass:[NSString class]];
    itemObj.strProductDiscription = [dict objectForKeyNotNull:@"item_desc" expectedClass:[NSString class]];
    itemObj.strProductDiscription = [dict objectForKeyNotNull:@"order_id" expectedClass:[NSString class]];
    itemObj.strProductId = [dict objectForKeyNotNull:@"product_id" expectedClass:[NSString class]];
    itemObj.strProductImage = [dict objectForKeyNotNull:@"product_image" expectedClass:[NSString class]];
    
    itemObj.strProductQty = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];
    itemObj.strProductDiscription = [dict objectForKeyNotNull:@"item_desc" expectedClass:[NSString class]];
    
    itemObj.strIsReturned = [dict objectForKeyNotNull:@"is_returned" expectedClass:[NSString class]];

    itemObj.strProductTitle = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];


    itemObj.strUnitPrice = [dict objectForKeyNotNull:@"unit_price" expectedClass:[NSString class]];
    itemObj.strWholeSalePrice = [dict objectForKeyNotNull:@"whole_sale_price" expectedClass:[NSString class]];
    
//FOR TECHNICIAN REVIEW
    
    itemObj.strTechImage = [dict objectForKeyNotNull:@"tech_image" expectedClass:[NSString class]];
    itemObj.strTechTitle = [dict objectForKeyNotNull:@"tech_title" expectedClass:[NSString class]];
    
    return itemObj;
}

+(PFOrderDetail*)getButtons:(id)dict {
    PFOrderDetail *btnObj = [[PFOrderDetail alloc] init];
    
    return btnObj;
}


@end
@implementation PFAddEquipmentModel

+(PFAddEquipmentModel*)modelProductListDict:(NSDictionary *)dict{
    
    PFAddEquipmentModel *obj = [PFAddEquipmentModel new];
    obj.strTitleID = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    obj.strTitleLable = [dict objectForKeyNotNull:@"label" expectedClass:[NSString class]];
    obj.strTitleHTML = [dict objectForKeyNotNull:@"label_html" expectedClass:[NSString class]];
    return obj;
}

@end
