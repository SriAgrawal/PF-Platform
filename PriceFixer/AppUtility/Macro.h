//
//  Macro.h
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#define APPDELEGATE               (AppDelegate *) [[UIApplication sharedApplication] delegate]
#define TRIM_SPACE(str)           [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define WINDOWHEIGHT              [UIScreen mainScreen].bounds.size.height
#define WINDOWWIDTH               [UIScreen mainScreen].bounds.size.width
#define NSUSERDEFAULTS            [NSUserDefaults standardUserDefaults]



#define IS_OS_8_OR_LATER          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


#define TNTextField(tag)          (UITextField*)[self.view viewWithTag:tag]
#define TNButton(tag)             (UIButton*)[self.view viewWithTag:(tag)]
#define FFTextField(tag)          (UITextField*)[self.view viewWithTag:tag]
#define FFButton(tag)             (UIButton*)[self.view viewWithTag:(tag)]
#define FFUILabel(tag)            (UILabel*)[self.view viewWithTag:tag]
#define FFLabel(tag)              (UILabel*)[self.view viewWithTag:tag]



#define kAppColor                 [UIColor colorWithRed:60.0/255 green:203.0/255 blue:134.0/255 alpha:1]
#define KAppGreenColor [UIColor colorWithRed:120.0/255.0f green:190.0/255.0f blue:48.0/255.0f alpha:1.0f]
#define KAppBorderColor [UIColor clearColor]

#define KBtnSelectedColor [UIColor colorWithRed:18.0/255.0f green:33.0/255.0f blue:66.0/255.0f alpha:1.0f]


#define KHomeTextFieldBorderColor [[UIColor colorWithRed:85.0/255.0 green:158.0/255.0 blue:227.0/255.0 alpha:0.5] CGColor];
#define KHomeTextFieldGrayBorderColor [[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.6] CGColor];




#define AppFontItalic(X)            [UIFont fontWithName:@"Helvetica" size:X]
#define AppFontMediumItalic(X)      [UIFont fontWithName:@"Helvetica" size:X]
#define AppNavTitleFont(X)          [UIFont fontWithName:@"Helvetica" size:X]
#define AppFontBold(X)              [UIFont fontWithName:@"Helvetica" size:X]
#define AppSemiBoldFont(X)          [UIFont fontWithName:@"Helvetica" size:X]
#define AppFont(X)                  [UIFont fontWithName:@"Helvetica" size:X]
#define AppLightFont(X)             [UIFont fontWithName:@"Helvetica-Light" size:X]


#define RGBCOLOR(r,g,b,a)           [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define KMEDIAFILE                 @"old_pic"
#define KMEDIAFILEFORINSTALL       @"ins_file"
#define KMEDIAFILEFORWOLKTHROUGH   @"file_upload"

#define KMEDIAFILEFORCREATETICKET   @"tfile"

#define Kblankzipcode               @"Please enter zip code."
#define KInvalidzipcode             @"Zip code must be at least 4 digits."
#define KlogoutMessage              @"Are you sure you want to logout?"
#define KlogoutTitle                @"Logout"


#define windowHeight            [UIScreen mainScreen].bounds.size.height
#define windowWidth             [UIScreen mainScreen].bounds.size.width

#import "BDConstants.h"
#import "BDServiceHelper.h"
#import "Reachability.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "ServiceHelper_AF3.h"
#import "PFUtility.h"
#import "NSDictionary+NullChecker.h"

#import "ActionSheet.h"


//****************** View Controllers *******************//
#import "AppDelegate.h"
#import "PFLoginVC.h"
#import "PFChangePasswordVC.h"
#import "PFDispatchVC.h"
#import "PFLeftMenuVC.h"
#import "ViewController.h"
#import "editAppointmentViewController.h"
#import "communicationViewController.h"
#import "communicationQuoteViewController.h"
#import "agreementViewController.h"
#import "createAppointmentViewController.h"
#import "PFSendMessageVC.h"
#import "PFClientVC.h"
#import "PFPreInspectionVC.h"
#import "PFInstallVC.h"
#import "PFAddLineItemVC.h"
#import "PFOrderInvoiceVC.h"
#import "PFChangeInstallationHourVC.h"
#import "PFInstallProductDetailVC.h"
#import "PFEmployeeVC.h"
#import "PFClientOrderViewController.h"
#import "PFBuildQuoteVC.h"
#import "PFOrderViewController.h"
#import "PFQuotesVC.h"
#import "PFRepairViewController.h"
#import "PFQuotesBuildViewController.h"
#import "PFEquipmentClaimViewController.h"
#import "PFEquipmentWarehouseViewController.h"
#import "PFProcessReturnsVC.h"
#import "PFWalkThroughSignatureViewController.h"
#import "PFSendQuoteFromEditViewController.h"
#import "PFVideoPlayerViewController.h"


#import "PFInstallsMainTVC.h"
#import "PFOrderDetailTVC.h"
#import "PFSetTechCheckViewController.h"
#import "PFAddEquipmentVC.h"
#import "PFAddSpecialHoursViewController.h"
#import "PFDeleteEquipmentViewController.h"
#import "PFShowSignedImageViewController.h"
#import "PFInstallPictureViewController.h"
#import "PFViewSignedViewController.h"
#import "PFSupportViewController.h"
#import "PFTutorialNewVC.h"
#import "PFTutorialVC.h"
#import "PFTicketVC.h"
#import "PFFaqVC.h"
#import "PFTicketDetailsVC.h"

//******************* Modal class ***********************//
#import "UserInfo.h"
#import "PFAppointmentModel.h"
#import "PFDispatchModel.h"
#import "Pagination.h"
#import "PFPreInspectionModel.h"
#import "PFOrderInvoiceModel.h"
#import "PFInstallModel.h"
#import "PFClientModelInfo.h"
#import "PFQuotesListInfo.h"
#import "PFTutorialInfo.h"


//******************* Cells *****************************//
#import "PFResetPasswordCell.h"
#import "PFLeftMenuCell.h"
#import "PFDispatchCell.h"
#import "PFCollectionCell.h"
#import "communicationQuoteTableViewCell.h"
#import "PFPreinspectionCell.h"
#import "PFProdeuctCell.h"
#import "PFInstallproductCell.h"
#import "PFInstallCell.h"
#import "PFInvoiceCell.h"
#import "PFInstallationHourCell.h"
#import "PFInstallProductDetailCell.h"
#import "PFClientOrderTableViewCell.h"
#import "PFQuotesStepsTVC.h"
#import "PFQuotesStepForTVC.h"
#import "PFQuotesNotesTVC.h"
#import "PFProcessReturnsTVC.h"
#import "PFDropDownTableCell.h"
#import "PFTutorialCollectionCell.h"
#import "PFTicketMessageCell.h"

//******************** Utility Class*********************//


//******************** Custom Classes ***********************//
#import "TPKeyboardAvoidingCollectionView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "UIView+Addition.h"
#import "AlertView.h"
#import "MZFormSheetController.h"
#import "TextView.h"
#import "TAIndexPathButton.h"
#import "PFButton.h"
#import "TextField.h"

//******************** Framworks ***********************//

#import <CoreLocation/CoreLocation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#endif /* Macro_h */
