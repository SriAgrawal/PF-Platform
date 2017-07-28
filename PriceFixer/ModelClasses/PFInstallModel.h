//
//  PFInstallModel.h
//  PriceFixer
//
//  Created by Ashish Kumar Gupta on 09/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface PFInstallModel : NSObject
@property (assign,nonatomic) CGPoint collectionViewContentOffset;

@property(strong,nonatomic) NSString * strOrderId;
@property(strong,nonatomic) NSString * strParentOrderId;
@property(strong,nonatomic) NSString * strTotalQty;

@property(strong,nonatomic) NSString * strTechId;

@property(strong,nonatomic) NSString * strId;
@property(strong,nonatomic) NSString * strItemTitle;
@property(strong,nonatomic) NSString * strQuantity;

@property(strong,nonatomic) NSString * strSigned_image;


@property(strong,nonatomic) NSString * strCustomerId;
@property(strong,nonatomic) NSString * strCustomerName;
@property(strong,nonatomic) NSString * strShippingName;
@property(strong,nonatomic) NSString * strShippingPhone;
@property(strong,nonatomic) NSString * strShippingAddress1;
@property(strong,nonatomic) NSString * strShippingAddress2;
@property(strong,nonatomic) NSString * strShippingCity;
@property(strong,nonatomic) NSString * strShippingState;
@property(strong,nonatomic) NSString * strShippingZip;
@property(strong,nonatomic) NSString * strPickingImage;
@property(strong,nonatomic) NSString * strAnyRepair;
@property(strong,nonatomic) NSString * strParts;


@property(strong,nonatomic) NSString * strR_val;
@property(strong,nonatomic) NSString * strProductImageUrl;
@property(strong,nonatomic) NSString * strCurrentStatus;
@property(strong,nonatomic) NSString * strInRouteStatusId;
@property(strong,nonatomic) NSString * strArrivedStatusId;
@property(strong,nonatomic) NSString * strCompleteStatusId;



//******************************
@property(strong,nonatomic) NSString * strEquipmentTotal;
@property(strong,nonatomic) NSString * strTotal;
@property(strong,nonatomic) NSString * strPermitFee;

@property(strong,nonatomic) NSString * strTaxes;
@property(strong,nonatomic) NSString * strLabor;
@property(strong,nonatomic) NSString * strInstallKit;


@property(strong,nonatomic) NSString * strInRoute;
@property(strong,nonatomic) NSString * strIsReviewInstall;
@property(strong,nonatomic) NSString * strIsSetTechCheck;
@property(strong,nonatomic) NSString * strIsReviewEq;
@property(strong,nonatomic) NSString * strIsInRoute;

@property(strong,nonatomic) NSString * strOrderPlaceDate;
@property(strong,nonatomic) NSString * strReviewEqDate;
@property(strong,nonatomic) NSString * strIsReviewInstallDate;
@property(strong,nonatomic) NSString * strIsSetTechCheckDate;
@property(strong,nonatomic) NSString * strAppointmentDate;


@property(strong,nonatomic) NSString * title1;
@property(strong,nonatomic) NSString * title2;
@property(strong,nonatomic) NSString * title3;
@property(strong,nonatomic) NSString * title4;
@property(strong,nonatomic) NSString * title5;
@property(strong,nonatomic) NSString * title6;

//******************************

@property(strong,nonatomic) NSString * strShopId;
@property(strong,nonatomic) NSString * strOrderType;
@property(strong,nonatomic) NSString * strOrderStatus;
@property(strong,nonatomic) NSString * strOrderCode;
@property(strong,nonatomic) NSString * strAptId;
@property(strong,nonatomic) NSString * strAptDate;

@property(strong,nonatomic) NSString * titleTwoComplete;
@property(strong,nonatomic) NSString * titleThreeComplete;
@property(strong,nonatomic) NSString * titleFourComplete;
@property(strong,nonatomic) NSString * titleFiveComplete;


@property(strong,nonatomic) NSMutableArray  * arrayItems;

//**************************************
//For Buttons
@property(strong,nonatomic) NSMutableArray  * arrayButtons;
@property(strong,nonatomic) NSString * strActionDesc;
@property(strong,nonatomic) NSString * strActionTitle;


@property(strong,nonatomic) NSString * strProductId;
@property(strong,nonatomic) NSString * strProductTitle;
@property(strong,nonatomic) NSString * strProductQty;
@property(strong,nonatomic) NSString * strProductImage;
@property(strong,nonatomic) NSString * strProductStatus;

// For install detail model
@property(strong,nonatomic) NSString * strInstallDetailID;
@property(strong,nonatomic) NSString * strInstallDetailKey;
@property(strong,nonatomic) NSString * strInstallDetailValue;

+(PFInstallModel*)modelInstallListDict:(id)dict;
+(PFInstallModel*)modelChangeHoursListDict:(id)dict;
+(PFInstallModel*)modelRepairListDict:(id)dict;
+(PFInstallModel*)modelRepairProductDetailListDict:(id)dict;


@end

@interface PFOrderDetail : NSObject

@property(strong,nonatomic) NSString * strProductId;
@property(strong,nonatomic) NSString * strProductTitle;
@property(strong,nonatomic) NSString * strProductQty;
@property(strong,nonatomic) NSString * strProductImage;
@property(strong,nonatomic) NSString * strProductStatus;
@property(strong,nonatomic) NSString * strProductDiscription;
@property(strong,nonatomic) NSString * strCostPrice;
@property(strong,nonatomic) NSString * strId;
@property(strong,nonatomic) NSString * strIsGodMan;
@property(strong,nonatomic) NSString * strIsItem;
@property(strong,nonatomic) NSString * strItemCode;
@property(strong,nonatomic) NSString * strUnitPrice;
@property(strong,nonatomic) NSString * strWholeSalePrice;
@property(strong,nonatomic) NSString * strIsReturned;

//FOR TECHNICIAN REVIEW
    
@property(strong,nonatomic) NSString * strTechTitle;
@property(strong,nonatomic) NSString * strTechImage;
    
+(PFOrderDetail*)getOrderDetails:(id)dict;
+(PFOrderDetail*)getButtons:(id)dict;
@end

//********************** FOR ADD EQIPMENT ************************
@interface PFAddEquipmentModel : NSObject

@property(strong,nonatomic) NSString * strNewProduct;
@property(strong,nonatomic) NSString * strQty;
@property(strong,nonatomic) NSString * strTitle;
@property(strong,nonatomic) NSString * strDescription;
@property(strong,nonatomic) NSString * strCost;

@property(strong,nonatomic) NSString * strTitleID;
@property(strong,nonatomic) NSString * strTitleLable;
@property(strong,nonatomic) NSString * strTitleHTML;

+(PFAddEquipmentModel*)modelProductListDict:(NSDictionary *)dict;

@end


