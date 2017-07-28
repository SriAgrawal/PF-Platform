//
//  PFCreateTicketInfo.h
//  PriceFixer
//
//  Created by Shridhar Agarwal on 19/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PFCreateTicketInfo : NSObject
@property (strong, nonatomic) NSString *strTicketTitle;
@property (strong, nonatomic) NSString *strTicketDescription;
@property (strong, nonatomic) NSString *strTicketPriority;
@property (strong, nonatomic) NSString *strTicketFileName;


@property (strong, nonatomic) UIImage *uploadImage;

@end
