//
//  ZXJumpTBView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXJumpTBViewBtnClick)(NSInteger btnTag);

@interface ZXJumpTBView : UIView

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) NSDictionary *awardInfo;

@property (copy, nonatomic) ZXJumpTBViewBtnClick zxJumpTBViewBtnClick;

@end

NS_ASSUME_NONNULL_END
