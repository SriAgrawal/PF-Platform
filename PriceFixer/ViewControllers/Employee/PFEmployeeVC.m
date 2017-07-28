//
//  PFEmployeeVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 11/08/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFEmployeeVC.h"

@interface PFEmployeeVC ()

@end

@implementation PFEmployeeVC

#pragma mark - View controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark -

#pragma mark - Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

@end
