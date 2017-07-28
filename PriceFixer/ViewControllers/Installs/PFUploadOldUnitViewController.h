//
//  PFUploadOldUnitViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 04/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol uploadEquipmentProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface PFUploadOldUnitViewController : UIViewController

@property (nonatomic,strong) NSString *parentId;
@property (nonatomic, strong) UIImage *img;

@property (nonatomic,assign) BOOL isOldPicture;
@property (nonatomic,weak) id <uploadEquipmentProtocol> delegate;

@end
