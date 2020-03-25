//
//  ZXFansWakeView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansWakeView.h"
#import <Masonry/Masonry.h>

@implementation ZXFansWakeView

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

#pragma makr - Private Method

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(290.0);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_mainView.layer setCornerRadius:10.0];
        [_mainView setClipsToBounds:YES];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(290.0);
        }];
    }
    
    if (!_userImg) {
        _userImg = [[UIImageView alloc] init];
        [_userImg setContentMode:UIViewContentModeScaleAspectFill];
        [_userImg.layer setCornerRadius:32.0];
        [_userImg setBackgroundColor:THEME_COLOR];
        [_mainView addSubview:_userImg];
        [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(64.0);
            make.height.mas_equalTo(64.0);
            make.centerX.mas_equalTo(self.mainView);
            make.top.mas_equalTo(self.mainView).mas_offset(40.0);
        }];
    }
    
    if (!_wxView) {
        _wxView = [[UIView alloc] init];
        [_mainView addSubview:_wxView];
        [_wxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.0).priorityLow();
            make.centerX.mas_equalTo(self.mainView);
            make.height.mas_equalTo(20.0);
            make.top.mas_equalTo(self.userImg.mas_bottom).mas_offset(30.0);
        }];
    }
    
    if (!_wxLab) {
        _wxLab = [[UILabel alloc] init];
        [_wxLab setFont:[UIFont systemFontOfSize:15.0]];
        [_wxLab setTextColor:HOME_TITLE_COLOR];
        [_wxLab setTextAlignment:NSTextAlignmentCenter];
        [_wxLab setText:@"微信号：45651315"];
        [_wxView addSubview:_wxLab];
        [_wxLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wxView);
            make.height.mas_equalTo(20.0);
            make.top.mas_equalTo(self.wxView);
            make.width.mas_equalTo(0.0).priorityLow();
            make.right.mas_equalTo(self.wxView).mas_offset(-27.0);
        }];
    }
    
    if (!_cpBtn) {
        _cpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_cpBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_cpBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"FFE5CE"]];
        [_cpBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_cpBtn setTag:1];
        [_cpBtn.layer setCornerRadius:5.0];
        [_cpBtn addTarget:self action:@selector(handleTapFansWakeViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_cpBtn];
        [_cpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.wxView);
            make.left.mas_equalTo(self.wxLab.mas_right).mas_offset(7.0);
            make.width.mas_equalTo(40.0);
            make.height.mas_equalTo(20.0);
        }];
    }
    
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setFont:[UIFont systemFontOfSize:10.0]];
        [_timeLab setTextColor:COLOR_999999];
        [_timeLab setTextAlignment:NSTextAlignmentCenter];
        [_timeLab setText:@"2019-09-06  18:06:54"];
        [_mainView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainView);
            make.right.mas_equalTo(self.mainView);
            make.height.mas_equalTo(12.0);
            make.top.mas_equalTo(self.wxView.mas_bottom).mas_offset(20.0);
        }];
    }
    
    if (!_wakeBtn) {
        _wakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wakeBtn setTitle:@"分享唤醒链接" forState:UIControlStateNormal];
        [_wakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_wakeBtn setBackgroundColor:THEME_COLOR];
        [_wakeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_wakeBtn setTag:2];
        [_wakeBtn.layer setCornerRadius:20.0];
        [_wakeBtn addTarget:self action:@selector(handleTapFansWakeViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_wakeBtn];
        [_wakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(30.0);
            make.centerX.mas_equalTo(self.mainView);
            make.width.mas_equalTo(180.0);
            make.height.mas_equalTo(40.0);
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn setTag:0];
        [_closeBtn addTarget:self action:@selector(handleTapFansWakeViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(30.0);
            make.height.width.mas_equalTo(32.0);
            make.centerX.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapFansWakeViewButtonAction:(id)sender {
    if (self.zxFansWakeViewClickCloseBtn) {
        UIButton *btn = (UIButton *)sender;
        self.zxFansWakeViewClickCloseBtn(btn);
    }
}

@end
