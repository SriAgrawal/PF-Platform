 //
//  BDServiceHelper.m
//  BlackDoctorApp
//
//  Created by Suresh patel on 19/05/16.
//  Copyright © 2016 mobiloitte. All rights reserved.
//

#import "BDServiceHelper.h"
#import "Macro.h"
#import "MBProgressHUD.h"
#import "BDConstants.h"

// local URL
//#define BASE_URL  @"http://172.16.0.9/PROJECTS/PriceFixer/trunk/shop-api/web_services.php"

//#define BASE_URL  @"http://www.pricefixertestserver.com/shop-api/web_services.php"

// staging URL
#define BASE_URL  @"http://pricefixertestserver.com/shop-api/web_services.php"
//Live URL

#define BASE_URLFORCLIENT  @"http://www.pricefixertestserver.com/shop-api/web_services_client.php"



#define kHudHideAnimationTime   0.0


@interface NSDictionary(JSONCategories)

+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData;
-(NSData*)toJSON;

@end
@interface BDServiceHelper () {
    
    MBProgressHUD *progressHUD;
    NSString *requestedApiName;
}

@end
@implementation NSDictionary(JSONCategories)
+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData
{
    __autoreleasing NSError* error = nil;
    if(JSONData == nil) {
        return [NSDictionary dictionary];
        
    }
    id result = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result ;
}

-(NSData*)toJSON
{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    if (error != nil) return nil;
    return result;
}
@end


@implementation BDServiceHelper
@synthesize downLoadedData;
@synthesize connection;
RequestComplitopnBlock  responseBlock;


static BDServiceHelper *helper = nil;

+(id)sharedInstance
{
    @synchronized(self) {
        
        if (!helper) {
            
            helper = [[BDServiceHelper alloc] init];
        }
    }
    return helper;
}

-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    requestedApiName = apiName;
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];

        responseBlock(nil,error);
        return;
    }
    
    
    NSMutableString *urlString = [NSMutableString stringWithString:BASE_URL];
    [urlString appendFormat:@"%@",apiName];
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        }
        else{
            [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSLog(@"request===%@",request);

    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSUSERDEFAULTS objectForKey:kApiToken] forHTTPHeaderField:@"X-CSRF-Token"];
    
    [request setHTTPBody:[NSData data]];
    [request setTimeoutInterval:10.0];
    
    [self setProgressHud:BDProgressNotShown];
    self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        downLoadedData = [NSMutableData data];
    }
    
    // Invoking which Progress Hud to appear on Screen
    [self setProgressHud:hud];
}

-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block
{

    requestedApiName = apiName;
    [self cancelConnection];
    
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
       
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message: @"Unable to connect network, Please check your internet connection" andButtonsWithTitle:@[@"OK"] onController:[APPDELEGATE navController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];

        responseBlock(nil,error);
        return;
    }
    
    NSString *urlString;
    
    if ([[parameterDict valueForKey:@"action"] isEqualToString:@"clientBillingInfo"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"stateAndCountry"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"updateBillingInfo"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"clientOrder"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"clientCommunication"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"dispatchList"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"searchCustomer"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"sendMessage"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"resetPassword"]||[[parameterDict valueForKey:@"action"] isEqualToString:@"preInspectionList"])
        urlString =[NSString stringWithFormat:@"%@%@", BASE_URLFORCLIENT, apiName];
    else
        urlString =[NSString stringWithFormat:@"%@%@", BASE_URL, apiName];
    
   // NSLog(@"urlString===%@",urlString);

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    NSLog(@"request===%@",request);
    if (parameterDict) {
        NSLog(@"REQUEST PARAMS: %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameterDict options:1 error:nil] encoding:4]);
    }
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[parameterDict toJSON]];
    [request setTimeoutInterval:45.0];
    
    self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        downLoadedData = [NSMutableData data];
    }
    
    // Invoking which Progress Hud to appear on Screen
    [self setProgressHud:hud];
}

-(void)PostAPIForMenuCallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block
{

    requestedApiName = apiName;
    [self cancelConnection];
    
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
     
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Information" andMessage:@"Unable to connect network, Please check your internet connection" onController:[APPDELEGATE navController]];
    
        responseBlock(nil,error);
        return;
    }
    
    NSString *urlString =[NSString stringWithFormat:@"%@%@", BASE_URL, apiName];
    
    NSLog(@"urlString===%@",urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"request===%@",request);

    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[parameterDict toJSON]];
    [request setTimeoutInterval:45.0];
    
    self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        downLoadedData = [NSMutableData data];
    }
    
    // Invoking which Progress Hud to appear on Screen
    //[self setProgressHud:hud];
}



