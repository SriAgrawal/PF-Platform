//
//  PFCreateSupportTicketViewController.m
//  PriceFixer
//
//  Created by Ankit Kumar Gupta on 15/05/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFCreateSupportTicketViewController.h"
#import "CameraSessionView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <Photos/PHObject.h>
#import "PFCreateTicketInfo.h"

typedef void(^ticketCompletion)(NSString*);
@interface PFCreateSupportTicketViewController ()<CACameraSessionDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    BOOL                isAnimated;
    BOOL                isFromCamera;
    NSMutableArray *dropDownArray;
    PFCreateTicketInfo *createInfo;
}


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageName;

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;
@property (weak, nonatomic) IBOutlet UIButton  *priorityBtn;

@property (strong, nonatomic) IBOutlet UITableView *priorityTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) CameraSessionView *cameraView;


@end

@implementation PFCreateSupportTicketViewController

#pragma mark - UIViewController Life Cycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


#pragma mark - Initial method
- (void)initialMethod {
    
    [self.navigationController setNavigationBarHidden:YES];
    createInfo = [[PFCreateTicketInfo alloc] init];
    
    dropDownArray = [[NSMutableArray alloc] initWithObjects:@"Low (recommendations, spelling error. etc)",@"Medium (very important to my business)",@"Urgent (impacting my sales ability)", nil];
    _priorityTableView.hidden=YES;

    
    // Set logout view
    self.logOutView.hidden = YES;
    [self.logOutViewHeightConstraint setConstant:0];
    
    // Set userImage corner radius
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    
    // Set UserName & Profile Image
    self.userNameLabel.text = [NSUSERDEFAULTS valueForKey:@"userName"];
    
    NSString *str = [NSUSERDEFAULTS valueForKey:@"profileImage"];
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    [super viewDidLoad];
    [self loadContent];
}

#pragma mark - Load content locally.

- (void)loadContent {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"/CKEditor/demo.html" ofType:@""];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}


#pragma mark - WebView Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.body.style.margin='0';document.body.style.padding = '0'"];
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('editor').innerHTML='<b>'Hello</b> <i>World</i>!';"];
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementById('editor').focus();"];
}



#pragma mark - UITableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dropDownArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    cell.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [dropDownArray objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _priorityTableView.hidden=YES;
    [self.priorityBtn setSelected:NO];
    self.priorityTextField.text = [dropDownArray objectAtIndex:indexPath.row];
    createInfo.strTicketPriority = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
}
#pragma mark - UITouch Method

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    _priorityTableView.hidden = YES;
}




#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];

    
    // Check for Emoji Characters
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }

    if ( textField.tag == 200 ) {
        const char *character=[string UTF8String];
        int intValue=(int)*character;//converted to ascii, however you can directly compare to character to 'a' and 'z'
        if (str.length == 21) {
            return NO;
        }
        if ((intValue >= 97 && intValue <=122) || (intValue >= 65 && intValue <=90)|| (intValue == 32) || (intValue == 0)) {
            return YES;
        }else{
            return NO;
        }    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldBorderColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.layer.borderColor = KHomeTextFieldGrayBorderColor;
    createInfo.strTicketTitle = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}



#pragma mark - UIButton Action

-(IBAction)uploadImgButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoFromCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoFromGallery];
    }]];
    
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = sender;
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPresenter.sourceRect = sender.bounds; // You can set position of popover
    
    
    [self presentViewController:alert animated:TRUE completion:nil];
}

-(IBAction)createTicketButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    [self getHtmlData];
    if ( [self validateData]) {
        [self callCreateTicketServiceIntegration];
    }
}

-(void) getHtmlData{
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:
                      @"CKEDITOR.instances.editor.getData()"];
    createInfo.strTicketDescription = html;
}

-(BOOL)validateData{
    
    BOOL isValidate = NO;
    if (![createInfo.strTicketTitle length]) {
        [PFUtility alertWithTitle:@"" andMessage:@"Please enter any ticket title." andController:self];
    }
    else if (![createInfo.strTicketPriority length]){
        [PFUtility alertWithTitle:@"" andMessage:@"Please select priority." andController:self];
    }
    else if (![createInfo.strTicketDescription length]){
        [PFUtility alertWithTitle:@"" andMessage:@"Please enter ticket description." andController:self];
    }
    else{
        isValidate = YES;
    }
    return isValidate;
}

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (isFromCamera) {
        self.imageName.text = @"image.png";
        createInfo.strTicketFileName = @"image.png";
        createInfo.uploadImage = image;
    }
    else
    {
    NSURL *refURL = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil];
    NSString *filename = [[result firstObject] filename];
    
    self.imageName.text = filename;
    createInfo.strTicketFileName = filename;
    createInfo.uploadImage = image;
    }
   
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*********** Opening gallery for taking image for Profile img *****************/


