//
//  PFPreInspectionModel.h
//  PriceFixer
//
//  Created by Yogita Joshi on 05/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"


//@interface PFPreInspectionItemModel : NSObject
//
//@end


@interface PFPreInspectionModel : NSObject

@property (assign,nonatomic) CGPoint collectionViewContentOffset;

@property(strong,nonatomic) NSString * strOrderId;
@property(strong,nonatomic) NSString * strParentOrderId;
@property(strong,nonatomic) NSString * strCustomerId;
@property(strong,nonatomic) NSString * strShippingName;
@property(strong,nonatomic) NSString * strShippingPhone;
@property(strong,nonatomic) NSString * strShippingAddress1;
@property(strong,nonatomic) NSString * strShippingAddress2;
@property(strong,nonatomic) NSString * strShippingCity;
@property(strong,nonatomic) NSString * strShippingState;
@property(strong,nonatomic) NSString * strShippingZip;
@property(strong,nonatomic) NSString * strShopId;
@property(strong,nonatomic) NSString * strOrderType;
@property(strong,nonatomic) NSString * strOrderStatus;
@property(strong,nonatomic) NSString * strOrderCode;
@property(strong,nonatomic) NSString * strAptId;
@property(strong,nonatomic) NSString * strAptDate;

@property(strong,nonatomic) NSMutableArray  * arrayItems;
@property(strong,nonatomic) NSMutableArray  * arrayChangeInstallationItems;

@property(strong,nonatomic) NSString *strInstallID;
@property(strong,nonatomic) NSString *strInstallqty;
@property(strong,nonatomic) NSString *strInstallItem_title;

@property(strong,nonatomic) NSString * strDeletedId;
@property(strong,nonatomic) NSString * strProductId;
@property(strong,nonatomic) NSString * strProductTitle;
@property(strong,nonatomic) NSString * strQty;
@property(strong,nonatomic) NSString * strProductImage;
@property(strong,nonatomic) NSString * strProductStatus;

@property(strong,nonatomic) NSString * strInstallImage;
@property(strong,nonatomic) NSString * strInstallTitle;
@property(strong,nonatomic) NSString * strInstallHour;


// For Category List
@property(strong,nonatomic) NSString * strCategory_id;
@property(strong,nonatomic) NSString * strCategory_name;

// For Product List
@property(strong,nonatomic) NSString * strPrductId;
@property(strong,nonatomic) NSString * strPrductCategory_id;
@property(strong,nonatomic) NSString * strPrductName;


+(PFPreInspectionModel*)modelPreInspectionListDict:(id)dict;
+(PFPreInspectionModel*)modelCategoryListDict:(id)dict;
+(PFPreInspectionModel*)modelProductListDict:(id)dict;

@end
