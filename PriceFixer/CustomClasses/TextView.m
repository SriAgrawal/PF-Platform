//
//  TextView.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "TextView.h"

@implementation TextView

#pragma mark - init & dealloc
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _placeholderColor = [UIColor lightGrayColor];
    [self layoutGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -

#pragma mark - Notification center
- (void)textChanged:(NSNotification *)notification {
    if (notification.object == self)
        [self layoutGUI];
}
#pragma mark -

#pragma mark - layoutGUI
- (void)layoutGUI {
    _placeholderLabel.alpha = [self.text length] > 0 || [_placeholderText length] == 0 ? 0 : 1;
}
#pragma mark -

#pragma mark - Setters
- (void)setText:(NSString *)text {
    [super setText:text];
    [self layoutGUI];
}

- (void)setPlaceholderText:(NSString*)placeholderText {
    _placeholderText = placeholderText;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor*)color {
    _placeholderColor = color;
    [self setNeedsDisplay];
}
#pragma mark -

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    if ([_placeholderText length] > 0) {
        if (!_placeholderLabel) {
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, self.bounds.size.width - 16, 0)];
            _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeholderLabel.numberOfLines = 0;
            _placeholderLabel.font = self.font;
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            _placeholderLabel.alpha = 0;
            [self addSubview:_placeholderLabel];
        }
        self.textColor = [UIColor blackColor];
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.textColor = _placeholderColor;
        [_placeholderLabel sizeToFit];
        [self sendSubviewToBack:_placeholderLabel];
    }
    
    [self layoutGUI];
    [super drawRect:rect];
}
#pragma mark -


@end
