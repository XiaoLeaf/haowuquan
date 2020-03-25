//
//  ZXFansTabView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansTabView.h"
#import <Masonry/Masonry.h>
#import "ZXFansPopView.h"

@implementation ZXFansTabView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_fans_bg.png"]];
        [_bgImgView setContentMode:UIViewContentModeScaleAspectFill];
        [_mainView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    
    if (!_countLab) {
        _countLab = [[UICountingLabel alloc] init];
        [_countLab setTextColor:[UIColor whiteColor]];
        [_countLab setFont:[UIFont systemFontOfSize:30.0]];
        [_countLab setTextAlignment:NSTextAlignmentCenter];
        [_countLab setText:@"0"];
        [_countLab setFormat:@"%d"];
        [_countLab setAnimationDuration:0.5];
        [_mainView addSubview:_countLab];
        [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_mainView.mas_top).mas_offset(STATUS_HEIGHT + 44.0 + 25.0);
            make.left.mas_equalTo(self->_mainView);
            make.right.mas_equalTo(self->_mainView);
            make.height.mas_equalTo(22.0);
        }];
    }
    
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
        [_tipView setBackgroundColor:[UIColor clearColor]];
        [_mainView addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self->_mainView);
            make.height.mas_equalTo(16.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(self->_countLab.mas_bottom).mas_offset(10.0);
        }];
    }
    
    if (!_problemBtn) {
        _problemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_problemBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_problemBtn setTitle:@"总粉丝数" forState:UIControlStateNormal];
//        [_problemBtn setImage:[UIImage imageNamed:@"ic_fans_problem.png"] forState:UIControlStateNormal];
        [_problemBtn setAdjustsImageWhenHighlighted:NO];
        [_problemBtn setTitleColor:[UtilsMacro colorWithHexString:@"FFBBB8"] forState:UIControlStateNormal];
        [_problemBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_problemBtn setTag:0];
//        [_problemBtn addTarget:self action:@selector(handleTapFansTabViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tipView addSubview:_problemBtn];
        [_problemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_tipView);
            make.right.mas_equalTo(self->_tipView);
            make.bottom.mas_equalTo(self->_tipView);
            make.top.mas_equalTo(self->_tipView);
        }];
    }
    
    if (!_inviteView) {
        _inviteView = [[UIView alloc] init];
        [_inviteView setBackgroundColor:[UIColor clearColor]];
        [_mainView addSubview:_inviteView];
        [_inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_mainView);
            make.right.mas_equalTo(self->_mainView);
            make.top.mas_equalTo(self->_tipView.mas_bottom).mas_offset(20.0);
            make.height.mas_equalTo(20.0);
        }];
    }
    
    if (!_inviteLab) {
        _inviteLab = [[UILabel alloc] init];
        [_inviteLab setTextAlignment:NSTextAlignmentCenter];
        [_inviteLab setFont:[UIFont systemFontOfSize:12.0]];
        [_inviteLab setText:@"邀请人：-"];
        [_inviteLab setTextColor:[UtilsMacro colorWithHexString:@"FFBBB8"]];
        [_inviteView addSubview:_inviteLab];
    }
    
    UIView *wxView = [[UIView alloc] init];
    [wxView setBackgroundColor:[UIColor clearColor]];
    [_inviteView addSubview:wxView];
    
    NSMutableArray *viewList = [[NSMutableArray alloc] initWithObjects:_inviteLab, wxView, nil];
    [viewList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.bottom.mas_equalTo(0.0);
    }];
    
    if (!_wxLab) {
        _wxLab = [[UILabel alloc] init];
        [_wxLab setTextColor:[UtilsMacro colorWithHexString:@"FFBBB8"]];
        [_wxLab setFont:[UIFont systemFontOfSize:12.0]];
        [_wxLab setText:@"微信号：-"];
        [wxView addSubview:_wxLab];
        [_wxLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wxView);
            make.top.mas_equalTo(wxView);
            make.bottom.mas_equalTo(wxView);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_cpBtn) {
        _cpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_cpBtn setClipsToBounds:YES];
        [_cpBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_cpBtn setTitleColor:[UtilsMacro colorWithHexString:@"F13C49"] forState:UIControlStateNormal];
        [_cpBtn setTag:1];
        [_cpBtn addTarget:self action:@selector(handleTapFansTabViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cpBtn setBackgroundColor:[UIColor whiteColor]];
        [wxView addSubview:_cpBtn];
        [_cpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_wxLab.mas_right).mas_offset(10.0);
            make.top.mas_equalTo(wxView).mas_offset(1.0);
            make.bottom.mas_equalTo(wxView).mas_offset(-1.0);
            make.width.mas_equalTo(30.0);
        }];
        [_cpBtn.layer setCornerRadius:9.0];
//        [_cpBtn.layer setMasksToBounds:YES];
    }
    
    if (!_fetchInviteView) {
        _fetchInviteView = [[UIView alloc] init];
        [_fetchInviteView setBackgroundColor:[UIColor clearColor]];
        [_fetchInviteView setHidden:YES];
        [_mainView addSubview:_fetchInviteView];
        [_fetchInviteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_mainView);
            make.right.mas_equalTo(self->_mainView);
            make.top.mas_equalTo(self->_tipView.mas_bottom).mas_offset(20.0);
            make.height.mas_equalTo(20.0);
        }];
    }

    if (!_fetchBtn) {
        _fetchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchBtn setTitle:@"获取邀请码" forState:UIControlStateNormal];
        [_fetchBtn setTitleColor:[UtilsMacro colorWithHexString:@"F13C49"] forState:UIControlStateNormal];
        [_fetchBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_fetchBtn setBackgroundColor:[UIColor whiteColor]];
        [_fetchBtn.layer setCornerRadius:10.0];
        [_fetchBtn setTag:2];
        [_fetchBtn addTarget:self action:@selector(handleTapFansTabViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fetchInviteView addSubview:_fetchBtn];
        [_fetchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.fetchInviteView);
            make.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(80.0);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapFansTabViewButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansTabViewHandleTapButtonActionWithTag:)]) {
        [self.delegate fansTabViewHandleTapButtonActionWithTag:button.tag];
    }
}

@end
