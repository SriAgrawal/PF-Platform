//
//  UserInfo.m
//  Waikto
//
//  Created by Anil Kumar on 26/07/16.
//  Copyright © 2016 Devendra. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(UserInfo*)modelCustomerListDict:(id)dict {

    UserInfo *userObj = [[UserInfo alloc] init];
    userObj.customer_id = [dict objectForKeyNotNull:@"customer_id" expectedClass:[NSString class]];
    userObj.email = [dict objectForKeyNotNull:@"email" expectedClass:[NSString class]];
    userObj.name = [dict objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    userObj.strFirstName = [dict objectForKeyNotNull:@"first_name" expectedClass:[NSString class]];
    userObj.strLastName = [dict objectForKeyNotNull:@"last_name" expectedClass:[NSString class]];
    userObj.strPhoneNumber = [dict objectForKeyNotNull:@"phone" expectedClass:[NSString class]];
    userObj.strRegisterOn = [dict objectForKeyNotNull:@"registered_on" expectedClass:[NSString class]];
    userObj.strAddress = [dict objectForKeyNotNull:@"address" expectedClass:[NSString class]];

    return userObj;

}

@end
