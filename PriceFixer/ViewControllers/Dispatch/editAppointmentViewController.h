//
//  editAppointmentViewController.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 26/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@class PFDispatchModel;
@class PFInstallModel;

@protocol editAppointmentProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface editAppointmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    IBOutlet UITextField *quoteTextField;
    IBOutlet UITextField *dateTextField;
    IBOutlet UITextField *hourTextField;
    IBOutlet UITextField *minTextField;
    IBOutlet UITextField *AMTextField;

    IBOutlet UIView *backgroundViewForTextView;

    UITableView *quoteTableView;
    UITableView *hourTableView;
    UITableView *minTableView;
    UITableView *AMTableView;
    
    NSMutableArray *quoteArray;
    NSMutableArray *hourArray;
    NSMutableArray *minArray;
    NSMutableArray *AMArray;

    IBOutlet UIView *editAppointmentView;
    IBOutlet UITextView *messageTextView;

    NSString *alertTitle;
    NSString *alertMessage;
    NSString *tableviewIndicator;
    
    IBOutlet UIDatePicker *datePicker;
}
@property (strong, nonatomic) IBOutlet UIButton *quoteBtn;

@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *hourBtn;
@property (strong, nonatomic) IBOutlet UIButton *minButton;
@property (strong, nonatomic) IBOutlet UIButton *amPMButton;

@property (nonatomic,weak) id<editAppointmentProtocol> delegate;

- (IBAction)dateSelection:(id)sender;

- (IBAction)openQuoteTableView:(id)sender;
- (IBAction)openDatePickerTableView:(id)sender;


- (IBAction)HourSelection:(id)sender;
- (IBAction)minSelection:(id)sender;
- (IBAction)AMSelection:(id)sender;

- (IBAction)saveSelection:(id)sender;

@property (strong, nonatomic) NSString *strAppoinmentId;
@property (strong, nonatomic) NSString *strCrewId;

@property (strong, nonatomic) NSString *strShopId;
@property (strong, nonatomic) NSString *strAppoinmentDate;
@property (strong, nonatomic) NSString *strScreenIndicator;
@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) PFDispatchModel *obj_editDetail;

@property (strong, nonatomic) PFInstallModel *objEditDetail;
@property (assign,nonatomic) BOOL isFromTechCheck;
@property (assign,nonatomic) BOOL isFromTechCheckForEdit;

@property (assign,nonatomic) BOOL isFromRepair;




@end
