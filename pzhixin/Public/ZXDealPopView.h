//
//  ZXDealPopView.h
//  pzhixin
//
//  Created by zhixin on 2019/12/10.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDealPopView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (copy, nonatomic) void (^zxDealPopViewBtnClick) (NSInteger btnTag);

@property (strong, nonatomic) ZXPolicy *policy;

@end

NS_ASSUME_NONNULL_END
