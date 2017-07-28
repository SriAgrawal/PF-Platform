//
//  PFTutorialVC.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 11/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFTutorialViewHeightMangageDelegate <NSObject>

-(void)tutorialViewHeight:(float)height;

@end
@interface PFTutorialVC : UIViewController
@property (nonatomic, strong) id <PFTutorialViewHeightMangageDelegate> delegate;

@end
