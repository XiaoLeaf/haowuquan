//
//  ZXEarningHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningHeaderView.h"
#import <Masonry/Masonry.h>

@implementation ZXEarningHeaderView

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
        [self createSubViews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(self);
        }];
    }
    
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        [_bgImgView setContentMode:UIViewContentModeScaleAspectFill];
//        [_bgImgView setImage:[UIImage imageNamed:@"icon_earning_bg"]];
        [_mainView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView);
            make.left.mas_equalTo(self.mainView);
            make.right.mas_equalTo(self.mainView);
            make.bottom.mas_equalTo(self.mainView);
        }];
    }
    
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        [_totalLab setText:@"累计收益（元）"];
        [_totalLab setTextColor:[UtilsMacro colorWithHexString:@"87B0FF"]];
        [_totalLab setFont:[UIFont systemFontOfSize:12.0]];
        [_mainView addSubview:_totalLab];
        [_totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(22.0);
            make.left.mas_equalTo(27.0);
            make.height.mas_equalTo(15.0);
//            make.width.mas_equalTo(40.0).priorityLow();
        }];
    }
    
    if (!_countLab) {
        _countLab = [[UICountingLabel alloc] init];
        [_countLab setFont:[UIFont systemFontOfSize:36.0]];
        [_countLab setTextColor:[UIColor whiteColor]];
        [_countLab setText:@"0.00"];
        [_countLab setFormat:@"%.2f"];
        [_countLab setAnimationDuration:0.5];
        [_mainView addSubview:_countLab];
        [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27.0);
            make.top.mas_equalTo(self.totalLab.mas_bottom).mas_offset(14.0);
            make.height.mas_equalTo(30.0);
//            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_balanceLab) {
        _balanceLab = [[UILabel alloc] init];
        [_balanceLab setFont:[UIFont systemFontOfSize:12.0]];
        [_balanceLab setTextColor:[UtilsMacro colorWithHexString:@"87B0FF"]];
        [_balanceLab setText:@"账户余额(元):0.00"];
        [_mainView addSubview:_balanceLab];
        [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.countLab.mas_bottom).mas_offset(20.0);
            make.left.mas_equalTo(27.0);
            make.height.mas_equalTo(15.0);
//            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_withdrawBtn) {
        _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"FD5B19"]];
        [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_withdrawBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_withdrawBtn.layer setCornerRadius:7.5];
        [_withdrawBtn.layer setMasksToBounds:YES];
        [_withdrawBtn setClipsToBounds:YES];
        [_withdrawBtn addTarget:self action:@selector(handleTapWithdrawBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_withdrawBtn];
        [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.countLab.mas_bottom).mas_offset(20.0);
            make.left.mas_equalTo(self.balanceLab.mas_right).mas_offset(10.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(40.0);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapWithdrawBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(earningHeaderViewHandleTapWithdrawBtnAction)]) {
        [self.delegate earningHeaderViewHandleTapWithdrawBtnAction];
    }
}

@end
