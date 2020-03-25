//
//  ZXPublicWKWebView.m
//  pzhixin
//
//  Created by zhixin on 2019/7/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPublicWKWebView.h"
#import <Masonry/Masonry.h>
#import <dsbridge/dsbridge.h>
#import "ZXShareVC.h"

NSString * const BridgeMethodStrGetParams = @"get_params";

NSString * const BridgeMethodStrGetToken = @"get_token";

NSString * const BridgeMethodStrBarBtnAction = @"do_btn";

@interface ZXPublicWKWebView () <WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate> {
    WKUserContentController* userContent;
}

@property (strong, nonatomic) DWKWebView *wkWebView;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) NSMutableArray *rightBtnList;

@property (assign, nonatomic) BOOL existClose;

@property (assign, nonatomic) BOOL existRefresh;

@property (assign, nonatomic) BOOL isLight;

@property (strong, nonatomic) ZXUniversalUtil *universalUtil;

@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) ZXUrlCoupon *urlCoupon;

@property (strong, nonatomic) ZXJumpTBView *jumpTBView;

@property (assign, nonatomic) NSInteger barStyle;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation ZXPublicWKWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFd_prefersNavigationBarHidden:YES];
    if ([_notice.bar_style isEqualToString:@"light"]) {
        self.barStyle = UIStatusBarStyleLightContent;
    } else {
        self.barStyle = UIStatusBarStyleDefault;
    }
//    self.fd_interactivePopDisabled = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configurationInit];
    [self createBackBtn];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.universalUtil.zxUniversalUtilDisplayBtnBlock(@{@"btn":@[@1, @1, @0]});
//    });
}

- (void)backButtonPressed:(id)sender {
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![self.navigationController.topViewController isKindOfClass:[ZXShareVC class]]) {
        [ZXProgressHUD hideHUDForView:self.view];
        [ZXProgressHUD hideAllHUD];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _barStyle;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Setter

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
}

- (void)setNotice:(ZXNotice *)notice {
    _notice = notice;
    _urlStr = _notice.url;
}

#pragma mark - Private Methods

- (void)configurationInit {
    [self configNavBar];
    [self createWkWebView];
}

- (void)configNavBar {
    if ([_notice.bar_style isEqualToString:@"light"]) {
        _isLight = YES;
    } else {
        _isLight = NO;
    }
    UIImage *backImg;
    UIColor *titleColor;
    _rightBtnList = [[NSMutableArray alloc] init];
    if ([[_notice.btn objectAtIndex:0] integerValue] == 0) {
        backImg = [UIImage new];
    } else {
        if (_isLight) {
            backImg = [UIImage imageNamed:@"ic_back_white"];
        } else {
            backImg = [UIImage imageNamed:@"ic_whole_back"];
        }
    }
    if (_isLight) {
        titleColor = [UIColor whiteColor];
    } else {
        titleColor = HOME_TITLE_COLOR;
    }
    if ([[_notice.btn objectAtIndex:2] integerValue] == 1) {
        _existRefresh = YES;
        if (_isLight) {
            [_rightBtnList addObject:[UIImage imageNamed:@"ic_webview_refresh_white"]];
        } else {
            [_rightBtnList addObject:[UIImage imageNamed:@"ic_webview_refresh"]];
        }
    } else {
        _existRefresh = NO;
    }
    if ([[_notice.btn objectAtIndex:1] integerValue] == 1) {
        _existClose = YES;
        if (_isLight) {
            [_rightBtnList addObject:[UIImage imageNamed:@"ic_webview_close_white"]];
        } else {
            [_rightBtnList addObject:[UIImage imageNamed:@"ic_webview_close"]];
        }
    } else {
        _existClose = NO;
    }
    _customNav = [[ZXCustomNavView alloc] initWithLeftContent:backImg title:_notice.title titleColor:titleColor rightContent:_rightBtnList leftDot:NO];
    [_customNav setBackgroundColor:![UtilsMacro whetherIsEmptyWithObject:_notice.bar_bgcolor] ? [UtilsMacro colorWithHexString:_notice.bar_bgcolor] : [UIColor whiteColor]];
    
    __weak typeof(self) weakSelf = self;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        if ([[weakSelf.notice.btn objectAtIndex:0] integerValue] == 0) {
            return;
        }
        if ([weakSelf.wkWebView canGoBack]) {
            [weakSelf.wkWebView goBack];
            return;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        switch (btn.tag) {
            case 0:
            {
                switch ([weakSelf.rightBtnList count]) {
                    case 1:
                    {
                        if (weakSelf.existClose) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        } else if (weakSelf.existRefresh) {
                            if (!weakSelf.isLoading) {
                                weakSelf.isLoading = YES;
                                [weakSelf.wkWebView reload];
                            }
                        }
                    }
                        break;
                    case 2:
                    {
                        if (!weakSelf.isLoading) {
                            weakSelf.isLoading = YES;
                            [weakSelf.wkWebView reload];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 1:
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:_customNav];
    if ([_notice.bar_style isEqualToString:@"light"]) {
        self.barStyle = UIStatusBarStyleLightContent;
    } else {
        self.barStyle = UIStatusBarStyleDefault;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    [_customNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0.0);
        make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT);
    }];
}

- (void)createBackBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_isLight) {
            [_backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
        } else {
            [_backBtn setImage:[UIImage imageNamed:@"ic_whole_back"] forState:UIControlStateNormal];
        }
        [_backBtn addTarget:self action:@selector(handleTapBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
            make.width.mas_equalTo(60.0);
            make.height.mas_equalTo(NAVIGATION_HEIGHT);
        }];
    }
}

