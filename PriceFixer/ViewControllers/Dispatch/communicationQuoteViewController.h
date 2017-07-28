//
//  communicationQuoteViewController.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 27/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface communicationQuoteViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *backgroundViewForMessage;
    IBOutlet UIView *communicationQuotePopUpView;
    
    IBOutlet UILabel *CommunicationTitleLabel;

    
    IBOutlet UITextField *messageTextField;
    
    IBOutlet UITableView *messageTableView;
    
    NSMutableArray *messageArray;

    NSString *alertTitle;
    NSString *alertMessage;
    
    float valueForViewMoveUp;
    
    NSMutableArray   *listArray;


}

@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) NSString *strEmployeId;
@property (strong, nonatomic) NSString *strOrderCode;

@property (assign, nonatomic) BOOL fromOrder;


@end
