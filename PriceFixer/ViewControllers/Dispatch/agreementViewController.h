//
//  agreementViewController.h
//  priceFixerApp
//
//  Created by Ashish Kumar Gupta on 27/07/16.
//  Copyright © 2016 Ashish Kumar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJRSignatureView.h"
@protocol changeAgreeMentProtocol <NSObject>

- (void)callTechCheckApi;

@end

typedef enum _repeatAgreementType{
    
    repeatAgreementType_ApprovedEquipment,
    repeatAgreementType_ApprovedLabour,
    repeatAgreementType_Dispach
}repeatAgreementType;

#import "Macro.h"

@interface agreementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIButton *termsReadButton;

    PJRSignatureView *signatureView;

    
    IBOutlet UITextView *textViewAgreement;
    
    IBOutlet UIView *backgroundViewForAgreement;
    IBOutlet UIView *agreementView;
    IBOutlet UIView *signatureBackGroundView;



    IBOutlet UITableView *yearTableView;
    IBOutlet UITableView *monthTableView;
    IBOutlet UITableView *productTableView;
    
    IBOutlet UITextField *credeitCardNameTextField;
    IBOutlet UITextField *credeitCardNumberTextField;
    IBOutlet UITextField *credeitCardCVVTextField;
    IBOutlet UITextField *credeitCardExpireMonTextField;
    IBOutlet UITextField *credeitCardExpireYearTextField;
    UITextField *itemTextField;
    UITextField *unitCostTextField;
    UITextField *unitLabelTextField;

    
    NSMutableArray *name;
    NSMutableArray *unitCost;
    NSMutableArray *unit;
    NSMutableArray *cost;
    NSMutableArray *arrayIndicator;
    NSMutableArray *monthArray;
    NSMutableArray *yearArray;

    
    
    NSString *checkForFirstTimeAddition;
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *tableviewIndicator;
    NSString *cityStateZip;
    NSString *address;
    NSString *customerJoiningDateString;
    

    
    int fetchedMothValue;

    NSArray *listArray;
    NSArray *itemListArray;
    
    IBOutlet UILabel *subTotalLabel;
    IBOutlet UILabel *TotalLabel;
    IBOutlet UILabel *taxTotal;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *customerJoiningDateLabel;
    IBOutlet UILabel *orderCodeAgreementLabel;
    IBOutlet UILabel *termsLabel;

    __weak IBOutlet UILabel *permitFeeLabel;

    float valueForViewMoveUp;
    float subTotalValue;
    float taxTotalValue;
    float totalValue;

  

}
@property (strong, nonatomic) NSString *strOrderId;
@property (strong, nonatomic) NSString *strOrderCode;
@property (strong, nonatomic) NSString *strParentID;
@property (assign, nonatomic) BOOL isFromApproveEquipment;//Change Variable Name
@property (assign, nonatomic) repeatAgreementType agreementViewType;

@property (strong, nonatomic) NSString *strParentOrderId;

@property (nonatomic,weak)id<changeAgreeMentProtocol> delegate;

@property (assign, nonatomic) BOOL isViewFromInstall;
@property (assign, nonatomic) BOOL isViewFromInstallFinalBill;
@property (assign, nonatomic) BOOL isViewFromRepairFinalBill;



- (IBAction)updateAction:(id)sender;

@end
