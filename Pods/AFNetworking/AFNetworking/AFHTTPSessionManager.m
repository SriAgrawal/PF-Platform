// AFHTTPSessionManager.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFHTTPSessionManager.h"

#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

#import <Availability.h>
#import <TargetConditionals.h>
#import <Security/Security.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

// staging URL
#define BASE_URL  @"http://pricefixertestserver.com/shop-api/web_services.php"
//Live URL
#define BASE_URLFORCLIENT  @"http://pricefixertestserver.com/shop-api/web_services_client.php"
#define BASE_UPLOADURL  @"http://pricefixertestserver.com/shop-api/web_services_upload.php"


@interface AFHTTPSessionManager ()
@property (readwrite, nonatomic, strong) NSURL *baseURL;
@end

@implementation AFHTTPSessionManager
@dynamic responseSerializer;

+ (instancetype)manager {
    return [[[self class] alloc] initWithBaseURL:nil];
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (!self) {
        return nil;
    }

    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }

    self.baseURL = url;

    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

#pragma mark -

- (void)setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer {
    NSParameterAssert(requestSerializer);

    _requestSerializer = requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer {
    NSParameterAssert(responseSerializer);

    [super setResponseSerializer:responseSerializer];
}

#pragma mark -

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{

    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{

    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
                                                        URLString:URLString
                                                       parameters:parameters
                                                   uploadProgress:nil
                                                 downloadProgress:downloadProgress
                                                          success:success
                                                          failure:failure];

    [dataTask resume];

    return dataTask;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"HEAD" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, __unused id responseObject) {
        if (success) {
            success(task);
        }
    } failure:failure];

    [dataTask resume];

    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters uploadProgress:uploadProgress downloadProgress:nil success:success failure:failure];

    [dataTask resume];

    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    
    if([[parameters valueForKey:@"action"] isEqualToString:@"uploadOldEqPicture"]||[[parameters valueForKey:@"action"] isEqualToString:@"uploadInstalledImages"]||[[parameters valueForKey:@"action"] isEqualToString:@"uploadEquipmentOrderSignedImage"]||[[parameters valueForKey:@"action"] isEqualToString:@"createTicket"])
    {
        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", BASE_UPLOADURL]];
    }
    else
    {
        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", BASE_URL]];
    }

    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }

        return nil;
    }

    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];

    [dataTask resume];

    return dataTask;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];

    [dataTask resume];

    return dataTask;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];

    [dataTask resume];

    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    
    if ([[parameters valueForKey:@"action"] isEqualToString:@"clientBillingInfo"]||[[parameters valueForKey:@"action"] isEqualToString:@"stateAndCountry"]||[[parameters valueForKey:@"action"] isEqualToString:@"updateBillingInfo"]||[[parameters valueForKey:@"action"] isEqualToString:@"clientOrder"]||[[parameters valueForKey:@"action"] isEqualToString:@"clientCommunication"]||[[parameters valueForKey:@"action"] isEqualToString:@"dispatchList"]||[[parameters valueForKey:@"action"] isEqualToString:@"searchCustomer"]||[[parameters valueForKey:@"action"] isEqualToString:@"sendMessage"]||[[parameters valueForKey:@"action"] isEqualToString:@"resetPassword"]||[[parameters valueForKey:@"action"] isEqualToString:@"preInspectionList"]||[[parameters valueForKey:@"action"] isEqualToString:@"getInstallsList"]||[[parameters valueForKey:@"action"] isEqualToString:@"clientCommunication"]||[[parameters valueForKey:@"action"] isEqualToString:@"sendMessage"]||[[parameters valueForKey:@"action"] isEqualToString:@"productQuickLookup"]||[[parameters valueForKey:@"action"] isEqualToString:@"deleteEquipmentList"]||[[parameters valueForKey:@"action"] isEqualToString:@"changeOrderQty"]||[[parameters valueForKey:@"action"] isEqualToString:@"oldEquipmentPictures"]||[[parameters valueForKey:@"action"] isEqualToString:@"uploadOldEqPicture"]||[[parameters valueForKey:@"action"] isEqualToString:@"inRouteArrived"]||[[parameters valueForKey:@"action"] isEqualToString:@"changeOrderLineItem"]||[[parameters valueForKey:@"action"] isEqualToString:@"changeOrderLineItemCustom"]||[[parameters valueForKey:@"action"] isEqualToString:@"approveEquipment"]||[[parameters valueForKey:@"action"] isEqualToString:@"approveLabor"]||[[parameters valueForKey:@"action"] isEqualToString:@"setInstallation"]||[[parameters valueForKey:@"action"] isEqualToString:@"specialList"]||[[parameters valueForKey:@"action"] isEqualToString:@"changeOrderLineItemInstallSpecial"]||[[parameters valueForKey:@"action"] isEqualToString:@"menuCount"]||[[parameters valueForKey:@"action"] isEqualToString:@"equipmentList"]||[[parameters valueForKey:@"action"] isEqualToString:@"moveOrderFromPreInsp"]||[[parameters valueForKey:@"action"] isEqualToString:@"approveLaborStep"]||[[parameters valueForKey:@"action"] isEqualToString:@"cancelOrder"]||[[parameters valueForKey:@"action"] isEqualToString:@"createAppointment"]||[[parameters valueForKey:@"action"] isEqualToString:@"installList"]||[[parameters valueForKey:@"action"] isEqualToString:@"processFinalPaymentInstall"]||[[parameters valueForKey:@"action"] isEqualToString:@"installOrderArchive"]||[[parameters valueForKey:@"action"] isEqualToString:@"installedPicturesList"]||[[parameters valueForKey:@"action"] isEqualToString:@"sentMessageApt"]||[[parameters valueForKey:@"action"] isEqualToString:@"quoteList"]||[[parameters valueForKey:@"action"] isEqualToString:@"orderList"]||[[parameters valueForKey:@"action"] isEqualToString:@"repairList"]||[[parameters valueForKey:@"action"] isEqualToString:@"editQuote"]||[[parameters valueForKey:@"action"] isEqualToString:@"equipment"]||[[parameters valueForKey:@"action"] isEqualToString:@"repairClientAddress"]||[[parameters valueForKey:@"action"] isEqualToString:@"updateRepairAddressInfo"]||[[parameters valueForKey:@"action"] isEqualToString:@"emailAndText"]||[[parameters valueForKey:@"action"] isEqualToString:@"claim"]||[[parameters valueForKey:@"action"] isEqualToString:@"equipmentInRoute"]||[[parameters valueForKey:@"action"] isEqualToString:@"equipmentOrderArchive"]||[[parameters valueForKey:@"action"] isEqualToString:@"claimEquipmentOrder"]||[[parameters valueForKey:@"action"] isEqualToString:@"markeEquipmentDelivered"]||[[parameters valueForKey:@"action"] isEqualToString:@"setEquipmentOrderDelivery"]||[[parameters valueForKey:@"action"] isEqualToString:@"processReturnDetail"]||[[parameters valueForKey:@"action"] isEqualToString:@"processReturns"]||[[parameters valueForKey:@"action"] isEqualToString:@"updateCartItems"]||[[parameters valueForKey:@"action"] isEqualToString:@"removeCart"]||[[parameters valueForKey:@"action"] isEqualToString:@"saveQuoteNotes"]||[[parameters valueForKey:@"action"] isEqualToString:@"resentQuoteEmail"]||[[parameters valueForKey:@"action"] isEqualToString:@"declineOptionalComp"]||[[parameters valueForKey:@"action"] isEqualToString:@"getBySqrFootage"]||[[parameters valueForKey:@"action"] isEqualToString:@"addCart"]||[[parameters valueForKey:@"action"] isEqualToString:@"sendCartQuote"]||[[parameters valueForKey:@"action"] isEqualToString:@"unRepairableOrder"]||[[parameters valueForKey:@"action"] isEqualToString:@"repairInRoute"]||[[parameters valueForKey:@"action"] isEqualToString:@"markOrderArchive"]||[[parameters valueForKey:@"action"] isEqualToString:@"cancelMainOrder"]||[[parameters valueForKey:@"action"] isEqualToString:@"getShopByZipCode"]|[[parameters valueForKey:@"action"] isEqualToString:@"supportFaq"]|[[parameters valueForKey:@"action"] isEqualToString:@"supportTickets"]|[[parameters valueForKey:@"action"] isEqualToString:@"ticketDetail"]|[[parameters valueForKey:@"action"] isEqualToString:@"closeTicket"]|[[parameters valueForKey:@"action"] isEqualToString:@"supportTutorials"]|[[parameters valueForKey:@"action"] isEqualToString:@"sendNewMessage"])

        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", BASE_URLFORCLIENT]];
    else
        self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", BASE_URL]];

    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }

        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];

    return dataTask;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, baseURL: %@, session: %@, operationQueue: %@>", NSStringFromClass([self class]), self, [self.baseURL absoluteString], self.session, self.operationQueue];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSURL *baseURL = [decoder decodeObjectOfClass:[NSURL class] forKey:NSStringFromSelector(@selector(baseURL))];
    NSURLSessionConfiguration *configuration = [decoder decodeObjectOfClass:[NSURLSessionConfiguration class] forKey:@"sessionConfiguration"];
    if (!configuration) {
        NSString *configurationIdentifier = [decoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
        if (configurationIdentifier) {
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 1100)
            configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configurationIdentifier];
#else
            configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:configurationIdentifier];
