//
//  ZXFansWakeView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXFansWakeViewClickCloseBtn)(UIButton *button);

@interface ZXFansWakeView : UIView

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *userImg;

@property (strong, nonatomic) UIView *wxView;

@property (strong, nonatomic) UILabel *wxLab;

@property (strong, nonatomic) UIButton *cpBtn;

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIButton *wakeBtn;

@property (strong, nonatomic) UIButton *closeBtn;

@property (copy, nonatomic) ZXFansWakeViewClickCloseBtn zxFansWakeViewClickCloseBtn;

@end

NS_ASSUME_NONNULL_END
