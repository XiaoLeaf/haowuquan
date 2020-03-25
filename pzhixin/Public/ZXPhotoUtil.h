//
//  ZXPhotoUtil.h
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXPhotoUtilDelegate;

@interface ZXPhotoUtil : NSObject

+ (ZXPhotoUtil *)sharedInstance;

@property (strong, nonatomic) ZLPhotoActionSheet *photoActionSheet;

@property (weak, nonatomic) id<ZXPhotoUtilDelegate>delegate;

#pragma mark - Public Methods

//相机拍照
- (void)takePhotoWithViewController:(UIViewController *)viewController delegate:(id<ZXPhotoUtilDelegate>)delegate;

//从相册选择
- (void)zlSelectPhotoWithMax:(NSInteger)maxCount WithViewController:(UIViewController *)viewController delegate:(id<ZXPhotoUtilDelegate>)delegate;

//销毁imgPickerVC
- (void)removeImgPickerVC;

@end

@protocol ZXPhotoUtilDelegate <NSObject>

- (void)zxPhotoUtilImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info;

- (void)zxPhotoUtilImagePickerControllerDidCancel:(UIImagePickerController *)picker;

- (void)zlPhotoActionFinished:(ZLPhotoActionSheet *)photoActionSheet images:(NSArray<UIImage *> * _Nullable )images asstes:(NSArray<PHAsset *> * _Nonnull )assets isOriginal:(BOOL)isOriginal;

- (void)zlPhotoActionCancel:(ZLPhotoActionSheet *)photoActionSheet;

@end

NS_ASSUME_NONNULL_END
