//
//  PFUtility.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 10/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PFUtility : NSObject

+(void)alertWithTitle : (NSString*)title andMessage:(NSString*)message andController:(id)controller;
UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);
+(BOOL)validateEmailAddress:(NSString *)emailAddress;
+(NSString *)timeStampToDate:(NSString*)timeStamp;
+(NSString *)timeStampToDateOnlyShowYY:(NSString*)timeStamp;
+(NSString *)timeStampToDateForDispatch:(NSString*)timeStamp;

+(NSString *)convertHTML:(NSString *)html;
@end
