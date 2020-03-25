//
//  ZXProgressHUD.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXProgressHUD : MBProgressHUD

+ (void)loading;

+ (void)loadingForView:(UIView *)view;

+ (void)loadingNoMask;

+ (void)hideNoMaskHud;

#pragma mark - 带遮罩层的Toast

+ (void)loadSucceedWithMaskMsg:(NSString *)msg;

+ (void)loadFailedWithMaskMsg:(NSString *)msg;

#pragma mark - 无遮罩层的Toast

+ (void)loadSucceedWithMsg:(NSString *)msg;

+ (void)loadFailedWithMsg:(NSString *)msg;

+ (void)hideAllHUD;

+ (void)hideHUDForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
