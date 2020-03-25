//
//  ZXScoreDayView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/22.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreDayView.h"
#import <Masonry/Masonry.h>

@interface ZXScoreDayView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIButton *scoreBtn;

@property (strong, nonatomic) UIButton *txtBtn;

@end

@implementation ZXScoreDayView

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
        [self setClipsToBounds:YES];
        [self createSubview];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UtilsMacro addCornerRadiusForView:self andRadius:3.0 andCornes:UIRectCornerTopLeft | UIRectCornerTopRight];
}

#pragma mark - Setter

- (void)setScoreDay:(ZXScoreDay *)scoreDay {
    _scoreDay = scoreDay;
    [_scoreBtn setTitle:_scoreDay.score forState:UIControlStateNormal];
    [_txtBtn setTitle:_scoreDay.txt forState:UIControlStateNormal];
    if ([_scoreDay.is_signin integerValue] == 1) {
        [_mainView setBackgroundColor:THEME_COLOR];
        [_scoreBtn setSelected:YES];
        [_txtBtn setSelected:YES];
    } else {
        [_mainView setBackgroundColor:[UtilsMacro colorWithHexString:@"#F6F6F6"]];
        [_scoreBtn setSelected:NO];
        [_txtBtn setSelected:NO];
    }
}

#pragma mark - Private Method

- (void)createSubview {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_scoreBtn) {
        _scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_scoreBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_scoreBtn setUserInteractionEnabled:NO];
        [_scoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_mainView addSubview:_scoreBtn];
        [_scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(0.0);
            make.top.mas_equalTo(10.0);
            make.height.mas_equalTo(12.0);
        }];
    }
    
    if (!_txtBtn) {
        _txtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _txtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_txtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_txtBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_txtBtn setUserInteractionEnabled:NO];
        [_txtBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_mainView addSubview:_txtBtn];
        [_txtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scoreBtn.mas_bottom).mas_offset(16.0);
            make.right.left.mas_equalTo(0.0);
            make.height.mas_equalTo(10.0);
        }];
    }
}

@end
