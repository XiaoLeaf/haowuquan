//
//  ZXRankHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRankHeaderView.h"
#import <Masonry/Masonry.h>

@interface ZXRankHeaderView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *rankImg;

@property (strong, nonatomic) UIView *hintView;

@property (strong, nonatomic) UIImageView *hintBg;

@property (strong, nonatomic) UIImageView *headImg;

@property (strong, nonatomic) UILabel *contentLab;

@end

@implementation ZXRankHeaderView

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
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Method

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_topView) {
        _topView = [[UIView alloc] init];
        [_topView setAlpha:0.8];
        [_topView setBackgroundColor:[UtilsMacro colorWithHexString:@"FDFBEC"]];
        [_mainView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(0.0);
        }];
    }
    
    if (!_rankScroll) {
        _rankScroll = [[SGAdvertScrollView alloc] init];
        [_rankScroll setTitleColor:THEME_COLOR];
        [_topView addSubview:_rankScroll];
        [_rankScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0);
            make.top.bottom.mas_equalTo(0.0);
            make.right.mas_equalTo(-12.0);
        }];
    }
    
    if (!_rankImg) {
        _rankImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_ranklist_bg"]];
        [_rankImg setContentMode:UIViewContentModeScaleAspectFill];
        [_rankImg setClipsToBounds:YES];
        [_mainView addSubview:_rankImg];
        [_rankImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0.0);
            make.top.mas_equalTo(10.0);
        }];
    }

    if (!_hintView) {
        _hintView = [[UIView alloc] init];
        [_hintView setHidden:YES];
        [_mainView addSubview:_hintView];
        [_hintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20.0);
            make.height.mas_equalTo(25.0);
            make.centerX.mas_equalTo(self.mainView);
            make.width.mas_equalTo(SCREENWIDTH * 234.0 / 375.0);
        }];
    }

    if (!_hintBg) {
        _hintBg = [[UIImageView alloc] init];
        [_hintBg setImage:[UIImage imageNamed:@"ic_hint_bg"]];
        [_hintBg setContentMode:UIViewContentModeScaleAspectFill];
        [_hintBg setClipsToBounds:YES];
        [_hintView addSubview:_hintBg];
        [_hintBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }

    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        [_headImg setBackgroundColor:[UIColor whiteColor]];
        [_headImg.layer setCornerRadius:7.5];
        [_headImg setClipsToBounds:YES];
        [_headImg setContentMode:UIViewContentModeScaleAspectFill];
        [_hintView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.hintView);
            make.width.height.mas_equalTo(15.0);
            make.left.mas_equalTo(5.0);
        }];
    }

    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        [_contentLab setFont:[UIFont systemFontOfSize:10.0]];
        [_contentLab setTextColor:[UtilsMacro colorWithHexString:@"FEDFCE"]];
        [_contentLab setText:@"恭喜林小丽排名从56名前进至到50名。"];
        [_hintView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImg.mas_right).mas_offset(5.0);
            make.right.mas_equalTo(-5.0);
            make.bottom.top.mas_equalTo(0.0);
        }];
    }
}

@end
