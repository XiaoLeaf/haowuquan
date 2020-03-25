//
//  ZXFansPopView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansPopView.h"
#import <Masonry/Masonry.h>

#define MAX_HEIGHT SCREENWIDTH * 1.2

@interface ZXFansPopView () <UITextViewDelegate>

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UITextView *contentTV;

@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation ZXFansPopView

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

- (void)setTipStr:(NSString *)tipStr {
    NSAttributedString *tipAttri = [[NSAttributedString alloc] initWithData:[tipStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [_contentTV setAttributedText:tipAttri];
    [_mainView setNeedsLayout];
    [_mainView layoutIfNeeded];
    if (_mainView.frame.size.height >= MAX_HEIGHT) {
        [_contentTV setScrollEnabled:YES];
    } else {
        [_contentTV setScrollEnabled:NO];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(36.0);
            make.right.mas_equalTo(-36.0);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_mainView.layer setCornerRadius:10.0];
        [_mainView setClipsToBounds:YES];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0);
            make.height.mas_lessThanOrEqualTo(MAX_HEIGHT);
        }];
    }
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_mainView addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20.0);
            make.bottom.right.mas_equalTo(-20.0);
        }];
    }
    
    if (!_contentTV) {
        _contentTV = [[UITextView alloc] init];
        [_contentTV setScrollEnabled:NO];
        [_contentTV setDelegate:self];
        [_contentTV setShowsVerticalScrollIndicator:NO];
        [_contentTV setShowsHorizontalScrollIndicator:NO];
        [_contentView addSubview:_contentTV];
        [_contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(handleTapBtnsAction) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(30.0);
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(32.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }
}

- (void)handleTapSelfAction {
    if (self.zxFansPopViewClick) {
        self.zxFansPopViewClick();
    }
}

- (void)handleTapBtnsAction {
    if (self.zxFansPopViewClick) {
        self.zxFansPopViewClick();
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
