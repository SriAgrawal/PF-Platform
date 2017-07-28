//
//  ViewController.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 26/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol editAddressProtocol <NSObject>

- (void)callTechCheckApi;

@end

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIView *editAddressView;
    IBOutlet UITextField *address1TextField;
    IBOutlet UITextField *address2TextField;
    IBOutlet UITextField *cityTextField;
    IBOutlet UITextField *stateTextField;
    IBOutlet UITextField *zipTextField;
    IBOutlet UITextField *countryTextField;
    IBOutlet UITextField *phoneTextField;
    
    IBOutlet UITableView *stateTableView;
    UITableView *countryTableView;
    NSMutableArray *stateArray;
    NSMutableArray *countryArray;

    
    NSString *alertTitle;
    NSString *alertMessage;
    
    NSString *tableviewIndicator;
    
    float valueForViewMoveUp;


}
- (IBAction)hideTableView:(id)sender;
- (IBAction)openTableView:(id)sender;
- (IBAction)openCountryTableView:(id)sender;

- (IBAction)closePopUpAction:(id)sender;
- (IBAction)updateAction:(id)sender;


@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) id <editAddressProtocol> delegate;

@property (assign, nonatomic) BOOL fromRepair;


@end

