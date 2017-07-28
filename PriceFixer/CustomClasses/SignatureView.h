//
//  SignatureView.h
//  UserSignature
//
//  Created by Krati Agarwal on 25/03/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView

@property (nonatomic, retain) UIGestureRecognizer *theSwipeGesture;
@property (nonatomic, retain) UIImageView *drawImage;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) BOOL mouseSwiped;
@property (nonatomic, assign) NSInteger mouseMoved;

- (void)erase;
- (void)setSignature:(NSData *)theLastData;
- (BOOL)isSignatureWrite;

@end
