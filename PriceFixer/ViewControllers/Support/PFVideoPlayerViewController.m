//
//  PFVideoPlayerViewController.m
//  PriceFixer
//
//  Created by Ankit Kumar Gupta on 12/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFVideoPlayerViewController.h"
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"
#import "Macro.h"

@interface PFVideoPlayerViewController ()<UIWebViewDelegate,VIMVideoPlayerDelegate,VIMVideoPlayerViewDelegate> {
    
    AVPlayerViewController *playerViewController;

}

@property (strong, nonatomic) IBOutlet VIMVideoPlayerView *viewVideo;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;


@end

@implementation PFVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.viewVideo.hidden = YES;
    self.webView.hidden = NO;
    self.webView.delegate = self;
    [self showLoader];
    
    
    self.titleLbl.text = self.obj_tutorial.strTitle;
    
    NSArray *strArray = [self.obj_tutorial.strVideoUrl componentsSeparatedByString:@"/"];
    
    NSString *videoFrame = [NSString stringWithFormat:@"<iframe src=https://player.vimeo.com/video/%@?title=0&byline=0&portrait=0 width=719.5 height=400 frameborder=0 webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>",[strArray lastObject]];
    [self.webView loadHTMLString:videoFrame baseURL:[NSURL URLWithString:@"https://vimeo.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpVideo{
    self.viewVideo.player.looping = YES;
    [self.viewVideo.player disableAirplay];
    [self.viewVideo setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
    
    
    if ([self.obj_tutorial.strVideoUrl length])
    {
        [self.viewVideo.player setURL:[NSURL fileURLWithPath:self.obj_tutorial.strVideoUrl]];
    }
}

#pragma mark - Web View Delegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self hideLoader];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self hideLoader];
}


#pragma mark - UIButton Action

- (IBAction)canclePageButtonAction:(id)sender {
    
    [self hideLoader];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showLoader{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - Vimeo Delegate Method

- (void)videoPlayerViewIsReadyToPlayVideo:(VIMVideoPlayerView *)videoPlayerView{

    [self hideLoader];
    [self.viewVideo.player play];
}
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error{

    [self hideLoader];
     [PFUtility alertWithTitle:@"Error!" andMessage:@"Video is not loading Try again!"  andController:self];

}

@end
