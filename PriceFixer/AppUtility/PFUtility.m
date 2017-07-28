//
//  PFUtility.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 10/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFUtility.h"
#import "Macro.h"

@implementation PFUtility


+(void)alertWithTitle : (NSString*)title andMessage:(NSString*)message andController:(id)controller{
    UIAlertController   *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:NO completion:nil];
}



UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, windowWidth, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           
                           [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad)],nil];
    
    numberToolbar.barTintColor = [UIColor whiteColor];
    
    [numberToolbar sizeToFit];
    
    return numberToolbar;
}

+(BOOL)validateEmailAddress:(NSString *)emailAddress {
    
    NSString *exprs = @"^(\\w[.]?)*\\w+[@](\\w[.]?)*\\w+[.][a-z]{2,4}$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:emailAddress options:0 range:NSMakeRange(0, [emailAddress length])];
    
    return (match ? FALSE : TRUE);
}

-(void)doneWithNumberPad {
    
}

+(NSString *)timeStampToDate:(NSString*)timeStamp {
    
    NSTimeInterval _interval=[timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [_formatter setDateFormat:@"MM/dd/YYYY"];
    return[_formatter stringFromDate:date];
}


+(NSString *)timeStampToDateOnlyShowYY:(NSString*)timeStamp {
    
    NSTimeInterval _interval=[timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [_formatter setDateFormat:@"M/d/YY hh:mm a"];
    return[_formatter stringFromDate:date];
}


+(NSString *)timeStampToDateForDispatch:(NSString*)timeStamp {
    
    NSTimeInterval _interval=[timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [_formatter setDateFormat:@"MM/dd/YY hh:mm a"];
    return[_formatter stringFromDate:date];
}

+(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}


@end
