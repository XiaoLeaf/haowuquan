//
//  ZXWeChatUtils.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXWeChatUtils.h"
#import "UIImage+JKRImage.h"

static ZXWeChatUtils *wechatUtil = nil;

@implementation ZXWeChatUtils

- (instancetype)init {
    self = [super init];
    if (self) {
        _delagete = nil;
    }
    return self;
}

+ (ZXWeChatUtils *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (wechatUtil == nil) {
            wechatUtil = [[ZXWeChatUtils alloc] init];
        }
    });
    return wechatUtil;
}

#pragma mark - 发送授权登录请求

- (void)sendAuthLoginReuqestWithController:(UIViewController *)controller delegate:(id<ZXWeChatUtilsDelegate>)delegate {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *authReq = [[SendAuthReq alloc] init];
        [authReq setScope:@"snsapi_userinfo"];
        [authReq setState:@"snsapi_userinfo"];
        self.delagete = delegate;
        [WXApi sendAuthReq:authReq viewController:controller delegate:self completion:^(BOOL success) {
        }];
    } else {
        SendAuthReq *authReq = [[SendAuthReq alloc] init];
        [authReq setScope:@"snsapi_userinfo"];
        [authReq setState:@"snsapi_userinfo"];
        self.delagete = delegate;
        [WXApi sendAuthReq:authReq viewController:controller delegate:self completion:^(BOOL success) {
        }];
    }
}

#pragma mark - Public Methods

//带图片的微信分享
- (void)shareWithImage:(UIImage *)image text:( NSString * _Nullable)text scene:(int)scene delegate:(id<ZXWeChatUtilsDelegate>)delegate {
    self.delagete = delegate;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    WXImageObject *imageObj = [WXImageObject object];
    [imageObj setImageData:imageData];
    
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
//    NSData *thumbData = UIImageJPEGRepresentation(thumb, 1.0);
//    [mediaMessage setThumbData:thumbData];
    mediaMessage.mediaObject = imageObj;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = mediaMessage;
    req.scene = scene;
    if (![UtilsMacro whetherIsEmptyWithObject:text]) {
        req.text = text;
    }
    [WXApi sendReq:req completion:^(BOOL success) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:[UIPasteboard generalPasteboard].changeCount + 2 forKey:@"changecount"];
        [userDefaults synchronize];
    }];
}

//h5分享网页
- (void)shareWithTitle:(NSString *)title desc:(NSString *)desc image:(NSString *)img url:(NSString *)url scene:(int)scene delegate:(id<ZXWeChatUtilsDelegate>)delegate {
    self.delagete = delegate;
    NSData *imgData;
    if ([img hasPrefix:@"http"]) {
        //从网络下载图片
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:img] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            //压缩图片，最大64K
            [image jkr_compressToDataLength:64 * 1024 withBlock:^(NSData *data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WXMediaMessage *mediaMessage = [WXMediaMessage message];
                    mediaMessage.title = title;
                    mediaMessage.description = desc;
                    mediaMessage.thumbData = data;
                    WXWebpageObject *webpage = [WXWebpageObject object];
                    webpage.webpageUrl = url;
                    mediaMessage.mediaObject = webpage;
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = mediaMessage;
                    req.scene = scene;
                    [WXApi sendReq:req completion:^(BOOL success) {
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setInteger:[UIPasteboard generalPasteboard].changeCount + 2 forKey:@"changecount"];
                        [userDefaults synchronize];
                    }];
                });
            }];
        }];
    } else {
        imgData = [GTMBase64 decodeString:img];
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.title = title;
        mediaMessage.description = desc;
        mediaMessage.thumbData = imgData;
        WXWebpageObject *webpage = [WXWebpageObject object];
        webpage.webpageUrl = url;
        mediaMessage.mediaObject = webpage;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = mediaMessage;
        req.scene = scene;
        [WXApi sendReq:req completion:^(BOOL success) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:[UIPasteboard generalPasteboard].changeCount + 2 forKey:@"changecount"];
            [userDefaults synchronize];
        }];
    }
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        WXLaunchMiniProgramResp *miniResp = (WXLaunchMiniProgramResp *)resp;
        if (self.delagete && [self.delagete respondsToSelector:@selector(zxWeChatMiniAppCallBack:)]) {
            [self.delagete zxWeChatMiniAppCallBack:miniResp.extMsg];
        }
        return;
    }
    switch (resp.errCode) {
        //用户同意授权
        case 0:
        {
            if ([resp isKindOfClass:[SendAuthResp class]]) {
                SendAuthResp *authResp = (SendAuthResp *)resp;
                if (self.delagete && [self.delagete respondsToSelector:@selector(zxWeChatAuthLoginSucceedWithCode:)]) {
                    [self.delagete zxWeChatAuthLoginSucceedWithCode:authResp.code];
                }
            } else {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:[UIPasteboard generalPasteboard].changeCount forKey:@"changecount"];
                [userDefaults synchronize];
                if (self.delagete && [self.delagete respondsToSelector:@selector(zxWeChatShareSucceed)]) {
                    [self.delagete zxWeChatShareSucceed];
                }
            }
        }
            break;
        //用户拒绝授权
        case -4:
        {
            [ZXProgressHUD hideAllHUD];
            [self.delagete zxWeChatAuthLoginDenied];
        }
            break;
        //用户取消授权
        case -2:
        {
            [ZXProgressHUD hideAllHUD];
            [self.delagete zxWeChatAuthLoginCancel];
        }
            break;
            
        default:
        {
            
        }
            break;
    }
}

#pragma mark - 调起微信小程序

- (void)openWechatMiniAppWithApp:(ZXMiniApp *)miniApp delegate:(id<ZXWeChatUtilsDelegate>)delegate {
    self.delagete = delegate;
    WXLaunchMiniProgramReq *miniReq = [WXLaunchMiniProgramReq object];
    miniReq.userName = miniApp.originalId;
    miniReq.path = miniApp.path;
    miniReq.miniProgramType = WXMiniProgramTypeRelease;
    [WXApi sendReq:miniReq completion:^(BOOL success) {
        
    }];
}

@end
