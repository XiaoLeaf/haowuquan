//
//  ZXMessageVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMessageVC.h"
#import <dsbridge/dsbridge.h>
#import <Masonry/Masonry.h>

@interface ZXMessageVC () <WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate> {
    WKUserContentController* userContent;
}

@property (strong, nonatomic) DWKWebView *wkWebView;

@property (strong, nonatomic) ZXUniversalUtil *universalUtil;

@end

@implementation ZXMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    [self createWkWebView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [ZXProgressHUD hideHUDForView:self.view];
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

- (void)createWkWebView {
    if (!_wkWebView) {
        _wkWebView = [[DWKWebView alloc] init];
        [_wkWebView.scrollView setBounces:NO];
        [self.view addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0.0);
        }];
        _universalUtil = [[ZXUniversalUtil alloc] init];
        [_universalUtil setWkWebView:_wkWebView];
        [_universalUtil setTopVC:self];
        [_wkWebView addJavascriptObject:_universalUtil namespace:@"zxApp"];
        [_wkWebView setDebugMode:YES];
        [_wkWebView setDSUIDelegate:self];
        _wkWebView.navigationDelegate = self;
    }
    
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:![UtilsMacro whetherIsEmptyWithObject:[[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] message] url]] ? [[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] message] url] : @"https://baidu.com"]]];
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
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"didFinishNavigation");
    [ZXProgressHUD hideHUDForView:self.view];
//    [[ZXUniversalUtil sharedInstance] reset_badge];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"error====>%@",error);
    [ZXProgressHUD hideHUDForView:self.view];
}

@end
