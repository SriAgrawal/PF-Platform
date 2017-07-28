//
//  PFTutorialInfo.m
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFTutorialInfo.h"

@implementation PFTutorialInfo



+ (PFTutorialInfo *)parseDataforTutorial:(NSDictionary *)dict {
    PFTutorialInfo *info = [[PFTutorialInfo alloc] init];
    
    info.strDate = [dict objectForKeyNotNull:@"publish_on" expectedClass:[NSString class]];
    info.strVideoUrl = [dict objectForKeyNotNull:@"video_url" expectedClass:[NSString class]];
    info.strId = [dict objectForKeyNotNull:@"id" expectedClass:[NSString class]];
    info.isWatched = [[dict objectForKeyNotNull:@"is_watched" expectedClass:[NSString class]] boolValue];
    info.strDescription = [dict objectForKeyNotNull:@"description" expectedClass:[NSString class]];
    info.strThumbImage = [dict objectForKeyNotNull:@"video_thumb" expectedClass:[NSString class]];
    info.strTitle = [dict objectForKeyNotNull:@"title" expectedClass:[NSString class]];
    
    info.strDescription  = [PFUtility convertHTML:info.strDescription];

    
    return info;
    
}


-(NSString *)convertHTML:(NSString *)html {
    
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
