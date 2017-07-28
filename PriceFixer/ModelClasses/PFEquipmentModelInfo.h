//
//  PFEquipmentModelInfo.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 04/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFEquipmentModelInfo : NSObject

// Delete Equipment List
@property(strong,nonatomic) NSString * strId;
@property(strong,nonatomic) NSString * strItem_title;
@property(strong,nonatomic) NSString * strItem_desc;
@property(assign,nonatomic) NSInteger  strQty;
@property(assign,nonatomic) BOOL  textFieldBecomeFirstResponder;

// Upload Image
@property(strong,nonatomic) NSString  *strImageurl;
@property(strong,nonatomic) NSString  *strOld_eq_image;
@property(strong,nonatomic) NSString  *strNew_eq_image;

@property(strong,nonatomic) NSString  *strImageName;

@property(nonatomic,assign) BOOL isSelect;
@property(strong,nonatomic) NSString  *strTotalLine;

@property(strong,nonatomic) NSString  *strNetTotal;
@property(strong,nonatomic) NSString  *strReturnAmount;
@property(strong,nonatomic) NSString  *strOsAmount;
@property(strong,nonatomic) NSString  *strSubTotal;
@property(strong,nonatomic) NSString  *strTotalTax;
@property(strong,nonatomic) NSString  *strShippingCharge;


+(PFEquipmentModelInfo*)modelDeleteEquipmentListDict:(id)dict;
+(PFEquipmentModelInfo*)modelUploadImageListDict:(id)dict;

+(PFEquipmentModelInfo*)modelInstallPicListDict:(id)dict;




@end
