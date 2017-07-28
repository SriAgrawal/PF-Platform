//
//  PFAppointmentModel.m
//  PriceFixer
//
//  Created by Yogita Joshi on 29/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFAppointmentModel.h"

@implementation PFAppointmentModel


+(PFAppointmentModel*)getPaymentInfo:(id)dict {
    
    PFAppointmentModel *obj = [PFAppointmentModel new];
    obj.strIs_expire = [dict objectForKeyNotNull:@"is_expire" expectedClass:[NSString class]];
    obj.strCredit_card_person = [dict objectForKeyNotNull:@"credit_card_person" expectedClass:[NSString class]];
    obj.strCredit_card_number = [dict objectForKeyNotNull:@"credit_card_number" expectedClass:[NSString class]];
    
    obj.strCharged_today = [dict objectForKeyNotNull:@"charged_today" expectedClass:[NSString class]];
    obj.strCvv = [dict objectForKeyNotNull:@"cvv" expectedClass:[NSString class]];
    obj.strCredit_card_month = [dict objectForKeyNotNull:@"credit_card_month" expectedClass:[NSString class]];
    obj.strCredit_card_year = [dict objectForKeyNotNull:@"credit_card_year" expectedClass:[NSString class]];
    obj.strRefund = [dict objectForKeyNotNull:@"refund" expectedClass:[NSString class]];
    obj.strCharged_at_completion = [dict objectForKeyNotNull:@"charged_at_completion" expectedClass:[NSString class]];

    return obj;
}


@end
