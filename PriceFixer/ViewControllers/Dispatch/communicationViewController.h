//
//  communicationViewController.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 26/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@class TextView;

@protocol communicationProtocol <NSObject>

- (void)callTechCheckApi;

@end


@interface communicationViewController : UIViewController<UITextViewDelegate>

{
    IBOutlet UIView *backgroundViewForTextView;
    IBOutlet UITextField *userTextField;
    IBOutlet TextView *messageTextView;
    
    IBOutlet UIView *communicationPopUpView;
    
    NSString *selectedQuote;
    NSString *alertTitle;
    NSString *alertMessage;
    
    float valueForViewMoveUp;
    
    IBOutlet UILabel *CommunicationTitleLabel;
    IBOutlet UIButton *inRouteButton;
    IBOutlet UIButton *arrivedButton;
    IBOutlet UIButton *eightyPercentButton;
    IBOutlet UIButton *hundreadPercentButton;
    IBOutlet UIButton *installationSetButton;

    NSString *status;
    NSString *statusFromServer;
}

@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) NSString *strEmployeId;
@property (strong, nonatomic) NSString *strOrderCode;
@property (strong, nonatomic) NSString *strCustomerName;

@property (strong, nonatomic) NSString *strCurrentStatus;

@property (assign, nonatomic) BOOL fromInstall;
@property (assign, nonatomic) BOOL fromRepair;


@property (strong, nonatomic) NSString *strCompleteRoute;

@property (strong, nonatomic) id <communicationProtocol> delegate;



@end
