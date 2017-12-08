//
//  PVPhotoSelectedViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPhotoSelectedViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>


@interface PVPhotoSelectedViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, copy)PVPhotoSelectedViewControllerBlock vcBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomLayout;


@end

@implementation PVPhotoSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewBottomLayout.constant = SafeAreaBottomHeight;
    
}

- (IBAction)photographBtnClicked {//照相
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self isPhotographOrPhoto:UIImagePickerControllerSourceTypeCamera];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self isPhotographOrPhoto:UIImagePickerControllerSourceTypeCamera];
            }
        }];
    }else{
        UIAlertController *alerController = [UIAlertController  alertControllerWithTitle:@"相机服务未开启" message:@"请在系统设置中开启相机权限\n设置->隐私->相机->熊猫视频" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {                
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"暂不开启" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alerController addAction:okAction];
        [alerController addAction:cancelAction];
        [self presentViewController:alerController animated:YES completion:nil];
    }
}
- (IBAction)photoBtnClicked {//照片
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        
    }else{
        //授权成功
        [self isPhotographOrPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized){
                [self isPhotographOrPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
            }else{
                UIAlertController *alerController = [UIAlertController  alertControllerWithTitle:@"照片服务未开启" message:@"请在系统设置中开启照片浏览权限\n设置->隐私->照片->熊猫视频" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                        
                    }
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"暂不开启" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alerController addAction:okAction];
                [alerController addAction:cancelAction];
                [self presentViewController:alerController animated:YES completion:nil];
            }
        });
    }];
    
}



-(void)jumpPhoto{
  
}

-(void)isPhotographOrPhoto:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:true completion:nil];
}

- (IBAction)cancelBtnClicked {
    [self dismissViewControllerAnimated:false completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        //保存图片
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage* thumbImage;
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image;
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        CGFloat margin = 6;
        CGFloat width = (ScreenWidth-margin*4-20)/5-10;
        thumbImage = [UIImage getThumbImage:info[UIImagePickerControllerOriginalImage] size:CGSizeMake(width, width)];
        thumbImage = [UIImage fixOrientation:thumbImage];
    }
    [picker dismissViewControllerAnimated:false completion:^{
        if (self.vcBlock && thumbImage) {
            self.vcBlock(thumbImage);
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:false completion:nil];
}

-(void)setPVPhotoSelectedViewControllerBlock:(PVPhotoSelectedViewControllerBlock)block{
    self.vcBlock = block;
}
@end
