//
//  agreementTextViewController.h
//  PriceFixer
//
//  Created by Ashish Kumar Gupta on 05/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface agreementTextViewController : UIViewController
{
    IBOutlet UIView *agreementView;
    
    IBOutlet UILabel *orderCodeAgreementLabel;
    
    IBOutlet UITextView *textViewAgreement;

}
@property(nonatomic,retain)NSString *agreementTextString;
@property (strong, nonatomic) NSString *strOrderCode;
@end
