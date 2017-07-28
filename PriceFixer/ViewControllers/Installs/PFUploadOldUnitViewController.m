//
//  PFUploadOldUnitViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 04/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFUploadOldUnitViewController.h"
#import "PFEquipmentModelInfo.h"
#import "PFUploadOldUnitTableViewCell.h"
#import "CameraSessionView.h"
#import "Macro.h"


static NSString * PFUploadImageCellId = @"uploadCellId";

@interface PFUploadOldUnitViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate,CACameraSessionDelegate> {
    
    PFEquipmentModelInfo *uploadDataInfo;
    NSMutableArray *uploadImageArray;
    NSString *imagePath;
    NSString *strId;
    NSString *typeText;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgForScreenShot;
@property (weak, nonatomic) IBOutlet UITableView *uploadTableView;
@property (strong, nonatomic) UIImage *uploadImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) CameraSessionView *cameraView;

@end

@implementation PFUploadOldUnitViewController

#pragma mark - View Controller life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialMethod];
    

}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Method
- (void)initialMethod {
    
    [self.uploadTableView registerNib:[UINib nibWithNibName:@"PFUploadOldUnitTableViewCell" bundle:nil] forCellReuseIdentifier:PFUploadImageCellId];
    [_imgForScreenShot setImage:_img];
    
    if (self.isOldPicture)
        self.titleLabel.text = @"Upload the old unit pictures";
    else
        self.titleLabel.text = @"Upload the new unit pictures";
 
    
    // Alloc Model Class
    uploadDataInfo = [[PFEquipmentModelInfo alloc] init];
    
    // Alloc Array
    uploadImageArray = [NSMutableArray array];
    
    self.viewHeightConstraint.constant = 225;

    
    [self callGetUploadImageServiceIntegration];
}

#pragma mark - UITableView Delegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return uploadImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUploadOldUnitTableViewCell * cell = (PFUploadOldUnitTableViewCell *)[self.uploadTableView dequeueReusableCellWithIdentifier:PFUploadImageCellId];
    uploadDataInfo = [uploadImageArray objectAtIndex:indexPath.row];

    cell.productNameLabel.text = uploadDataInfo.strItem_title;
    cell.productDetailLabel.text = uploadDataInfo.strItem_desc;
    [cell.productImageView setImageWithURL:[NSURL URLWithString:uploadDataInfo.strImageurl] placeholderImage:[UIImage imageNamed:@""]];
    if (uploadDataInfo.strNew_eq_image.length)
    {
        [cell.uploadImageView setImageWithURL:[NSURL URLWithString:uploadDataInfo.strNew_eq_image]];
        cell.uploadButton.hidden = YES;
        cell.uploadImageView.hidden = NO;
    }
    else
    {
        cell.uploadButton.hidden = NO;
        cell.uploadImageView.hidden = YES;
    }
    if (uploadDataInfo.strOld_eq_image.length) {
        [cell.imgOld setImageWithURL:[NSURL URLWithString:uploadDataInfo.strOld_eq_image]];
        cell.imgOld.hidden = NO;
        cell.btnUploadOldImg.hidden = YES;
    }
    else
    {
        cell.imgOld.hidden = YES;
        cell.btnUploadOldImg.hidden = NO;
    }

    cell.uploadButton.tag = indexPath.row;
    cell.btnUploadOldImg.tag = indexPath.row;

    [cell.uploadButton addTarget:self action:@selector(uploadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnUploadOldImg addTarget:self action:@selector(uploadOldImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0;
}


#pragma mark - UIButton Action

- (IBAction)dismisButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.uploadImage = image;
   imagePath = [[[editingInfo valueForKey:UIImagePickerControllerReferenceURL] path] lastPathComponent];
    
    NSLog(@"%@",imagePath);
    [self callUpdateEquipmentListServiceIntegration];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Selector Method
- (void)uploadButtonAction:(UIButton*)sender
{
    [self.view endEditing:YES];

    PFEquipmentModelInfo *obj = [uploadImageArray objectAtIndex:sender.tag];
    
    strId = obj.strId;
    typeText = @"newimage";
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

-(IBAction)uploadOldImgButtonAction:(UIButton *)sender{
    [self.view endEditing:YES];
    
    PFEquipmentModelInfo *obj = [uploadImageArray objectAtIndex:sender.tag];
    
    strId = obj.strId;
    typeText = @"";
    
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

-(void)takePhotoFromCamera {
    
    UIImagePickerController *profileImagePicker = [[UIImagePickerController alloc] init];
    profileImagePicker.delegate = self;
    profileImagePicker.allowsEditing = NO;
    [profileImagePicker setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        profileImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:profileImagePicker animated:YES completion:NULL];
        
    } else {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Camera is not available." onController:self];    }
}


-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    self.uploadImage = image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.cameraView removeFromSuperview];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    self.uploadImage = image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.cameraView removeFromSuperview];
    [self callUpdateEquipmentListServiceIntegration];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}



/*********** Opening gallery for taking image for Profile img *****************/

#pragma mark- Take Profile img from gallery

-(void)takePhotoFromGallery {

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


#pragma mark - Service Helper Method
- (void) callUpdateEquipmentListServiceIntegration {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setValue:@"uploadOldEqPicture"forKey:@"action"];
    [dict setValue:strId forKey:@"id"];
    [dict setValue:typeText forKey:@"type"];
    NSData *imageData = UIImagePNGRepresentation(self.uploadImage);

    [[ServiceHelper_AF3 instance]makeMultipartWebApiCallWithParameters:dict AndPath:@"" andData:imageData mediaType:0 WithCompletion:^(BOOL suceeded, NSString *error, id response) {

        [self callGetUploadImageServiceIntegration];
    } andProgresscompletion:^(double fractionCompleted) {
        
    }];
}



#pragma mark - Service Helper Method
- (void) callGetUploadImageServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"oldEquipmentPictures"forKey:@"action"];
    [dict setValue:self.parentId forKey:@"parent_order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {

            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {

                NSArray *uploadListArray = [response objectForKeyNotNull:@"responseData" expectedClass:[NSArray class]];
                [uploadImageArray removeAllObjects];

                for (NSDictionary *uploadDict in uploadListArray) {

                    [uploadImageArray addObject:[PFEquipmentModelInfo modelUploadImageListDict:uploadDict]];
                }
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                [self.uploadTableView reloadData];
            }
            else if([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 0) {
                [self performSelector:@selector(afterSomeTime) withObject:self afterDelay:0.1];
                [self.uploadTableView reloadData];
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}


-(void)afterSomeTime {
    
   self.viewHeightConstraint.constant = self.uploadTableView.contentSize.height + 125;
    
}

@end
