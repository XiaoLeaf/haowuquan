//
//  ALiTradeWantViewController.h
//  ALiSDKAPIDemo
//
//  Created by com.alibaba on 16/6/1.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#ifndef ALiTradeWantViewController_h
#define ALiTradeWantViewController_h

#import <UIKit/UIKit.h>

typedef void (^TaoBaoAuthCodeBlock) (NSString *authCode);

@interface ALiTradeWebViewController : UIViewController<UIWebViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, copy) NSString *openUrl;

@property (strong, nonatomic) UIWebView *webView;

@property (nonatomic, copy) TaoBaoAuthCodeBlock taoBaoAuthCodeBlock;

@end

#endif /* ALiTradeWantViewController_h */
