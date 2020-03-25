//
//  ALiTradeWantViewController.m
//  ALiSDKAPIDemo
//
//  Created by com.; on 16/6/1.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALiTradeWebViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

//#import "ALiCartService.h"

@interface ALiTradeWebViewController()

@property (strong, nonatomic) dispatch_source_t timer;

@property (assign, nonatomic) NSTimeInterval period;

@property (strong, nonatomic) dispatch_queue_t queue;

@property (assign, nonatomic) NSInteger authSec;

@end

@implementation ALiTradeWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.scrollView.scrollEnabled = YES;
        [_webView setHidden:YES];
//        _webView.delegate = self;
        [self.view addSubview:_webView];
        
        [ZXProgressHUD loading];
        _period = 1.0f;
        _authSec = 0;
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), _period * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkUrlString];
            });
        });
        dispatch_resume(_timer);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_source_cancel(self.timer);
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"淘你喜欢";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)setOpenUrl:(NSString *)openUrl {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:openUrl]]];
}

#pragma mark - Private Methods

- (void)checkUrlString {
//    NSLog(@"%s=====>%@",__FUNCTION__, _webView.request.URL.absoluteString);
    if (![UtilsMacro whetherIsEmptyWithObject:_webView.request.URL.absoluteString]) {
        _authSec++;
        if (_authSec <= 10) {
            if ([_webView.request.URL.absoluteString rangeOfString:[[[ZXAppConfigHelper sharedInstance] appConfig] tb_auth_check_str]].location == NSNotFound) {
                NSString *click = @"document.getElementById('J_Submit').click()";
                [_webView stringByEvaluatingJavaScriptFromString:click];
            } else {
                dispatch_source_cancel(_timer);
                [ZXProgressHUD hideAllHUD];
                NSString *codeUrlStr = _webView.request.URL.absoluteString;
                self.taoBaoAuthCodeBlock(codeUrlStr);
            }
        } else {
            dispatch_source_cancel(_timer);
            [ZXProgressHUD loadFailedWithMsg:@"授权超时"];
        }
    }
}


@end
