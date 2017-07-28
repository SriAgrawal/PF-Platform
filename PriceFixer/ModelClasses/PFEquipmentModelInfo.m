//
//  PFEquipmentModelInfo.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 04/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFEquipmentModelInfo.h"
#import "NSDictionary+NullChecker.h"

@implementation PFEquipmentModelInfo

+(PFEquipmentModelInfo*)modelDeleteEquipmentListDict:(id)dict {
    
    PFEquipmentModelInfo *equipmentObj = [[PFEquipmentModelInfo alloc] init];
    equipmentObj.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    equipmentObj.strQty = [[dict objectForKeyNotNull:@"qty" expectedClass:[NSString class]] intValue];
    equipmentObj.strItem_desc = [dict objectForKeyNotNull:@"item_desc" expectedClass:[NSString class]];
    equipmentObj.strItem_title = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    equipmentObj.strTotalLine = [dict objectForKeyNotNull:@"line_total" expectedClass:[NSString class]];
    equipmentObj.isSelect = NO;

    return equipmentObj;
}

+(PFEquipmentModelInfo*)modelUploadImageListDict:(id)dict;
{
    
    PFEquipmentModelInfo *uploadObj = [[PFEquipmentModelInfo alloc] init];
    uploadObj.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    
    uploadObj.strOld_eq_image = [dict objectForKeyNotNull:@"old_eq_image" expectedClass:[NSString class]];
    
    uploadObj.strImageurl = [dict objectForKeyNotNull:@"imageurl" expectedClass:[NSString class]];
    uploadObj.strItem_desc = [dict objectForKeyNotNull:@"item_desc" expectedClass:[NSString class]];
    uploadObj.strItem_title = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    uploadObj.strNew_eq_image = [dict objectForKeyNotNull:@"new_eq_image" expectedClass:[NSString class]];
    return uploadObj;
}

+(PFEquipmentModelInfo*)modelInstallPicListDict:(id)dict {
    
    
    PFEquipmentModelInfo *uploadObj = [[PFEquipmentModelInfo alloc] init];
    
    uploadObj.strImageurl = [dict objectForKeyNotNull:@"img_src" expectedClass:[NSString class]];
    uploadObj.strItem_title = [dict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
    
    return uploadObj;
}


+(PFEquipmentModelInfo*)modelInstallProcessReturnListDict:(id)dict {
    
    PFEquipmentModelInfo *uploadObj = [[PFEquipmentModelInfo alloc] init];
    uploadObj.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    
    uploadObj.strOld_eq_image = [dict objectForKeyNotNull:@"old_eq_image" expectedClass:[NSString class]];
    
    uploadObj.strImageurl = [dict objectForKeyNotNull:@"imageurl" expectedClass:[NSString class]];
    uploadObj.strItem_desc = [dict objectForKeyNotNull:@"item_desc" expectedClass:[NSString class]];
    uploadObj.strItem_title = [dict objectForKeyNotNull:@"item_title" expectedClass:[NSString class]];
    
    return uploadObj;
}

@end
