//
//  ZXPhotoUtil.m
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPhotoUtil.h"

@interface ZXPhotoUtil () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation ZXPhotoUtil

+ (ZXPhotoUtil *)sharedInstance {
    static ZXPhotoUtil *photoUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (photoUtil == nil) {
            photoUtil = [[ZXPhotoUtil alloc] init];
        }
    });
    return photoUtil;
}

#pragma mark - Public Methods

- (void)takePhotoWithViewController:(UIViewController *)viewController delegate:(id<ZXPhotoUtilDelegate>)delegate {
    self.delegate = delegate;
//    NSLog(@"isSourceTypeAvailable====>%@",[NSNumber numberWithBool:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]]);
    _imagePickerController = [[UIImagePickerController alloc] init];
//    [_imagePickerController setDelegate:self];
    _imagePickerController.delegate = self;
    [_imagePickerController setAllowsEditing:NO];
    [_imagePickerController.navigationBar setTranslucent:NO];
    [_imagePickerController autoContentAccessingProxy];
    [_imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [_imagePickerController setModalPresentationStyle:UIModalPresentationFullScreen];
    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)zlSelectPhotoWithMax:(NSInteger)maxCount WithViewController:(UIViewController *)viewController delegate:(id<ZXPhotoUtilDelegate>)delegate {
    self.delegate = delegate;
    if (maxCount == 1) {
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
    } else {
        if (!_photoActionSheet) {
            _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        }
    }
    [_photoActionSheet.configuration setMaxSelectCount:maxCount];
    [_photoActionSheet.configuration setAllowSelectGif:NO];
    [_photoActionSheet.configuration setAllowSelectVideo:NO];
    [_photoActionSheet.configuration setAllowTakePhotoInLibrary:NO];
    [_photoActionSheet.configuration setSaveNewImageAfterEdit:NO];
    [_photoActionSheet.configuration setClipRatios:@[GetClipRatio(1, 1)]];
    [_photoActionSheet.configuration setBottomBtnsNormalTitleColor:[UIColor whiteColor]];
    [_photoActionSheet.configuration setNavBarColor:[HOME_TITLE_COLOR colorWithAlphaComponent:0.5]];
    [_photoActionSheet.configuration setBottomBtnsDisableBgColor:[UIColor whiteColor]];
    [_photoActionSheet.configuration setBottomViewBgColor:[UIColor blackColor]];
    [_photoActionSheet showPhotoLibraryWithSender:viewController];
    
    __weak typeof(self) weakSelf = self;
    [_photoActionSheet setCancleBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(zlPhotoActionCancel:)]) {
            [weakSelf.delegate zlPhotoActionCancel:weakSelf.photoActionSheet];
        }
    }];
    
    [_photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(zlPhotoActionFinished:images:asstes:isOriginal:)]) {
            [weakSelf.delegate zlPhotoActionFinished:weakSelf.photoActionSheet images:images asstes:assets isOriginal:isOriginal];
        }
    }];
}

//销毁imgPickerVC
- (void)removeImgPickerVC {
    _photoActionSheet = nil;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxPhotoUtilImagePickerController:didFinishPickingMediaWithInfo:)]) {
        [self.delegate zxPhotoUtilImagePickerController:picker didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxPhotoUtilImagePickerControllerDidCancel:)]) {
        [self.delegate zxPhotoUtilImagePickerControllerDidCancel:picker];
    }
}

@end
