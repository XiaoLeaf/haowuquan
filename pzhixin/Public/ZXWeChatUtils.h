//
//  ZXWeChatUtils.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WechatOpenSDK/WXApi.h>
#import "ZXMiniApp.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXWeChatUtilsDelegate <NSObject>

@optional

//用户同意授权登录
- (void)zxWeChatAuthLoginSucceedWithCode:(NSString *)authCode;

//用户取消授权
- (void)zxWeChatAuthLoginCancel;

//微信分享成功
- (void)zxWeChatShareSucceed;

//用户拒绝授权
- (void)zxWeChatAuthLoginDenied;

//未安装微信
- (void)zxWeChatUnInstallWeChat;

//微信小程序的回调
- (void)zxWeChatMiniAppCallBack:(NSString *)extMsg;

@end

@interface ZXWeChatUtils : NSObject<WXApiDelegate>

@property (assign, nonatomic) id<ZXWeChatUtilsDelegate, NSObject>delagete;

+ (ZXWeChatUtils *)sharedInstance;

#pragma mark - 发送授权登录请求

- (void)sendAuthLoginReuqestWithController:(UIViewController *)controller delegate:(id<ZXWeChatUtilsDelegate>)delegate;

#pragma mark - Public Methods

//带图片的微信分享
- (void)shareWithImage:(UIImage *)image text:(NSString * _Nullable)text scene:(int)scene delegate:(id<ZXWeChatUtilsDelegate>)delegate;

//h5分享网页
- (void)shareWithTitle:(NSString *)title desc:(NSString *)desc image:(NSString *)img url:(NSString *)url scene:(int)scene delegate:(id<ZXWeChatUtilsDelegate>)delegate;

#pragma mark - 调起微信小程序

- (void)openWechatMiniAppWithApp:(ZXMiniApp *)miniApp delegate:(id<ZXWeChatUtilsDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
