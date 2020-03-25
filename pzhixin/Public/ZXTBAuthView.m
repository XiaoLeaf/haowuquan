//
//  ZXTBAuthView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXTBAuthView.h"
#import <Masonry/Masonry.h>

@implementation ZXTBAuthView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.74]];
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(43.0);
            make.right.mas_equalTo(-43.0);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_mainView setClipsToBounds:YES];
        [_mainView.layer setCornerRadius:10.0];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] init];
        [_logoImg setContentMode:UIViewContentModeScaleAspectFit];
        [_logoImg setImage:[UIImage imageNamed:@"ic_toast_taobao"]];
        [_mainView addSubview:_logoImg];
        [_logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(39.0);
            make.width.height.mas_equalTo(54.0);
            make.centerX.mas_equalTo(self.mainView);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setText:@"请完成淘宝授权"];
        [_titleLab setTextColor:HOME_TITLE_COLOR];
        [_titleLab setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_mainView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logoImg.mas_bottom).mas_offset(20.0);
            make.left.right.mas_equalTo(0.0);
        }];
    }
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_mainView addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(18.0);
        }];
    }
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        [_contentLab setNumberOfLines:0];
        [_contentLab setTextColor:COLOR_666666];
        [_contentLab setTextAlignment:NSTextAlignmentCenter];
        [_contentLab setFont:[UIFont systemFontOfSize:12.0]];
        [_contentLab setPreferredMaxLayoutWidth:SCREENWIDTH - 196.0];
        [_contentLab setText:@"淘宝授权后下单或分享商品，可获得收益哦~"];
        [_contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(55.0);
            make.right.mas_equalTo(-55.0);
        }];
    }
    
    if (!_authBtn) {
        _authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authBtn setBackgroundColor:THEME_COLOR];
        [_authBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_authBtn setTitle:@"去授权" forState:UIControlStateNormal];
        [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_authBtn.layer setCornerRadius:20.0];
        [_authBtn setTag:1];
        [_authBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_authBtn];
        [_authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).mas_offset(50.0);
            make.height.mas_equalTo(40.0);
            make.left.mas_equalTo(55.0);
            make.right.mas_equalTo(-55.0);
            make.bottom.mas_equalTo(-35.0).priorityHigh();
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn setTag:0];
        [_closeBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(30.0);
            make.height.width.mas_equalTo(32.0);
            make.centerX.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0.0);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapBtnsAction:(UIButton *)button {
    if (self.zxTBAuthViewBtnClick) {
        self.zxTBAuthViewBtnClick(button.tag);
    }
}

@end
