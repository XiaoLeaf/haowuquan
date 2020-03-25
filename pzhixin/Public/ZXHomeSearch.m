//
//  ZXHomeSearch.m
//  pzhixin
//
//  Created by zhixin on 2019/9/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeSearch.h"
#import <Masonry/Masonry.h>

@implementation ZXHomeSearch

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

- (void)setCommonSearch:(ZXCommonSearch *)commonSearch {
    _commonSearch = commonSearch;
    [self.nameLab setText:_commonSearch.title];
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
    
    UIView *topView = [[UIView alloc] init];
    [_mainView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(70.0);
    }];
    
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        [_bgImg setImage:[UIImage imageNamed:@"ic_home_search_bg"]];
        [_bgImg setContentMode:UIViewContentModeScaleAspectFill];
        [topView addSubview:_bgImg];
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [_titleLab setTextColor:HOME_TITLE_COLOR];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleLab setText:@"是否要搜索以下商品?"];
        [topView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [_mainView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        [_mainView addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24.0);
            make.right.mas_equalTo(-24.0);
            make.top.mas_equalTo(lineView.mas_bottom).mas_offset(30.0);
            make.height.mas_lessThanOrEqualTo(120.0).priorityHigh();
        }];
    }
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
//        [_nameLab setText:@"【肯范针织男士立领开衫毛衣春款韩版外穿外套潮流时尚新款爆款肯范针织男士立领开衫毛衣春款韩版外穿外套】"];
        [_nameLab setTextColor:COLOR_666666];
        [_nameLab setNumberOfLines:0];
        [_nameLab setTextAlignment:NSTextAlignmentCenter];
        [_nameLab setFont:[UIFont systemFontOfSize:15.0]];
        [_nameLab setPreferredMaxLayoutWidth:SCREENWIDTH - 146.0];
        [_nameView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setBackgroundColor:THEME_COLOR];
        [_searchBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_searchBtn.layer setCornerRadius:20.0];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBtn setTag:0];
        [_searchBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(30.0);
            make.left.mas_equalTo(54.0);
            make.right.mas_equalTo(-54.0);
            make.height.mas_equalTo(40.0);
            make.bottom.mas_equalTo(-20.0).priorityHigh();
        }];
    }
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_cancelBtn setTag:1];
        [_cancelBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_equalTo(30.0);
            make.width.height.mas_equalTo(40.0);
            make.centerX.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapBtnsAction:(UIButton *)button {
    if (self.zxHomeSearchBtnClick) {
        self.zxHomeSearchBtnClick(button.tag);
    }
}

@end
