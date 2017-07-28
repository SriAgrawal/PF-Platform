//
//  SignatureView.m
//  UserSignature
//
//  Created by Krati Agarwal on 25/03/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "SignatureView.h"

@implementation SignatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        self.drawImage = [[UIImageView alloc] initWithImage:nil];
        self.drawImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.drawImage];
        self.backgroundColor = [UIColor whiteColor];
        self.mouseMoved = 0;
    }
    return self;
}

#pragma mark touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches)
    {
        NSArray *array = touch.gestureRecognizers;
        for (UIGestureRecognizer *gesture in array)
        {
            if (gesture.enabled & [gesture isMemberOfClass:[UISwipeGestureRecognizer class]])
            {
                gesture.enabled = NO;
                self.theSwipeGesture = gesture;
            }
        }
    }
    
    self.mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    
    self.lastPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.mouseSwiped = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.lastPoint = currentPoint;
    
    self.mouseMoved++;
    
    if (self.mouseMoved == 10) {
        self.mouseMoved = 0;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.mouseSwiped)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    self.theSwipeGesture.enabled = YES;
    self.mouseSwiped = YES;
}

#pragma mark Methods

- (void)erase
{
    self.mouseSwiped = NO;
    self.drawImage.image = nil;
}

- (void)setSignature:(NSData *)theLastData
{
    UIImage *image = [UIImage imageWithData:theLastData];
    if (image != nil)
    {
        self.drawImage.image = [UIImage imageWithData:theLastData];
        self.mouseSwiped = YES;
    }
}

- (BOOL)isSignatureWrite
{
    return self.mouseSwiped;
}

@end
