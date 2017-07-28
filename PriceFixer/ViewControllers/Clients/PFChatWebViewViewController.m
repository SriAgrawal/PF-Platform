//
//  PFChatWebViewViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 24/02/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFChatWebViewViewController.h"

@interface PFChatWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PFChatWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadHTMLString:self.htmlContent baseURL:nil];
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Cancel Button Action

- (IBAction)cancelButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
