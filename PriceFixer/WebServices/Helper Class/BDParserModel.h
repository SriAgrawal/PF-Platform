//
//  BDParserModel.h
//  BlackDoctorApp
//
//  Created by Suresh patel on 19/05/16.
//  Copyright © 2016 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDParserModel : NSObject

+(id)parseDataFromDict:(NSDictionary *)dict;
-(void)updateValueFromDict:(NSDictionary *)dict;

@end
