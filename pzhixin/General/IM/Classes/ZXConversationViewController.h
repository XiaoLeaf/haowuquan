//
//  ZXConversationViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXNormalBaseViewController.h"
#import <TXIMSDK_TUIKit_iOS/TUIConversationListController.h>
#import <TXIMSDK_TUIKit_iOS/TPopView.h>
#import <TXIMSDK_TUIKit_iOS/TNaviBarIndicatorView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXConversationViewController : ZXNormalBaseViewController

@property (nonatomic, strong) TNaviBarIndicatorView *titleView;

@end

NS_ASSUME_NONNULL_END
