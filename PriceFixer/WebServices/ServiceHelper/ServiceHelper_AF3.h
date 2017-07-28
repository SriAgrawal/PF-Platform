//
//  ServiceHelper_AF3.h
//  MI_Columbia
//
//  Created by Yasmin Tahira on 5/31/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Macro.h"
#import "MBProgressHUD.h"



typedef enum {
    PFProgressNotShown = 0,
    PFProgressShown = 1
    
} PFProgressHud;

@class PFAppUserInfo;

//#define SERVICE_BASE_URL @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/MICOLUMBIA/trunk/api"

//Staging URL
//#define SERVICE_BASE_URL @"http://ec2-52-76-162-65.ap-southeast-1.compute.amazonaws.com:4001/"

// staging URL
#define BASE_URL  @"http://pricefixertestserver.com/shop-api/web_services.php"
//Live URL

//#define BASE_URLFORCLIENT  @"http://www.pricefixertestserver.com/shop-api/web_services_client.php"

static NSString * apiSignup = @"signup.php";

typedef void (^ServiceCompletionBlock)(BOOL suceeded, NSString *error,id response);
typedef void (^ProgressCompletionBlock)(double fractionCompleted);

@interface ServiceHelper_AF3 : NSObject{
    
    PFProgressHud progressHud;

}

@property (strong,nonatomic) ServiceCompletionBlock completionBlock;

@property (strong,nonatomic) AFHTTPSessionManager *manager;

+(id)instance;

-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
-(void)makeWebApiCallWithGetParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
- (void)makeMultipartWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi   andData:(NSData *)data mediaType:(NSInteger)mediaType WithCompletion:(ServiceCompletionBlock)completionBlock andProgresscompletion:(ProgressCompletionBlock)progressCompletionBlock;


@end