#endif
        }
    }
    self = [self initWithBaseURL:baseURL sessionConfiguration:configuration];
    if (!self) {
        return nil;
    }

    self.requestSerializer = [decoder decodeObjectOfClass:[AFHTTPRequestSerializer class] forKey:NSStringFromSelector(@selector(requestSerializer))];
    self.responseSerializer = [decoder decodeObjectOfClass:[AFHTTPResponseSerializer class] forKey:NSStringFromSelector(@selector(responseSerializer))];
    AFSecurityPolicy *decodedPolicy = [decoder decodeObjectOfClass:[AFSecurityPolicy class] forKey:NSStringFromSelector(@selector(securityPolicy))];
    if (decodedPolicy) {
        self.securityPolicy = decodedPolicy;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    [coder encodeObject:self.baseURL forKey:NSStringFromSelector(@selector(baseURL))];
    if ([self.session.configuration conformsToProtocol:@protocol(NSCoding)]) {
        [coder encodeObject:self.session.configuration forKey:@"sessionConfiguration"];
    } else {
        [coder encodeObject:self.session.configuration.identifier forKey:@"identifier"];
    }
    [coder encodeObject:self.requestSerializer forKey:NSStringFromSelector(@selector(requestSerializer))];
    [coder encodeObject:self.responseSerializer forKey:NSStringFromSelector(@selector(responseSerializer))];
    [coder encodeObject:self.securityPolicy forKey:NSStringFromSelector(@selector(securityPolicy))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    AFHTTPSessionManager *HTTPClient = [[[self class] allocWithZone:zone] initWithBaseURL:self.baseURL sessionConfiguration:self.session.configuration];

    HTTPClient.requestSerializer = [self.requestSerializer copyWithZone:zone];
    HTTPClient.responseSerializer = [self.responseSerializer copyWithZone:zone];
    HTTPClient.securityPolicy = [self.securityPolicy copyWithZone:zone];
    return HTTPClient;
}

@end
