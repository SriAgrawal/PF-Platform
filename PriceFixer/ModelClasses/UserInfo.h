//
//  UserInfo.h
//  Waikto
//
//  Created by Anil Kumar on 26/07/16.
//  Copyright © 2016 Devendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface UserInfo : NSObject

+(UserInfo*)modelCustomerListDict:(id)dict;

@property(strong,nonatomic) NSString * strOldPassword;
@property(strong,nonatomic) NSString * strNewPassword;
@property(strong,nonatomic) NSString * strConfirmPassword;

@property(strong,nonatomic) NSString * strEmail;
@property(strong,nonatomic) NSString * strCustomer;
@property(strong,nonatomic) NSString * strPhoneNumber;
@property(strong,nonatomic) NSString * strFirstName;
@property(strong,nonatomic) NSString * strLastName;
@property(strong,nonatomic) NSString * strRegisterOn;
@property(strong,nonatomic) NSString * strAddress;

@property(strong,nonatomic) NSString * customer_id;
@property(strong,nonatomic) NSString * email;
@property(strong,nonatomic) NSString * name;

@property(strong,nonatomic) NSString * strFind;
@property(strong,nonatomic) NSString * strCallPrompted;


@property(nonatomic,assign) NSInteger  strCount;
@property (assign,nonatomic) BOOL isSelected;
@end
