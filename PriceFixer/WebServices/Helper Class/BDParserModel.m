//
//  BDParserModel.m
//  BlackDoctorApp
//
//  Created by Suresh patel on 19/05/16.
//  Copyright © 2016 mobiloitte. All rights reserved.
//

#import "BDParserModel.h"

@implementation BDParserModel

+(id)parseDataFromDict:(NSDictionary *)dict
{
    
    id classObj = [[self alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        @try {
            [classObj setValue:obj forKey:key];
        }
        @catch (NSException *exception) {
            
        }
        
    }];
    
    return classObj;
}


-(void)updateValueFromDict:(NSDictionary *)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        @try {
            [self setValue:obj forKey:key];
        }
        @catch (NSException *exception) {
            
        }
        
    }];
}

@end