-(void)takePhotoFromCamera {
    
    isFromCamera = YES;
    UIImagePickerController *profileImagePicker = [[UIImagePickerController alloc] init];
    profileImagePicker.delegate = self;
    profileImagePicker.allowsEditing = YES;
    [profileImagePicker setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        profileImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:profileImagePicker animated:YES completion:NULL];
        
    } else {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Camera is not available." onController:self];    }
    
}

#pragma mark- Take Profile img from gallery

-(void)takePhotoFromGallery {
    
    isFromCamera = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        [imagePickerController setDelegate:self];
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        UIPopoverController  *popoverController= [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        
        [popoverController presentPopoverFromRect:CGRectMake(self.navigationController.view.frame.size.width/2 - popoverController.contentViewController.preferredContentSize.width/2, self.navigationController.view.frame.size.height/2, 0, 0) inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES ];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        picker.allowsEditing = YES;
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}


- (IBAction)signOutButtonAction:(id)sender {
    
    [UIView transitionWithView:self.view duration:0.1 options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if (isAnimated == NO) {
                            isAnimated = YES;
                            [self.logOutViewHeightConstraint setConstant:69];
                            [self.logOutView setHidden:NO];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }else{
                            isAnimated = NO;
                            [self.logOutViewHeightConstraint setConstant:0];
                            [self.logOutView setHidden:YES];
                            [self.view layoutIfNeeded];
                            [self.view layoutSubviews];
                            [UIView commitAnimations];
                        }
                    }
                    completion:^(BOOL finished) {
                    }];
}

- (IBAction)logOutButtonAction:(id)sender {
    
    [[AlertView sharedManager] presentAlertWithTitle:KlogoutTitle message:KlogoutMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes",@"No", nil] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        if(index == 0){
            [self callLogoutServiceIntegration];
        }
    }];
}


- (IBAction)dropDownButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.priorityTableView setHidden:NO];
    
}

- (IBAction)changePasswordButtonAction:(id)sender {
    
    [self hideShowLogoutView];
    
    PFChangePasswordVC *obj = [[PFChangePasswordVC alloc] initWithNibName:@"PFChangePasswordVC" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)menuButtonACtion:(id)sender {
    
    [self.view endEditing:YES];
    [self hideShowLogoutView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refershMenuList" object:nil];
    [self.sidePanelController toggleLeftPanel:nil];
}
-(void)hideShowLogoutView {
    
    isAnimated = NO;
    [self.logOutViewHeightConstraint setConstant:0];
    [self.logOutView setHidden:YES];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];
    [UIView commitAnimations];
}

#pragma mark - * * * SERVICE HELPER METHOD * * *


-(void)callLogoutServiceIntegration{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"userLogout"forKey:@"action"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"userId"];
    [dict setValue:@"ios" forKey:@"deviceType"];
    if ([NSUSERDEFAULTS objectForKey:kDeviceToken] == nil) {
        [dict setValue:@"" forKey:@"deviceToken"];
    }else{
        [dict setValue:[NSUSERDEFAULTS objectForKey:kDeviceToken] forKey:@"deviceToken"];
    }
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                [APPDELEGATE  navigateToLoginVC];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

- (void)callCreateTicketServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"createTicket"forKey:@"action"];
    [dict setValue:createInfo.strTicketTitle forKey:@"title"];
    [dict setValue:createInfo.strTicketPriority forKey:@"priority"];
    [dict setValue:createInfo.strTicketDescription forKey:@"description"];
    
    NSData *imageData = UIImagePNGRepresentation(createInfo.uploadImage);

    [dict setValue:[NSUSERDEFAULTS objectForKey:kUserId] forKey:@"user_id"];
    [dict setValue:[NSUSERDEFAULTS objectForKey:kShop_id] forKey:@"shop_id"];
 
    
    [[ServiceHelper_AF3 instance]makeMultipartWebApiCallWithParameters:dict AndPath:@"" andData:imageData mediaType:0 WithCompletion:^(BOOL suceeded, NSString *error, id response) {
         [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:kResponseMessage expectedClass:[NSString class]]  andController:self];
    } andProgresscompletion:^(double fractionCompleted) {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setProgressHud:(PFProgressHud)hud {
 
    switch (hud) {
        case BDProgressShown:
        {
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] withText:@"Please wait..." animated:YES];
        }
            break;
        case BDProgressNotShown:
            [MBProgressHUD hideAllHUDsForView:[APPDELEGATE window] animated:YES];
            
            break;
        default:
            break;
    }
}


@end
