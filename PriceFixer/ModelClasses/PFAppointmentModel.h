//
//  PFAppointmentModel.h
//  PriceFixer
//
//  Created by Yogita Joshi on 29/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface PFAppointmentModel : NSObject

@property(strong,nonatomic) NSString * strQuote;
@property(strong,nonatomic) NSString * strDate;
@property(strong,nonatomic) NSString * strHour;
@property(strong,nonatomic) NSString * strMin;
@property(strong,nonatomic) NSString * strAM;
@property(strong,nonatomic) NSString * strExpireMonth;
@property(strong,nonatomic) NSString * strExpireYear;

@property(strong,nonatomic) NSString * strIs_expire;
@property(strong,nonatomic) NSString * strCredit_card_person;
@property(strong,nonatomic) NSString * strCredit_card_number;
@property(strong,nonatomic) NSString * strCvv;
@property(strong,nonatomic) NSString * strCredit_card_month;
@property(strong,nonatomic) NSString * strCredit_card_year;
@property(strong,nonatomic) NSString * strCharged_today;
@property(strong,nonatomic) NSString * strRefund;
@property(strong,nonatomic) NSString * strCharged_at_completion;

+(PFAppointmentModel*)getPaymentInfo:(id)dict;

@end




