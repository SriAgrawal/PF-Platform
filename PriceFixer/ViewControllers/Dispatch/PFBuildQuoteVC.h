//
//  PFBuildQuoteVC.h
//  PriceFixer
//
//  Created by Tejas Pareek on 10/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFBuildQuoteVCDelegate <NSObject>

-(void)dismissControllerWith:(NSString *)quoteID;

@end
@interface PFBuildQuoteVC : UIViewController

@property(nonatomic,strong) NSString *zipCode;
@property (nonatomic, strong) id <PFBuildQuoteVCDelegate> delegate;
@end
