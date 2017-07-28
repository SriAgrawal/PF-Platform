//
//  AppDelegate.h
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "MZFormSheetController.h"
#import <CoreLocation/CoreLocation.h>
#import "PFUploadOldUnitViewController.h"

@class JASidePanelController;
@class PFDispatchVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) JASidePanelController  *viewController;
@property (strong, nonatomic) PFDispatchVC           *homeVC;
@property (strong, nonatomic) MZFormSheetController  *formSheet;

@property (nonatomic, strong) CLLocationManager       * locationManager;
@property (nonatomic, strong) CLLocation              * currentLocation;
@property (strong, nonatomic) NSString                * strAddress;
@property (strong, nonatomic) NSString                * strAddressCity;
@property (strong, nonatomic) NSString                * strAddressState;
@property (strong, nonatomic) NSString                * stirngLocation;

@property (strong, nonatomic) NSString                * signatureViewTappedIndicator;
@property (nonatomic, assign) BOOL                   isReachable;

@property (nonatomic, assign) BOOL                   restrictRotation;


-(JASidePanelController *)addRevealView;
-(void)navigateToLoginVC;

@end

