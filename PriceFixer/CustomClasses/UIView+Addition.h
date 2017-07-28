//
//  UIView+Addition.h
//  Cafe
//
//  Created by Raj Kumar Sharma on 01/03/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

@property (assign, nonatomic) IBInspectable CGFloat corner;
@property (assign, nonatomic) IBInspectable UIColor* borderColor;

- (void)corner:(UIColor *)borderColor borderWidth:(CGFloat)width cornerRadius:(CGFloat)radius;
- (void)dropShadowWithColor:(UIColor *)color;
- (void)flatShadowWithColor:(UIColor *)color;
- (void)vibrate;
- (void)shake;

@end
