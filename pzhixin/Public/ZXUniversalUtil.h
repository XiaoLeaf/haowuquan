//
//  ZXUniversalUtil.h
//  pzhixin
//
//  Created by zhixin on 2019/10/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXNotice.h"
#import "ZXOpenPage.h"
#import <dsbridge/dsbridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXUniversalUtil : NSObject

+ (ZXUniversalUtil *)sharedInstance;

#pragma mark - Para

@property (strong, nonatomic) UIViewController *topVC;

@property (strong, nonatomic) DWKWebView *wkWebView;

@property (copy, nonatomic) void (^zxUniversalUtilSetBarBlcok) (id data);

@property (copy, nonatomic) void (^zxUniversalUtilSetTitleBlock) (id data);

@property (copy, nonatomic) void (^zxUniversalUtilDisplayBtnBlock) (id data);

#pragma mark - 打开APP具体页面

- (void)openNewPageWithVC:(UIViewController *)vc openPage:(ZXOpenPage *)openPage completionBlock:(void (^)(void))completionBlock;

#pragma mark - 打开WKWebView

- (void)openWkWithVC:(UIViewController *)vc notice:(ZXNotice *)notice;

#pragma mark - 清除WKWebView缓存

- (void)remove_cache:(id)data :(JSCallback)completionHandler;

#pragma mark - 打开扫一扫

- (void)open_scan:(id)data :(JSCallback)completionHandler;

#pragma mark - 参数加签

- (id)get_token:(id)data;

#pragma mark - 清除未读消息数

- (id)reset_badge:(id)data;

#pragma mark - 显示隐藏按钮

- (id)display_btn:(id)data;

#pragma mark - 分享

- (void)open_share:(id)data :(JSCallback)completionHanleder;

#pragma mark - 保存图片

- (id)save_img:(id)data;

#pragma mark - 设置标题

- (id)set_title:(id)data;

#pragma mark - 设置状态栏和导航栏

- (id)set_navbar:(id)data;

#pragma mark - 调用系统震动

- (id)do_shake:(id)data;

#pragma mark - 获取webview参数
- (id)get_sys_params:(id)data;

#pragma mark - 复制文案
- (id)copy_str:(id)data;

#pragma mark - 打开小程序
-(id)launch_miniapp:(id)data;

@end

NS_ASSUME_NONNULL_END
