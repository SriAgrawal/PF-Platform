
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AlertCompletionBlock) (NSInteger index, NSString *buttonTitle);

@interface AlertView : NSObject

+(instancetype)sharedManager;

-(void)presentAlertWithTitle:(NSString*)title
                     message:(NSString*)message
         andButtonsWithTitle:(NSArray*)buttonTitles
                onController:(UIViewController*)controller
               dismissedWith:(AlertCompletionBlock)completionBlock;

-(void)displayInformativeAlertwithTitle:(NSString *)title andMessage:(NSString*)message onController:(UIViewController*)controller;

@end

