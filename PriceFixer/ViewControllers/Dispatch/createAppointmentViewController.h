//
//  createAppointmentViewController.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 28/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "PFInstallModel.h"
@class PFDispatchModel;

@protocol createAppointmentEquipmentProtocol <NSObject>

- (void)callTechCheckApi;

@end
@interface createAppointmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
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
    UITableView *crewTableView;

    
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
//- (IBAction)dateSelection:(id)sender;

- (IBAction)openQuoteTableView:(id)sender;
- (IBAction)openDatePickerTableView:(id)sender;


- (IBAction)HourSelection:(id)sender;
- (IBAction)minSelection:(id)sender;
- (IBAction)AMSelection:(id)sender;

- (IBAction)saveSelection:(id)sender;

@property (strong, nonatomic)IBOutlet UIImageView *dropDownImage;

@property (nonatomic,weak)id<createAppointmentEquipmentProtocol> delegate;

@property (strong, nonatomic) IBOutlet UIButton *quoteBtn;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *hourBtn;
@property (strong, nonatomic) IBOutlet UIButton *minButton;
@property (strong, nonatomic) IBOutlet UIButton *amPMButton;

@property (strong, nonatomic) PFDispatchModel *dispatchModel;
@property (strong, nonatomic) PFInstallModel *objEditDetail;

@property (strong, nonatomic) NSString *strAppOrderCode;
@property (assign, nonatomic) BOOL isFromCreateAppointmentBtn;
@property (assign, nonatomic) BOOL isFromEquipment;
@property (assign, nonatomic) BOOL isFromEquipmentSetDelivery;


@property (strong, nonatomic) NSString *strAppCustomerId;
@property (strong, nonatomic) NSString *strAppShopId;
@property (strong, nonatomic) NSString *strAppOrderId;
@property (strong, nonatomic) NSString *strScreenIndicator;

@end
