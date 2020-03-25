//
//  ZXPublicWKWebView.h
//  pzhixin
//
//  Created by zhixin on 2019/7/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ZXNotice.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *BridgeMethodStr NS_STRING_ENUM;
 
FOUNDATION_EXPORT BridgeMethodStr const BridgeMethodStrGetParams;
 
FOUNDATION_EXPORT BridgeMethodStr const BridgeMethodStrGetToken;
 
FOUNDATION_EXPORT BridgeMethodStr const BridgeMethodStrBarBtnAction;

@interface ZXPublicWKWebView : UIViewController

@property (strong, nonatomic) ZXNotice *notice;

@property (strong, nonatomic) NSString *titleStr;

@property (strong, nonatomic) NSString *urlStr;

@end

NS_ASSUME_NONNULL_END
