//
//  ZXScoreDetailHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/10/22.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreDetailHeader.h"
#import <Masonry/Masonry.h>

@interface ZXScoreDetailHeader ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIButton *typeBtn;

@property (strong, nonatomic) UIButton *timeBtn;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation ZXScoreDetailHeader

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
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.bottom.mas_equalTo(-0.5);
        }];
    }
    
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_typeBtn setTitle:@"未到账" forState:UIControlStateNormal];
        [_typeBtn setImage:[UIImage imageNamed:@"ic_down_arrow.png"] forState:UIControlStateNormal];
        [_typeBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
        [_typeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_typeBtn setTag:0];
        [_typeBtn addTarget:self action:@selector(handleTapScoreDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_typeBtn];
        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(16.0);
        }];
    }
    
    if (!_timeBtn) {
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_timeBtn setTitle:@"时间" forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"ic_down_arrow.png"] forState:UIControlStateNormal];
        [_timeBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
        [_timeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_timeBtn setTag:1];
        [_timeBtn addTarget:self action:@selector(handleTapScoreDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_timeBtn];
        [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.right.mas_equalTo(-16.0);
        }];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.0);
            make.top.mas_equalTo(self.mainView.mas_bottom);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapScoreDetailBtnAction:(UIButton *)button {
    if (self.zxScoreDetailHeaderBtnClick) {
        self.zxScoreDetailHeaderBtnClick(button.tag);
    }
}

@end
