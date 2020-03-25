//
//  ZXFansSecHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXFansSecHeaderViewBtnClick)(NSInteger btnTag);

@interface ZXFansSecHeaderView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *sortView;

@property (strong, nonatomic) UIButton *lastBtn;

@property (strong, nonatomic) UIButton *fansBtn;

@property (strong, nonatomic) UIButton *operateBtn;

@property (copy, nonatomic) ZXFansSecHeaderViewBtnClick zxFansSecHeaderViewBtnClick;

@end

NS_ASSUME_NONNULL_END
