//
//  ZXFansHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansHeaderView.h"
#import <Masonry/Masonry.h>

@implementation ZXFansHeaderView

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
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    
    if (!_sortView) {
        _sortView = [[UIView alloc] init];
        [_sortView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
        [_mainView addSubview:_sortView];
        [_sortView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView);
            make.left.mas_equalTo(self.mainView);
            make.right.mas_equalTo(self.mainView);
            make.bottom.mas_equalTo(self.mainView);
        }];
    }
    if (!_lastBtn) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastBtn setTitle:@"登录时间" forState:UIControlStateNormal];
        [_lastBtn setImage:[UIImage imageNamed:@"ic_fans_arrow.png"] forState:UIControlStateNormal];
        [_lastBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_lastBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0)];
        [_lastBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_lastBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_lastBtn setTag:0];
        [_lastBtn addTarget:self action:@selector(handleTapFansHeaderViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sortView addSubview:_lastBtn];
        [_lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0);
            make.top.mas_equalTo(self.sortView);
            make.bottom.mas_equalTo(self.sortView);
        }];
    }
    
    if (!_fansBtn) {
        _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fansBtn setTitle:@"粉丝数" forState:UIControlStateNormal];
        [_fansBtn setImage:[UIImage imageNamed:@"ic_fans_arrow.png"] forState:UIControlStateNormal];
        [_fansBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_fansBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0)];
        [_fansBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_fansBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_fansBtn setTag:1];
        [_fansBtn addTarget:self action:@selector(handleTapFansHeaderViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sortView addSubview:_fansBtn];
        [_fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sortView);
            make.bottom.mas_equalTo(self.sortView);
            make.right.mas_equalTo(-16.0);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapFansHeaderViewBtnAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansHeaderViewHandleTapBtnActionWithTag:)]) {
        [self.delegate fansHeaderViewHandleTapBtnActionWithTag:button.tag];
    }
}

@end
