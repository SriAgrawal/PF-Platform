//
//  TextView.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TextView : UITextView {
    UILabel *_placeholderLabel;
}
@property (strong, nonatomic) NSString *placeholderText;
@property (strong, nonatomic) UIColor *placeholderColor;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
