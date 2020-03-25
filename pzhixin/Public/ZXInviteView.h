//
//  ZXInviteView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/10.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXInviteViewBtnClick)(NSInteger btnTag);

@interface ZXInviteView : UIView

@property (strong, nonatomic) UIView *containerView;

@property (copy, nonatomic) ZXInviteViewBtnClick zxInviteViewBtnClick;

@property (strong, nonatomic) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
