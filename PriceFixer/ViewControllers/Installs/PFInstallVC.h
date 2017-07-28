//
//  PFInstallVC.h
//  PriceFixer
//
//  Created by Yogita Joshi on 04/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

typedef enum _repeatViewType{

    RepeatViewType_TypeCheck,
    RepeatViewType_Install,
    RepeatViewType_Equipment,
    RepeatViewType_Repair

}repeatViewType;


@interface PFInstallVC : UIViewController
{
    NSMutableArray *installListArray;
    
    NSString *cityStateZip;
    NSString *address;
    
    BOOL isAnimated;
}
@property (assign, nonatomic) repeatViewType viewType;


@end
