//
//  PFPreInspectionModel.m
//  PriceFixer
//
//  Created by Yogita Joshi on 05/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFPreInspectionModel.h"

@implementation PFPreInspectionModel

+(PFPreInspectionModel*)modelPreInspectionListDict:(id)dict{
    
    PFPreInspectionModel *inspectionObj = [[PFPreInspectionModel alloc] init];
    inspectionObj.strOrderId = [dict objectForKeyNotNull:@"orderId" expectedClass:[NSString class]];
    inspectionObj.strParentOrderId = [dict objectForKeyNotNull:@"parentOrderId" expectedClass:[NSString class]];

    inspectionObj.strCustomerId = [dict objectForKeyNotNull:@"customerId" expectedClass:[NSString class]];
    inspectionObj.strShippingName = [dict objectForKeyNotNull:@"shipping_name" expectedClass:[NSString class]];
    inspectionObj.strShippingPhone = [dict objectForKeyNotNull:@"shipping_phone" expectedClass:[NSString class]];
    inspectionObj.strShippingAddress1 = [dict objectForKeyNotNull:@"shipping_address1" expectedClass:[NSString class]];
    inspectionObj.strShippingAddress2 = [dict objectForKeyNotNull:@"shipping_address2" expectedClass:[NSString class]];
    inspectionObj.strShippingCity = [dict objectForKeyNotNull:@"shipping_city" expectedClass:[NSString class]];
    inspectionObj.strShippingState = [dict objectForKeyNotNull:@"shipping_state" expectedClass:[NSString class]];
    inspectionObj.strShippingZip = [dict objectForKeyNotNull:@"shipping_zip" expectedClass:[NSString class]];
    inspectionObj.strShopId = [dict objectForKeyNotNull:@"shopId" expectedClass:[NSString class]];
    inspectionObj.strOrderType = [dict objectForKeyNotNull:@"orderType" expectedClass:[NSString class]];
    inspectionObj.strOrderStatus = [dict objectForKeyNotNull:@"orderStatus" expectedClass:[NSString class]];
    inspectionObj.strOrderCode = [dict objectForKeyNotNull:@"orderCode" expectedClass:[NSString class]];
    inspectionObj.strAptId = [dict objectForKeyNotNull:@"apt_id" expectedClass:[NSString class]];
    inspectionObj.strAptDate = [dict objectForKeyNotNull:@"apt_date" expectedClass:[NSString class]];
    
    NSArray *itemArray = [dict objectForKeyNotNull:@"items" expectedClass:[NSArray class]];
    inspectionObj.arrayItems = [[NSMutableArray alloc] init];
    
    NSArray *installItemArray = [dict objectForKeyNotNull:@"installData" expectedClass:[NSArray class]];
    inspectionObj.arrayChangeInstallationItems = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *inspectionDict in installItemArray) {
        PFPreInspectionModel *inspectionInfo = [PFPreInspectionModel modelInstallDataItemArray:inspectionDict];
        [inspectionObj.arrayChangeInstallationItems addObject:inspectionInfo];
    }
    
    
    for (NSMutableDictionary *inspectionDict in itemArray) {
        PFPreInspectionModel *inspectionInfo = [PFPreInspectionModel modelPreInspectionItemArray:inspectionDict];
        [inspectionObj.arrayItems addObject:inspectionInfo];
    }
    PFPreInspectionModel *itemObj = [[PFPreInspectionModel alloc] init];
    itemObj.strInstallImage = [dict objectForKeyNotNull:@"install_image" expectedClass:[NSString class]];
    itemObj.strInstallHour = [dict objectForKeyNotNull:@"hours" expectedClass:[NSString class]];
    itemObj.strInstallTitle = [dict objectForKeyNotNull:@"title" expectedClass:[NSString class]];

    [inspectionObj.arrayItems addObject:itemObj];

    return inspectionObj;
}


+(PFPreInspectionModel*)modelPreInspectionItemArray:(id)dict{
    
    PFPreInspectionModel *itemObj = [[PFPreInspectionModel alloc] init];
    itemObj.strDeletedId = [dict objectForKeyNotNull:@"deleteId" expectedClass:[NSString class]];
    itemObj.strProductId = [dict objectForKeyNotNull:@"product_id" expectedClass:[NSString class]];
    itemObj.strProductTitle = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    itemObj.strQty = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];
    itemObj.strProductImage = [dict objectForKeyNotNull:@"productImage" expectedClass:[NSString class]];
    itemObj.strProductStatus = [dict objectForKeyNotNull:@"status" expectedClass:[NSString class]];
    return itemObj;
    
}

+(PFPreInspectionModel*)modelInstallDataItemArray:(id)dict{
    PFPreInspectionModel *itemObj = [[PFPreInspectionModel alloc] init];
    itemObj.strInstallID = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    itemObj.strInstallqty = [dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]];
    itemObj.strInstallItem_title = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];

    return itemObj;
    
}


+(PFPreInspectionModel*)modelCategoryListDict:(id)dict{
    PFPreInspectionModel *categoryObj = [[PFPreInspectionModel alloc] init];
    categoryObj.strCategory_id = [dict objectForKeyNotNull:@"category_id" expectedClass:[NSString class]];
    categoryObj.strCategory_name = [dict objectForKeyNotNull:@"category_name" expectedClass:[NSString class]];
    return categoryObj;
}

+(PFPreInspectionModel*)modelProductListDict:(id)dict{
    
    PFPreInspectionModel *productObj = [[PFPreInspectionModel alloc] init];
    productObj.strPrductId = [dict objectForKeyNotNull:@"productId" expectedClass:[NSString class]];
    productObj.strPrductCategory_id = [dict objectForKeyNotNull:@"categoryId" expectedClass:[NSString class]];
    productObj.strPrductName = [dict objectForKeyNotNull:@"name" expectedClass:[NSString class]];

    return productObj;
    
}

@end
