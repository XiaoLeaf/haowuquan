//
//  ZXScorePopView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXScorePop.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXScorePopViewClick)(void);

@interface ZXScorePopView : UIView

@property (strong, nonatomic) ZXScorePop *scorePop;

@property (strong, nonatomic) UIView *containerView;

@property (copy, nonatomic) ZXScorePopViewClick zxScorePopViewClick;

@end

NS_ASSUME_NONNULL_END
