//
//  ZXInviteView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/10.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXInviteView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZXInviteView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *wxLab;

@property (strong, nonatomic) UILabel *phoneLab;

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIImageView *userHead;

@property (strong, nonatomic) UIButton *bindBtn;

@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation ZXInviteView

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

#pragma mark - Setter

- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    if ([UtilsMacro whetherIsEmptyWithObject:[userInfo valueForKey:@"icon"]]) {
        [_userHead setImage:DEFAULT_HEAD_IMG];
    } else {
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:@"icon"]] imageView:_userHead placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[_userInfo valueForKey:@"nickname"]]) {
        [_wxLab setText:[NSString stringWithFormat:@"昵称:--"]];
    } else {
        [_wxLab setText:[NSString stringWithFormat:@"昵称:%@",[_userInfo valueForKey:@"nickname"]]];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[_userInfo valueForKey:@"tel"]]) {
        [_phoneLab setText:[NSString stringWithFormat:@"手机号:--"]];
    } else {
        [_phoneLab setText:[NSString stringWithFormat:@"手机号:%@",[_userInfo valueForKey:@"tel"]]];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[_userInfo valueForKey:@"c_time"]]) {
        [_timeLab setText:@"加入时间:--"];
    } else {
        [_timeLab setText:[NSString stringWithFormat:@"加入时间:%@",[_userInfo valueForKey:@"c_time"]]];
    }
    if ([[_userInfo valueForKey:@"is_valid"] integerValue] == 1) {
        [_bindBtn setUserInteractionEnabled:YES];
        [_bindBtn setBackgroundColor:THEME_COLOR];
        [_bindBtn setTitle:[_userInfo valueForKey:@"text"] forState:UIControlStateNormal];
    } else {
        [_bindBtn setUserInteractionEnabled:NO];
        [_bindBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"] ];
        [_bindBtn setTitle:[_userInfo valueForKey:@"text"] forState:UIControlStateNormal];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.left.mas_equalTo(43.0);
            make.right.mas_equalTo(-43.0);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_mainView.layer setCornerRadius:10.0];
        [_mainView setClipsToBounds:YES];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_userHead) {
        _userHead = [[UIImageView alloc] init];
        [_userHead setClipsToBounds:YES];
        [_userHead.layer setCornerRadius:32.0];
//        [_userHead setBackgroundColor:THEME_COLOR];
        [_userHead setContentMode:UIViewContentModeScaleAspectFill];
        [_mainView addSubview:_userHead];
        [_userHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(64.0);
            make.centerX.mas_equalTo(self.mainView);
            make.top.mas_equalTo(40.0);
        }];
    }
    
    if (!_wxLab) {
        _wxLab = [[UILabel alloc] init];
        [_wxLab setTextAlignment:NSTextAlignmentCenter];
        [_wxLab setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]];
        [_wxLab setTextColor:HOME_TITLE_COLOR];
        [_wxLab setText:@"昵称：4565131526"];
        [_mainView addSubview:_wxLab];
        [_wxLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(12.0);
            make.top.mas_equalTo(self.userHead.mas_bottom).mas_offset(26.0);
        }];
    }
    
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        [_phoneLab setTextAlignment:NSTextAlignmentCenter];
        [_phoneLab setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]];
        [_phoneLab setTextColor:HOME_TITLE_COLOR];
        [_phoneLab setText:@"手机号：134****2698"];
        [_mainView addSubview:_phoneLab];
        [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(12.0);
            make.top.mas_equalTo(self.wxLab.mas_bottom).mas_offset(17.0);
        }];
    }
    
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setTextAlignment:NSTextAlignmentCenter];
        [_timeLab setFont:[UIFont systemFontOfSize:10.0]];
        [_timeLab setTextColor:COLOR_999999];
        [_timeLab setText:@"2019-09-06  18:06:54"];
        [_mainView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(12.0);
            make.top.mas_equalTo(self.phoneLab.mas_bottom).mas_offset(15.0);
        }];
    }
    
    if (!_bindBtn) {
        _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindBtn setTitle:@"" forState:UIControlStateNormal];
        [_bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bindBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_bindBtn setTag:0];
        [_bindBtn setBackgroundColor:THEME_COLOR];
        [_bindBtn.layer setCornerRadius:20.0];
        [_bindBtn setClipsToBounds:YES];
        [_bindBtn addTarget:self action:@selector(handleTapInviteViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_bindBtn];
        [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40.0);
            make.left.mas_equalTo(54.0);
            make.right.mas_equalTo(-54.0);
            make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(20.0);
            make.bottom.mas_equalTo(-30.0).priorityHigh();
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn setTag:1];
        [_closeBtn addTarget:self action:@selector(handleTapInviteViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_equalTo(30.0);
            make.width.height.mas_equalTo(40.0);
            make.centerX.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapInviteViewBtnAction:(UIButton *)btn {
    if (self.zxInviteViewBtnClick) {
        self.zxInviteViewBtnClick(btn.tag);
    }
}

@end
