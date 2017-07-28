//
//  AppDelegate.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "AppDelegate.h"
#import "PFUploadOldUnitViewController.h"
#import "PFAddSpecialHoursViewController.h"


@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate
@synthesize signatureViewTappedIndicator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.navController setNavigationBarHidden:YES];
    self.navController = [[UINavigationController alloc] initWithRootViewController:[[PFLoginVC alloc] initWithNibName:@"PFLoginVC" bundle:nil]];
    
    [self.window setRootViewController:self.navController];
    [self.window makeKeyAndVisible];
    
    [self checkReachability];
    [self getUserLocation];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

-(void)navigateToLoginVC {
    PFLoginVC *loginVC = [[PFLoginVC alloc] initWithNibName:@"PFLoginVC" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = self.navController;
    [self.navController setNavigationBarHidden:YES];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getUserLocation {

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocation Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    self.currentLocation = newLocation;
    [self.locationManager stopUpdatingLocation];

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    self.currentLocation = nil;
}


/*
 Adding Reveal View
 */
-(JASidePanelController *)addRevealView {
    self.viewController = nil;

    [self.navController setNavigationBarHidden:YES];
    self.homeVC = [[PFDispatchVC alloc] initWithNibName:@"PFDispatchVC" bundle:nil];
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.centerPanel = [[UINavigationController alloc]initWithRootViewController:self.homeVC];

    self.viewController.leftPanel = [[PFLeftMenuVC alloc] initWithNibName:@"PFLeftMenuVC" bundle:nil];
    self.viewController.rightPanel = nil;
    return self.viewController;
}

-(void)checkReachability {

    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
        });
    };
    
    [reach startNotifier];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"register %@",error.localizedDescription);
    [NSUSERDEFAULTS setObject:@"20b508443fe01ae1a9452a8da88bdbdb1f5a7a4ef49e55f214b90cef2afc7cdc" forKey:kDeviceToken];
    [NSUSERDEFAULTS synchronize];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [NSUSERDEFAULTS setObject:token forKey:kDeviceToken];
    [NSUSERDEFAULTS synchronize];
}

@end
