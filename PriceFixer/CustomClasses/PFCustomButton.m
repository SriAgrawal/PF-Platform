//
//  PFCustomButton.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFCustomButton.h"

@implementation PFCustomButton

+(UIImage *)bgImage {
    static dispatch_once_t pred;
    static UIImage *shared = nil;
    dispatch_once(&pred, ^{
        shared = [PFCustomButton imageFromColor:KAppGreenColor];
        
    });
    return shared;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    //setting bg image
    UIImage *img = [[PFCustomButton bgImage] resizableImageWithCapInsets:UIEdgeInsetsMake(24.f, 30.f, 24.f, 30.f)];
    [self setBackgroundImage:img forState:UIControlStateNormal];
    
    // clearing any background from nib
    [self setBackgroundColor:[UIColor clearColor]];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = KAppBorderColor.CGColor;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.layer.masksToBounds = YES;
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+(UIImage*)imageFromColor:(UIColor*) color{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
