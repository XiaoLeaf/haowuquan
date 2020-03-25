//
//  ZXWelfareViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXWelfareViewController.h"
#import <Masonry/Masonry.h>

@interface ZXWelfareViewController () <WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate>

@property (strong, nonatomic) ZXUniversalUtil *universalUtil;

@property (strong, nonatomic) DWKWebView *wkWebView;

@property (strong, nonatomic) UIButton *reloadBtn;

@end

@implementation ZXWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (!_wkWebView.canGoBack) {
//        [_wkWebView reload];
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [ZXProgressHUD hideHUDForView:self.view];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)createSubviews {
    _wkWebView = [[DWKWebView alloc] init];
    [_wkWebView.scrollView setBounces:NO];
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    [_wkWebView loadUrl:[[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] member] url]];
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.0);
    }];
    
    _universalUtil = [[ZXUniversalUtil alloc] init];
    [_universalUtil setWkWebView:_wkWebView];
    [_universalUtil setTopVC:self];
    [_wkWebView addJavascriptObject:_universalUtil namespace:@"zxApp"];
    [_wkWebView setDebugMode:YES];
    [_wkWebView setNavigationDelegate:self];
    [_wkWebView setDSUIDelegate:self];
}

- (void)reloadMemberUrl {
    [_reloadBtn setHidden:YES];
    [_wkWebView loadUrl:[[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] member] url]];
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
    [ZXProgressHUD hideHUDForView:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [ZXProgressHUD hideHUDForView:self.view];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [ZXProgressHUD hideHUDForView:self.view];
//    NSLog(@"error====>%@",error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s====>%@", __FUNCTION__, error);
    [ZXProgressHUD hideHUDForView:self.view];
//    if (!_reloadBtn) {
//        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
//        [_reloadBtn setBackgroundColor:THEME_COLOR];
//        [_reloadBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//        [_reloadBtn addTarget:self action:@selector(reloadMemberUrl) forControlEvents:UIControlEventTouchUpInside];
//        [_reloadBtn.layer setCornerRadius:5.0];
//        [self.view addSubview:_reloadBtn];
//        [_reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self.view);
//            make.height.mas_equalTo(40.0);
//            make.width.mas_equalTo(200.0);
//        }];
//    } else {
//        [_reloadBtn setHidden:NO];
//    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
