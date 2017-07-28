//
//  PFAddNewCustomerViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 16/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addNewClientProtocol <NSObject>

- (void)backToClientVC;

@end

@interface PFAddNewCustomerViewController : UIViewController

@property(nonatomic,strong) id<addNewClientProtocol> delegate;

@end
