//
//  BDServiceHelper.h
//  BlackDoctorApp
//
//  Created by Suresh patel on 19/05/16.
//  Copyright © 2016 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NullChecker.h"


@class RDUtility;


typedef struct Page {
    NSInteger startIndex;
    NSInteger pageSize;
} PAGE;

typedef enum {
    BDProgressNotShown = 0,
    BDProgressShown = 1
    
} BDProgressHud;

typedef void(^RequestComplitopnBlock)(id result, NSError  *error);

@interface BDServiceHelper : NSObject<NSURLConnectionDelegate>
{
    NSInteger responseCode;
    BDProgressHud progressHud;
    
}
@property (nonatomic, strong)    NSMutableData		   *downLoadedData;
@property (nonatomic, strong)    NSURLConnection       *connection;

+(id)sharedInstance;

-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block;

-(void)PostAPIForMenuCallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block;

-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block;
+(void)PostAPICallWithParameterNewConnection:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block;

- (void)cancelConnection;
-(void)GetInstamojoAPICallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName AndAuthToken:(NSString*)authToken WithComptionBlock:(RequestComplitopnBlock)block;
-(void)getListsFromClientSiteWithUrl:(NSString *)string AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block;

@end
