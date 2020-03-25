//
//  ZXRedEnvelopView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXRedEnvelop.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXRedEnvelopViewBtnClick)(NSInteger btnTag);

typedef void(^ZXRedEnvelopViewBgImgComplete)(void);

@interface ZXRedEnvelopView : UIView

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) ZXRedEnvelop *redEnvelop;

@property (copy, nonatomic) ZXRedEnvelopViewBtnClick zxRedEnvelopViewBtnClick;

@property (copy, nonatomic) ZXRedEnvelopViewBgImgComplete zxRedEnvelopViewBgImgComplete;

@end

NS_ASSUME_NONNULL_END
