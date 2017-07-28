//
//  ActionSheet.h
//  Softphone
//
//  Created by Sunil Verma on 27/11/15.
//  Copyright © 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ActionSheetCompletionBlock) (NSInteger index, NSString *buttonTitle);

@interface ActionSheet : NSObject



+(instancetype)sheetManager;

-(void)presentSheetWithTitle:(NSString*)title message:(NSString*)message cancelBttonTitle:(NSString *)cancelButtonTitle destrictiveButtonTitle:(NSString *)destructiveButtonTitle andButtonsWithTitle:(NSArray*)buttonTitles onController:(UIViewController*)controller dismissedWith:(ActionSheetCompletionBlock)completionBlock;


@end
