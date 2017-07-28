//
//  ActionSheet.m
//  Softphone
//
//  Created by Sunil Verma on 27/11/15.
//  Copyright © 2015 Mobiloitte. All rights reserved.
//

#import "ActionSheet.h"

@interface ActionSheet () <UIActionSheetDelegate>

@property (nonatomic, strong) ActionSheetCompletionBlock completionBlock;

@end

@implementation ActionSheet

+(instancetype)sheetManager
{
    static ActionSheet *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(void)presentSheetWithTitle:(NSString*)title message:(NSString*)message cancelBttonTitle:(NSString *)cancelButtonTitle destrictiveButtonTitle:(NSString *)destructiveButtonTitle andButtonsWithTitle:(NSArray*)buttonTitles onController:(UIViewController*)controller dismissedWith:(ActionSheetCompletionBlock)completionBlock
{
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        NSLog(@"AlertView ERROR ==> Invalid button title!");
        return;
    }
    
    self.completionBlock = completionBlock;
    
    {

        //display UIAlertController
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        alertController.view.tintColor = [UIColor blackColor];
        NSInteger index = 0;
        for (index =0; index < buttonTitles.count; index++) {
            
            UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //  ActionSheetActionBLock
                self.completionBlock(index, action.title);
                
            }];
            [alertController addAction:buttonAction];
        }
        
  if (destructiveButtonTitle) {
            UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                //  ActionSheetActionBLock
                self.completionBlock(index, action.title);
                
            }];
            [alertController addAction:buttonAction];
      index++;
        }
        
        if (cancelButtonTitle) {
            UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //  ActionSheetActionBLock
                self.completionBlock(index, action.title);
                
            }];
            [alertController addAction:buttonAction];
            index++;
        }
        [controller presentViewController:alertController animated:YES completion:nil];
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.completionBlock(buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);

}

@end