-(void)GetInstamojoAPICallWithParameter:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName AndAuthToken:(NSString*)authToken WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    requestedApiName = apiName;
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        [[AlertView sharedManager] presentAlertWithTitle:@"" message: @"Unable to connect network, Please check your internet connection" andButtonsWithTitle:@[@"OK"] onController:[APPDELEGATE navController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];

        responseBlock(nil,error);
        return;
    }
    
    
    NSMutableString *urlString = [NSMutableString stringWithString:BASE_URL];
    
    if ([apiName containsString:@"token"]) {
        
        [urlString appendFormat:@"services/session/%@",apiName];
    }else
    {
        [urlString appendFormat:@"api/users/%@",apiName];
    }
    
    
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        }
        else{
            [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSUSERDEFAULTS objectForKey:kApiToken] forHTTPHeaderField:@"X-CSRF-Token"];
    
    [request setHTTPBody:[NSData data]];
    [request setTimeoutInterval:10.0];
    
    [self setProgressHud:BDProgressNotShown];
    self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        downLoadedData = [NSMutableData data];
        
    }
}

-(void)getListsFromClientSiteWithUrl:(NSString *)string AndAPIName:(NSString *)apiName withprogresHud:(BDProgressHud)hud WithComptionBlock:(RequestComplitopnBlock)block
{
    [self cancelConnection];
    
    requestedApiName = apiName;
    responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        responseBlock(nil,error);
        return;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:45.0];
    
    self.connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (self.connection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        downLoadedData = [NSMutableData data];
    }
    
    // Invoking which Progress Hud to appear on Screen
    [self setProgressHud:hud];
}

+(void)PostAPICallWithParameterNewConnection:(NSMutableDictionary *)parameterDict AndAPIName:(NSString *)apiName WithComptionBlock:(RequestComplitopnBlock)block
{
    
    RequestComplitopnBlock  responseBlock = [block copy];
    if(![APPDELEGATE isReachable])
    {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:101 userInfo:nil];
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message: @"Unable to connect network, Please check your internet connection" andButtonsWithTitle:@[@"OK"] onController:[APPDELEGATE navController] dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
        
        responseBlock(nil,error);
        return;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:BASE_URL];
    
    [urlString appendFormat:@"api/users/%@",apiName];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSUSERDEFAULTS objectForKey:kApiToken] forHTTPHeaderField:@"X-CSRF-Token"];
    
    [request setHTTPBody:[parameterDict toJSON]];
    [request setTimeoutInterval:45.0];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
        responseBlock(result,connectionError);
    }];
}

- (void)setProgressHud:(BDProgressHud)hud {
    progressHud = hud;
    switch (progressHud) {
        case BDProgressShown:
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];
        }
            break;
        case BDProgressNotShown:
            break;
        default:
            break;
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:    (NSURLProtectionSpace *)protectionSpace {
    // NSLog(@"canAuthenticateAgainstProtectionSpace:");
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential     credentialForTrust:challenge.protectionSpace.serverTrust]     forAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *responseString = [[NSString alloc] initWithData:downLoadedData encoding:NSUTF8StringEncoding];
    NSLog(@"response string ==%ld   %@",(long)responseCode,responseString);
    
    if ([requestedApiName containsString:kApiToken]) {
        
        [NSUSERDEFAULTS setObject:responseString forKey:kApiToken];
    }
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    if (responseCode == 200) {
        id result = [NSDictionary dictionaryWithContentsOfJSONURLData:downLoadedData];
        responseBlock(result,nil);
        
    }else if(responseCode == 401)
    {
        responseBlock(nil,[NSError errorWithDomain:@"com.jos" code:401 userInfo:nil]);
    }else
    {
        responseBlock(nil,[NSError errorWithDomain:@"com.jos" code:responseCode userInfo:nil]);
    }
    
    // [ISUtility enableGesture];
    progressHUD = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; 
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    progressHUD = nil;
    
    responseBlock(nil,error);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [downLoadedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    responseCode = (int)[HTTPResponse statusCode];
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    progressHUD = nil;
}

- (void)cancelConnection
{
    if(self.connection){
        [self.connection cancel];
        self.connection = nil;

    }
    [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
    progressHUD = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //  [ISUtility enableGesture];
}

@end
