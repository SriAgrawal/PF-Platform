//
//  UIView+Addition.m
//  Cafe
//
//  Created by Raj Kumar Sharma on 01/03/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

@dynamic corner;
@dynamic borderColor;

- (void)corner:(UIColor *)borderColor borderWidth:(CGFloat)width cornerRadius:(CGFloat)radius {
    [self.layer setBorderColor:[borderColor CGColor]];
    [self.layer setBorderWidth:width];
    [self.layer setCornerRadius:radius];
    [self setClipsToBounds:YES];
}

- (void)setCorner:(CGFloat)corner {
    [self.layer setCornerRadius:corner];
    [self setClipsToBounds:YES];
}

- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
    [self.layer setBorderWidth:2.0f];
}

- (void)dropShadowWithColor:(UIColor *)color {
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
}
- (void)flatShadowWithColor:(UIColor *)color {
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
}
- (void)vibrate {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.repeatCount = 3;
    animation.duration = 0.1;
    animation.speed = 2.0;
    animation.autoreverses = YES;

    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 2.0, self.center.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 2.0, self.center.y)];

    [self.layer addAnimation:animation forKey:animation.keyPath];
    
}
- (void)shake {
    self.transform = CGAffineTransformMakeTranslation(5, 5);
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTransform:CGAffineTransformIdentity];
    } completion:nil];
    
}

@end
