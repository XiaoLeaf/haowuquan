//
//  ZXPayPwView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPayPwView.h"
#import <CRBoxInputView/CRBoxInputView.h>
#import <Masonry/Masonry.h>

@interface ZXPayPwView ()

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UIView *pwView;

@property (strong, nonatomic) CRBoxInputView *inputView;

@end

@implementation ZXPayPwView

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
        UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewAction)];
        [self addGestureRecognizer:tapView];
        [self createSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_mainView setNeedsLayout];
    [_mainView layoutIfNeeded];
    
    [UtilsMacro addCornerRadiusForView:_mainView andRadius:5.0 andCornes:UIRectCornerTopLeft | UIRectCornerTopRight];
}

#pragma mark - Private Methods

- (void)handleTapViewAction {
    if (self.zxPayPwViewTapBlock) {
        self.zxPayPwViewTapBlock();
    }
}

- (void)handleTapCloseBtnAction {
    if (self.zxPayPwViewTapBlock) {
        self.zxPayPwViewTapBlock();
    }
}

- (void)createSubviews {
    if (!_mainView) {
        _mainView  = [[UIView alloc] init];
//        [_mainView.layer setCornerRadius:10.0];
        [_mainView setClipsToBounds:YES];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0.0);
            make.right.mas_equalTo(0.0);
            make.height.mas_equalTo(485.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_mainView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(40.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setText:@"输入支付密码"];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleLab setTextColor:COLOR_666666];
        [_titleLab setFont:[UIFont systemFontOfSize:16.0]];
        [_titleView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_my_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(handleTapCloseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [_mainView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0);
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    if (!_pwView) {
        _pwView = [[UIView alloc] init];
        [_mainView addSubview:_pwView];
        [_pwView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(lineView.mas_bottom);
            make.height.mas_equalTo(100.0);
        }];
    }
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    [cellProperty setCellCursorColor:HOME_TITLE_COLOR];
    [cellProperty setBorderWidth:0.5];
    [cellProperty setCellBorderColorSelected:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [cellProperty setCellBorderColorFilled:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [cellProperty setIfShowSecurity:YES];
    [cellProperty setSecurityType:CRBoxSecurityCustomViewType];
    cellProperty.customSecurityViewBlock = ^UIView * _Nonnull{
        UIView *customSecurityView = [UIView new];
        customSecurityView.backgroundColor = [UIColor clearColor];
        // circleView
        static CGFloat circleViewWidth = 10;
        UIView *circleView = [UIView new];
        circleView.backgroundColor = HOME_TITLE_COLOR;
        circleView.layer.cornerRadius = 5.0;
        [customSecurityView addSubview:circleView];
        [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(circleViewWidth);
            make.centerX.offset(0);
            make.centerY.offset(0);
        }];

        return customSecurityView;
    };
    
    if (!_inputView) {
        _inputView = [[CRBoxInputView alloc] initWithFrame:CGRectZero];
        [_inputView setCodeLength:6];
        [_inputView setKeyBoardType:UIKeyboardTypeNumberPad];
        [_inputView loadAndPrepareViewWithBeginEdit:YES];
        [_inputView setCustomCellProperty:cellProperty];
        [_inputView setIfNeedSecurity:YES];
        [_inputView loadAndPrepareView];
        __weak typeof(self) weakSelf = self;
        _inputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
            if (weakSelf.zxPayPwViewPwBlock) {
                weakSelf.zxPayPwViewPwBlock(text, isFinished);
            }
        };
        [_pwView addSubview:_inputView];
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0);
            make.right.mas_equalTo(-20.0);
            make.height.mas_equalTo(40.0);
            make.centerY.mas_equalTo(self.pwView);
        }];
    }
}

@end
