//
//  PFSendproposalViewController.h
//  PriceFixer
//
//  Created by Deepak Chauhan on 07/04/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setBuildQuoteProtocol <NSObject>

- (void)callBuildQuote:(NSString*)zipCode;

@end

@interface PFSendproposalViewController : UIViewController
@property (nonatomic,weak) id <setBuildQuoteProtocol> delegate;


@end
