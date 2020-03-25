//
//  ZXTBAuthView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXTBAuthViewBtnClick)(NSInteger btnTag);

@interface ZXTBAuthView : UIView

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UIImageView *logoImg;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *contentLab;

@property (strong, nonatomic) UIButton *authBtn;

@property (copy, nonatomic) ZXTBAuthViewBtnClick zxTBAuthViewBtnClick;

@end

NS_ASSUME_NONNULL_END