- (void)createWkWebView {
    if (!_wkWebView) {
        _wkWebView = [[DWKWebView alloc] initWithFrame:CGRectZero];
        [_wkWebView.scrollView setBounces:_notice.bounce];
        _wkWebView.allowsBackForwardNavigationGestures = NO;
//        [_wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
//        [_wkWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    [self.view addSubview:_wkWebView];
    [self tz_addPopGestureToView:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0);
        if ([self.notice.is_fullpage integerValue] == 1) {
            make.top.mas_equalTo(0.0);
        } else {
            make.top.mas_equalTo(self.customNav.mas_bottom);
        }
    }];
    
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [_wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable agent, NSError * _Nullable error) {
//        NSLog(@"agent=====>%@",agent);
        [self.wkWebView setCustomUserAgent:[NSString stringWithFormat:@"%@;zxAPP",agent]];
    }];
    
    _universalUtil = [[ZXUniversalUtil alloc] init];
    [_universalUtil setWkWebView:_wkWebView];
    [_universalUtil setTopVC:self];
    //设置状态栏&&导航栏
    __weak typeof(self) weakSelf = self;
    _universalUtil.zxUniversalUtilSetBarBlcok = ^(id  _Nonnull data) {
        NSDictionary *params = [[NSDictionary alloc] initWithDictionary:data];
        if ([[params allKeys] containsObject:@"bgcolor"]) {
//            [weakSelf.customNav setBackgroundColor:[UtilsMacro colorWithHexString:[params valueForKey:@"bgcolor"]]];
            [weakSelf.notice setBar_bgcolor:[params valueForKey:@"bgcolor"]];
            [weakSelf configNavBar];
        }
        if ([[params allKeys] containsObject:@"style"]) {
            [weakSelf.notice setBar_style:[params valueForKey:@"style"]];
            [weakSelf configNavBar];
        }
    };
    //设置标题
    _universalUtil.zxUniversalUtilSetTitleBlock = ^(id  _Nonnull data) {
        NSDictionary *params = [[NSDictionary alloc] initWithDictionary:data];
        if ([[params allKeys] containsObject:@"title"] && ![UtilsMacro whetherIsEmptyWithObject:[params valueForKey:@"title"]]) {
            [weakSelf.notice setTitle:[params valueForKey:@"title"]];
            [weakSelf configNavBar];
        }
    };
    //显隐按钮
    _universalUtil.zxUniversalUtilDisplayBtnBlock = ^(id  _Nonnull data) {
        NSDictionary *param = [[NSDictionary alloc] initWithDictionary:data];
        if ([[param  allKeys] containsObject:@"btn"] && ![UtilsMacro whetherIsEmptyWithObject:[param valueForKey:@"btn"]] && [[param valueForKey:@"btn"] isKindOfClass:[NSArray class]]) {
            NSArray *btns = [[NSArray alloc] initWithArray:[param valueForKey:@"btn"]];
            weakSelf.rightBtnList = [[NSMutableArray alloc] init];
            UIImage *backImg;
            if ([btns count] > 0) {
                if ([[btns objectAtIndex:0] integerValue] == 0) {
                    backImg = [UIImage new];
                } else {
                    if (weakSelf.isLight) {
                        backImg = [UIImage imageNamed:@"ic_back_white"];
                    } else {
                        backImg = [UIImage imageNamed:@"ic_whole_back"];
                    }
                }
            } else {
                backImg = [UIImage new];
            }
            if ([btns count] > 1) {
                if ([[btns objectAtIndex:2] integerValue] == 1) {
                    weakSelf.existRefresh = YES;
                    if (weakSelf.isLight) {
                        [weakSelf.rightBtnList addObject:[UIImage imageNamed:@"ic_webview_refresh_white"]];
                    } else {
                        [weakSelf.rightBtnList addObject:[UIImage imageNamed:@"ic_webview_refresh"]];
                    }
                } else {
                    weakSelf.existRefresh = NO;
                }
            } else {
                weakSelf.existRefresh = NO;
            }
            if ([btns count] > 2) {
                if ([[btns objectAtIndex:1] integerValue] == 1) {
                    weakSelf.existClose = YES;
                    if (weakSelf.isLight) {
                        [weakSelf.rightBtnList addObject:[UIImage imageNamed:@"ic_webview_close_white"]];
                    } else {
                        [weakSelf.rightBtnList addObject:[UIImage imageNamed:@"ic_webview_close"]];
                    }
                } else {
                    weakSelf.existClose = NO;
                }
            } else {
                weakSelf.existClose = NO;
            }
//            NSLog(@"rightBtnList:%@",weakSelf.rightBtnList);
            [weakSelf.customNav setRightContent:weakSelf.rightBtnList];
        }
    };
    [_wkWebView addJavascriptObject:_universalUtil namespace:@"zxApp"];
    [_wkWebView setDebugMode:YES];
    [_wkWebView setDSUIDelegate:self];
    _wkWebView.navigationDelegate = self;
}

