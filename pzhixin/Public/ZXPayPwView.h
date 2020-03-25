//
//  ZXPayPwView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXPayPwViewTapBlock)(void);

typedef void(^ZXPayPwViewPwBlock)(NSString *text, BOOL isFinished);

@interface ZXPayPwView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (copy, nonatomic) ZXPayPwViewTapBlock zxPayPwViewTapBlock;

@property (copy, nonatomic) ZXPayPwViewPwBlock zxPayPwViewPwBlock;

@end

NS_ASSUME_NONNULL_END
