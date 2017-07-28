//
//  PFInstallPictureViewController.m
//  PriceFixer
//
//  Created by Deepak Chauhan on 16/03/17.
//  Copyright © 2017 Yogita Joshi. All rights reserved.
//

#import "PFInstallPictureViewController.h"
#import "PFInstallPictureCollectionViewCell.h"
#import "Macro.h"
#import "PFEquipmentModelInfo.h"
#import "TextField.h"

static NSString * PFInstallPictureCellId = @"installPictureCellId";

@interface PFInstallPictureViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate> {
    
    NSMutableArray *installPictureArray;
    PFEquipmentModelInfo *picModel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TextField *titleTextField;
@property (strong, nonatomic) UIImage *uploadImage;
@property (weak, nonatomic) IBOutlet UILabel *imageNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation PFInstallPictureViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialMethod];

}

#pragma mark - Custom Method

- (void)initialMethod {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PFInstallPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:PFInstallPictureCellId];
    
    self.viewHeightConstraint.constant = 230;

    // Alloc Array
    installPictureArray = [NSMutableArray array];
    self.imageView.image = self.img;
    
    // Alloc Model Class
    picModel = [[PFEquipmentModelInfo alloc] init];
    picModel.strImageName = @"No File Selected";
    
    // Call Api
    [self callInstallPicListServiceIntegration];
}


- (BOOL)validateAllFields {
    
    if (!self.titleTextField.text.length)
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please enter title." onController:self];
    
    else if ([picModel.strImageName isEqualToString:@"No File Selected"])
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"" andMessage:@"Please select image." onController:self];

    else
        return YES;
    
    return NO;
}

#pragma mark - UICollectionview DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return installPictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFInstallPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PFInstallPictureCellId forIndexPath:indexPath];
    
    PFEquipmentModelInfo *installPictureInfo = [installPictureArray objectAtIndex:indexPath.item];

    [cell.installpictureImageView setImageWithURL:[NSURL URLWithString:installPictureInfo.strImageurl]];
    cell.imageNameLabel.text = installPictureInfo.strItem_title;
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFEquipmentModelInfo *installPictureInfo = [installPictureArray objectAtIndex:indexPath.item];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:installPictureInfo.strImageurl]];

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 4;
    CGSize size = CGSizeMake(cellWidth-105, cellWidth-105);
    
    return size;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIButton Action

- (IBAction)uploadButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
        [actionSheet setTag:5001];
        [actionSheet showInView:self.view];
}


- (IBAction)sendButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    if ([self validateAllFields]) {
        
        [self callAddInstallPicListServiceIntegration];
    }
}

- (IBAction)dismissButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - UIImagePicker Delegate method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.uploadImage = image;
    picModel.strImageName = [[[editingInfo valueForKey:UIImagePickerControllerReferenceURL] path] lastPathComponent];
    self.imageNameLabel.text = picModel.strImageName;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark UIAction sheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: {
            //Camera
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self takePhotoFromCamera];
            }];
        }
            break;
        case 1: {
            //Gallery
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self takePhotoFromGallery];
            }];
        }
            break;
        default:
            break;
    }
}

-(void)takePhotoFromCamera {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            
            
            [imagePickerController setDelegate:self];
            
            imagePickerController.allowsEditing = NO;
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            
            
            UIPopoverController  *popoverController= [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
            
            [popoverController presentPopoverFromRect:CGRectMake(self.navigationController.view.frame.size.width/2 - popoverController.contentViewController.preferredContentSize.width/2, self.navigationController.view.frame.size.height/2, 0, 0) inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES ];
            
        }else {
            
            UIImagePickerController *profileImagePicker = [[UIImagePickerController alloc]init];
            
            profileImagePicker.delegate = self;
            
            profileImagePicker.allowsEditing = YES;
            
            profileImagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;;
            
            [self presentViewController:profileImagePicker animated:YES completion:NULL];
            
        }
    }
    
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Camera is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
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
- (void) callInstallPicListServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"installedPicturesList"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"order_id"];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            if ([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 200) {
                
                NSDictionary *dict = [response objectForKeyNotNull:@"installPics" expectedClass:[NSDictionary class]];
                
                NSArray *installPicList = [dict objectForKeyNotNull:@"pics" expectedClass:[NSArray class]];
                [installPictureArray removeAllObjects];
                self.titleTextField.text = @"";
                self.titleTextField.text = @"";
                picModel.strImageName = @"No File Selected";
                self.imageNameLabel.text = picModel.strImageName;
                
                for (NSDictionary *pictureDict in installPicList) {
                    
                    [installPictureArray addObject:[PFEquipmentModelInfo modelInstallPicListDict:pictureDict]];
                }
                    self.viewHeightConstraint.constant = 441;

                [self.collectionView reloadData];
            }
            else if([[response objectForKeyNotNull:kResponseCode expectedClass:[NSString class]] integerValue] == 0) {
                self.viewHeightConstraint.constant = 230;
                [self.collectionView reloadData];
            }
            else
                [PFUtility alertWithTitle:@"" andMessage:[response objectForKeyNotNull:@"responseMessage" expectedClass:[NSString class]] andController:self];
        }
        else
            [PFUtility alertWithTitle:@"" andMessage:error.description  andController:self];
    }];
}

- (void) callAddInstallPicListServiceIntegration {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"uploadInstalledImages"forKey:@"action"];
    [dict setValue:self.strOrderId forKey:@"order_id"];
    [dict setValue:self.titleTextField.text forKey:@"title"];

    NSData *imageData = UIImagePNGRepresentation(self.uploadImage);
    
    [[ServiceHelper_AF3 instance]makeMultipartWebApiCallWithParameters:dict AndPath:@"" andData:imageData mediaType:0 WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self callInstallPicListServiceIntegration];
    } andProgresscompletion:^(double fractionCompleted) {
        
    }];
}



#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