- (void)evaluateJavaStr:(NSString *)str {
    [_wkWebView evaluateJavaScript:str completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"result====>%@",result);
    }];
}

- (void)fetchGoodsCouponInWK {
//    NSLog(@"获取商品的优惠券信息");
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingForView:self.view];
        [[ZXUrlCouponHelper sharedInstance] fetchUrlCouponWithUrl:_wkWebView.URL.absoluteString completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideHUDForView:self.view];
//            NSLog(@"response===>%@",response.data);
            self.urlCoupon = [ZXUrlCoupon yy_modelWithJSON:response.data];
            [self evaluateJavaStr:self.urlCoupon.js];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideHUDForView:self.view];
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)pushToShareVCInWK {
//    NSLog(@"跳转到商品分享页");
    if (![[ZXTBAuthHelper sharedInstance] tbAuthState]) {
        [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
        return;
    }
    ZXShareVC *shareVC = [[ZXShareVC alloc] init];
    [shareVC setIdStr:@""];
    [shareVC setItem_id:_urlCoupon.item_id];
    [shareVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)openTaoBaoInWK {
//    NSLog(@"打开淘宝，领券购买");
    __weak typeof(self) weakSelf = self;
    _jumpTBView = [[ZXJumpTBView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSDictionary *awardInfo = @{@"coupon_amount":_urlCoupon.coupon_amount, @"commission":_urlCoupon.commission};
    [_jumpTBView setAwardInfo:awardInfo];
    _jumpTBView.zxJumpTBViewBtnClick = ^(NSInteger btnTag) {
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.jumpTBView.containerView endRemove:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.jumpTBView removeFromSuperview];
            weakSelf.jumpTBView = nil;
        });
        [[ZXNewService sharedManager] cancelCurrentRequest];
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:_jumpTBView];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:_jumpTBView.containerView endRemove:NO];
    
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXGoodsCouponHelper sharedInstance] fetchGoodsCouponWithId:@"" andItem_id:_urlCoupon.item_id completion:^(ZXResponse * _Nonnull response) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:self.jumpTBView.containerView endRemove:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.jumpTBView removeFromSuperview];
                    self.jumpTBView = nil;
                });
                if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"coupon_click_url"]]) {
                    [ZXProgressHUD loadFailedWithMsg:@"暂无优惠券"];
                    return;
                }
                AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
                showParam.openType = AlibcOpenTypeAuto;
                showParam.isNeedPush = YES;
                showParam.nativeFailMode = AlibcNativeFailModeJumpDownloadPage;
                showParam.isNeedCustomNativeFailMode = YES;
                showParam.degradeUrl = @"https://mos.m.taobao.com/activity_newer";
                [[[AlibcTradeSDK sharedInstance] tradeService] openByUrl:[response.data valueForKey:@"coupon_click_url"] identity:@"trade" webView:nil parentController:self showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                    
                } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                }];
            });
        } error:^(ZXResponse * _Nonnull response) {
            if (response.status == 2) {
                [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:self.jumpTBView.containerView endRemove:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.jumpTBView removeFromSuperview];
                    self.jumpTBView = nil;
                });
                [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
                return;
            }
            if (response.status == -999) {
                return;
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//    NSLog(@"message:%@",message);
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"name:%@",message.name);
//    NSLog(@"body:%@",message.body);
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [ZXProgressHUD loadingForView:self.view];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    NSLog(@"didCommitNavigation");
    [ZXProgressHUD hideHUDForView:self.view];
    [self evaluateJavaStr:[[[ZXAppConfigHelper sharedInstance] appConfig] tb_hack_js]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"didFinishNavigation");
    [ZXProgressHUD hideHUDForView:self.view];
    _isLoading = NO;
    [_backBtn setHidden:YES];
    [_wkWebView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        [self.customNav.titleLab setText:![UtilsMacro whetherIsEmptyWithObject:title] ? title : self.notice.title];
    }];
    [self evaluateJavaStr:[[[ZXAppConfigHelper sharedInstance] appConfig] tb_hack_js]];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    _isLoading = NO;
    [ZXProgressHUD hideHUDForView:self.view];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"zxurl://get_coupon_income"].location != NSNotFound) {
        [ZXProgressHUD hideHUDForView:self.view];
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        [self fetchGoodsCouponInWK];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"zxurl://to_share"].location != NSNotFound) {
        [ZXProgressHUD hideHUDForView:self.view];
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        [self pushToShareVCInWK];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"zxurl://get_coupon"].location != NSNotFound) {
        [ZXProgressHUD hideHUDForView:self.view];
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        [self openTaoBaoInWK];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - Button Methods

- (void)handleTapBackBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
