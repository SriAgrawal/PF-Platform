//
//  PFLoginVC.m
//  PriceFixer
//
//  Created by Yogita Joshi on 26/07/16.
//  Copyright © 2016 Yogita Joshi. All rights reserved.
//

#import "PFLoginVC.h"
#import "PFResetPasswordViewController.h"
@class TextField;
@import AVFoundation;

@interface PFLoginVC () <UITextFieldDelegate>{
    
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@property (nonatomic) AVQueuePlayer *avPlayer;


@end

@implementation PFLoginVC

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.txtUserName.text = [NSUSERDEFAULTS valueForKey:@"user"];
    self.txtPassword.text = [NSUSERDEFAULTS valueForKey:@"password"];
    
    [self playVideoInBackground];
}


#pragma mark -

#pragma mark - memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

#pragma mark - Initial Method

- (void)playVideoInBackground {
    
    NSURL *videoURL = [[NSBundle mainBundle]URLForResource:@"iPadVideo" withExtension:@"mp4"];
    
   // NSURL* mURL = [[NSBundle mainBundle] URLForResource:@"App-BG-Loop" withExtension:@"mp4"];
    
    AVPlayer* player = [AVPlayer playerWithURL:videoURL];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    
    AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = _videoView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.needsDisplayOnBoundsChange = YES;
    [_videoView.layer addSublayer:playerLayer];
    
    _videoView.layer.needsDisplayOnBoundsChange = YES;
    
    [player play];
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

#pragma mark - Validate method -

-(BOOL)isFieldVerified {
    BOOL isVerified = NO;
    
    if (![TRIM_SPACE(self.txtUserName.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Enter Username." onController:self];
    }else if(![TRIM_SPACE(self.txtPassword.text) length]){
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Enter Password." onController:self];
    }else
        isVerified = YES;
    
    return isVerified;
}



#pragma mark -

#pragma mark - UITextField Delegate -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        UITextField *txtField = [self.view viewWithTag:textField.tag+1];
        [txtField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    
    return YES;
}



#pragma mark -

#pragma mark - IBActions
- (IBAction)loginButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if ([self isFieldVerified]) {
        
//        [self.navigationController setNavigationBarHidden:YES];
//        [self.navigationController pushViewController:[APPDELEGATE addRevealView] animated:YES];
        
        [self callLoginServiceIntegration];
    }
    
}

- (IBAction)resetPasswordButtonAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pricefixer.com"]];
}


#pragma mark -

#pragma mark - Service Helper Method
-(void)callLoginServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtUserName.text forKey:@"userName"];
    [dict setValue:self.txtPassword.text forKey:@"password"];
    [dict setValue:@"userLogin"forKey:@"action"];
    [dict setValue:@"ios" forKey:@"deviceType"];
    if ([NSUSERDEFAULTS objectForKey:kDeviceToken] == nil) {
        [dict setValue:@"" forKey:@"deviceToken"];

    }else
        [dict setValue:[NSUSERDEFAULTS objectForKey:kDeviceToken] forKey:@"deviceToken"];
    

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                [NSUSERDEFAULTS setValue:[[response objectForKeyNotNull:@"userDetail" expectedClass:[NSDictionary class]] objectForKeyNotNull:@"id" expectedClass:[NSString class]] forKey:kUserId];
                            [NSUSERDEFAULTS setValue:[[response objectForKeyNotNull:@"userDetail" expectedClass:[NSDictionary class]] objectForKeyNotNull:@"shop_id" expectedClass:[NSString class]] forKey:kShop_id];
                
                            NSString *userName = [NSString stringWithFormat:@"%@ %@",[[response objectForKeyNotNull:@"userDetail" expectedClass:[NSDictionary class]] objectForKeyNotNull:@"firstName" expectedClass:[NSString class]],[[response objectForKeyNotNull:@"userDetail" expectedClass:[NSDictionary class]] objectForKeyNotNull:@"lastName" expectedClass:[NSString class]]];
                
                            [NSUSERDEFAULTS setValue:userName forKey:@"userName"];
                
                            [NSUSERDEFAULTS setValue:self.txtUserName.text forKey:@"user"];
                            [NSUSERDEFAULTS setValue:self.txtPassword.text forKey:@"password"];
                
                            [NSUSERDEFAULTS setValue:[[response objectForKeyNotNull:@"userDetail" expectedClass:[NSDictionary class]] objectForKeyNotNull:@"profile_image" expectedClass:[NSString class]] forKey:@"profileImage"];
                
                            [NSUSERDEFAULTS synchronize];
                
                            [self.navigationController setNavigationBarHidden:YES];
                            [self.navigationController pushViewController:[APPDELEGATE addRevealView] animated:YES];
                        }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
            }
        else {
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
        }
    }];

}




#pragma mark -


@end
