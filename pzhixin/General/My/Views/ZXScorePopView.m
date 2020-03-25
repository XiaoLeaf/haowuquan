//
//  ZXScorePopView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScorePopView.h"
#import <Masonry/Masonry.h>

@interface ZXScorePopView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *topImgView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *scoreLab;

@end

@implementation ZXScorePopView

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
        UITapGestureRecognizer *tapSelf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSelfAction)];
        [self addGestureRecognizer:tapSelf];
        [self createSubviews];
    }
    return self;
}

#pragma mark - Setter

- (void)setScorePop:(ZXScorePop *)scorePop {
    _scorePop = scorePop;
    [_titleLab setText:_scorePop.memo];
    [_scoreLab setText:_scorePop.amount];
}

#pragma mark - Private Methods

- (void)handleTapSelfAction {
    if (self.zxScorePopViewClick) {
        self.zxScorePopViewClick();
    }
}

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
//        [_containerView setBackgroundColor:[UIColor whiteColor]];
        [_containerView.layer setCornerRadius:10.0];
        [_containerView setClipsToBounds:YES];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0);
            make.right.mas_equalTo(-20.0);
            make.height.width.mas_equalTo(170.0).priorityLow();
            make.center.mas_equalTo(self);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_score_pop"]];
        [_topImgView setContentMode:UIViewContentModeScaleAspectFit];
        [_topImgView setClipsToBounds:YES];
        [_mainView addSubview:_topImgView];
        [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(10.0);
            make.height.mas_equalTo(100.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleLab setFont:[UIFont systemFontOfSize:12.0]];
        [_titleLab setTextColor:[UIColor whiteColor]];
        [_titleLab setNumberOfLines:0];
        [_mainView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.topImgView.mas_bottom).mas_offset(12.0);
//            make.height.mas_equalTo(12.0);
        }];
    }
    
    if (!_scoreLab) {
        _scoreLab = [[UILabel alloc] init];
        [_scoreLab setTextAlignment:NSTextAlignmentCenter];
        [_scoreLab setFont:[UIFont systemFontOfSize:30.0 weight:UIFontWeightMedium]];
        [_scoreLab setTextColor:[UtilsMacro colorWithHexString:@"FFF08D"]];
        [_mainView addSubview:_scoreLab];
        [_scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(15.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }
}

@end
