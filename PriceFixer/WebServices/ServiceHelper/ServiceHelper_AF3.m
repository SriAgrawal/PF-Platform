//
//  ServiceHelper_AF3.m
//  MI_Columbia
//
//  Created by Yasmin Tahira on 5/31/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ServiceHelper_AF3.h"


@interface BDServiceHelper () {
    
    PFProgressHud *progressHUD;
    NSString *requestedApiName;
}

@end

@implementation ServiceHelper_AF3

static ServiceHelper_AF3 * serviceHelper = nil;

#pragma mark - Initialization Methods


+(id)instance {
    
    @synchronized(self) {
        
        if(!serviceHelper)
            serviceHelper = [[ServiceHelper_AF3 alloc] init];
            serviceHelper.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
         //serviceHelper.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URLFORCLIENT]];
            NSLog(@"%@",[NSURL URLWithString:BASE_URL]);
            [serviceHelper.manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
            [serviceHelper.manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
        
    }
    return serviceHelper;
}

-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    {
        
        if ([[dict valueForKey:@"action"] isEqualToString:@"productQuickLookup"] || [[dict valueForKey:@"action"] isEqualToString:@"searchCustomer"] || [[dict valueForKey:@"action"] isEqualToString:@"stateAndCountry"])
            [self setProgressHud:PFProgressNotShown];
        else
            [self setProgressHud:PFProgressShown];
        
        dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(globalConcurrentQueue, ^{
            
              NSLog(@"request: %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            
            [self.manager POST:strApi parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setProgressHud:PFProgressNotShown];

                    
  NSLog(@"response: %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);                    completionBlock(YES,nil,responseObject);
                });
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self setProgressHud:PFProgressNotShown];

                NSMutableDictionary *response = [NSMutableDictionary dictionary];
                [response setObject:error forKey:@"Error"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(NO,nil,response);
                });
            }];
        });
    }
}

-(void)makeWebApiCallWithGetParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock{
    
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalConcurrentQueue, ^{
        
        NSLog(@"request: %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
        
        
        
        [self.manager GET:strApi parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"response: %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);                    completionBlock(YES,nil,responseObject);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response setObject:error forKey:@"Error"];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil,response);
            });
        }];
    });
        
        }

- (void)makeMultipartWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi   andData:(NSData *)data mediaType:(NSInteger)mediaType WithCompletion:(ServiceCompletionBlock)completionBlock andProgresscompletion:(ProgressCompletionBlock)progressCompletionBlock
{

    [self setProgressHud:PFProgressShown];

    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalConcurrentQueue, ^{
        
        [self.manager POST:strApi parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if (data) {
                
                switch (mediaType) {
                    case 0:
                    {
                        NSString *keyName;
                        if ([[dict objectForKeyNotNull:@"action" expectedClass:[NSString class]] isEqualToString:@"uploadInstalledImages"]) {
                            keyName = KMEDIAFILEFORINSTALL;
                        }
                        else if ([[dict objectForKeyNotNull:@"action" expectedClass:[NSString class]] isEqualToString:@"uploadEquipmentOrderSignedImage"]) {
                            keyName = KMEDIAFILEFORWOLKTHROUGH;
                        }
                        else if ([[dict objectForKeyNotNull:@"action" expectedClass:[NSString class]] isEqualToString:@"createTicket"]) {
                            keyName = KMEDIAFILEFORCREATETICKET;
                        }

                        else {
                            keyName = KMEDIAFILE;
                        }
                        [formData appendPartWithFileData:data name:keyName fileName:@"image.jpg" mimeType:@"image/jpeg"];
                    }
                        break; 
                        
                    case 1:
                    {
                        [formData appendPartWithFileData:data name:KMEDIAFILE fileName:@"video.mp4" mimeType:@"video/mp4"];

                    }
                        break;
                        
                    default:
                        break;
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                progressCompletionBlock(uploadProgress.fractionCompleted);
            });
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setProgressHud:PFProgressNotShown];
                completionBlock(YES,nil,responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self setProgressHud:PFProgressNotShown];
            NSMutableDictionary *response = [NSMutableDictionary dictionary];
            [response setObject:error forKey:@"Error"];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(NO,nil,response);
            });
        }];
});

}


- (void)setProgressHud:(PFProgressHud)hud {
    progressHud = hud;
    switch (progressHud) {
        case BDProgressShown:
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];
        }
            break;
        case BDProgressNotShown:
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];

            break;
        default:
            break;
    }
}



@end
