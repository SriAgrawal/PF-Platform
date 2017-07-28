//
//  PFWalkThroughSignatureViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 27/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol walkThroughProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface PFWalkThroughSignatureViewController : UIViewController

@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,weak)id<walkThroughProtocol> delegate;

@property (nonatomic,assign)BOOL fromEquipment;

@end
