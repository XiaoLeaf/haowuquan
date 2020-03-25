//
//  ZXDealPopView.m
//  pzhixin
//
//  Created by zhixin on 2019/12/10.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDealPopView.h"
#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>

@interface ZXDealPopView () <YYTextViewDelegate>

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) YYTextView *contentLab;

@property (strong, nonatomic) UIView *dealView;

@property (strong, nonatomic) YYLabel *dealLab;

@property (strong, nonatomic) UIView *actionView;

@property (strong, nonatomic) UIButton *agreeBtn;

@property (strong, nonatomic) UIButton *cancelBtn;

@end

@implementation ZXDealPopView

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

- (void)setPolicy:(ZXPolicy *)policy {
    _policy = policy;
    _titleLab.text = _policy.title;
    NSString *htmlStr = [NSString stringWithFormat:@"%@", _policy.content];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _contentLab.attributedText = attrStr;
    
    NSString *agreementStr = [NSString stringWithFormat:@"%@",ZXAppConfigHelper.sharedInstance.appConfig.h5.agreement.txt];
    NSString *dealStr = [NSString stringWithFormat:@"同意即表示已阅读《%@》", agreementStr];
    NSMutableAttributedString *dealAttri = [[NSMutableAttributedString alloc] initWithString:dealStr];
    [dealAttri addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0, 8)];
    [dealAttri addAttributes:@{NSForegroundColorAttributeName: HOME_TITLE_COLOR} range:NSMakeRange(0, 8)];
     
    NSRange agreementRange = [dealStr rangeOfString:agreementStr];
    [dealAttri addAttributes:@{NSForegroundColorAttributeName: COLOR_4B729D} range:NSMakeRange(agreementRange.location - 1, agreementRange.length + 1)];
    [dealAttri addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]} range:NSMakeRange(agreementRange.location - 1, agreementRange.length + 1)];
    [dealAttri yy_setTextHighlightRange:NSMakeRange(agreementRange.location - 1, agreementRange.length + 1) color:COLOR_4B729D backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.zxDealPopViewBtnClick) {
            self.zxDealPopViewBtnClick(2);
        }
    }];
    _dealLab.attributedText = dealAttri;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.layer.cornerRadius = 10.0;
        _mainView.clipsToBounds = YES;
        _mainView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(43.0);
            make.right.mas_equalTo(-43.0);
        }];
    }
    
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_mainView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10.0);
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(30.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
        _titleLab.textColor = HOME_TITLE_COLOR;
        _titleLab.text = @"温馨提示";
        [_titleView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_mainView addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0);
            make.right.mas_equalTo(-20.0);
            make.top.mas_equalTo(self.titleView.mas_bottom).mas_offset(10.0);
            if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0) {
                make.height.mas_lessThanOrEqualTo(300.0);
            } else {
                make.height.mas_equalTo(200.0);
            }
        }];
    }
    
    if (!_contentLab) {
        _contentLab = [[YYTextView alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:13.0];
        _contentLab.textColor = COLOR_666666;
        _contentLab.selectable = NO;
        [_contentLab setShowsVerticalScrollIndicator:NO];
        [_contentLab setShowsHorizontalScrollIndicator:NO];
        [_contentLab setDelegate:self];
        [_contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_dealView) {
        _dealView = [[UIView alloc] init];
        [_mainView addSubview:_dealView];
        [_dealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.contentView.mas_bottom).mas_offset(10.0);
        }];
    }
    
    if (!_dealLab) {
        _dealLab = [[YYLabel alloc] init];
        _dealLab.numberOfLines = 0;
        _dealLab.textColor = COLOR_4B729D;
        _dealLab.textAlignment = NSTextAlignmentCenter;
        _dealLab.preferredMaxLayoutWidth = SCREENWIDTH - 126.0;
        _dealLab.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        [_dealView addSubview:_dealLab];
        [_dealLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(20.0);
            make.right.mas_equalTo(-20.0);
        }];
    }
    
    if (!_actionView) {
        _actionView = [[UIView alloc] init];
        [_mainView addSubview:_actionView];
        [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.dealView.mas_bottom).mas_offset(10.0);
            make.height.mas_equalTo(32.0);
            make.bottom.mas_equalTo(-15.0).priorityHigh();
        }];
    }
    
    NSMutableArray *btnList = [[NSMutableArray alloc] init];
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = BG_COLOR;
        [_cancelBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        _cancelBtn.layer.cornerRadius = 16.0;
        _cancelBtn.clipsToBounds = YES;
        _cancelBtn.tag = 0;
        [_cancelBtn addTarget:self action:@selector(handleActionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_cancelBtn];
    }
    [btnList addObject:_cancelBtn];
    
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.backgroundColor = THEME_COLOR;
        [_agreeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        _agreeBtn.layer.cornerRadius = 16.0;
        _agreeBtn.clipsToBounds = YES;
        _agreeBtn.tag = 1;
        [_agreeBtn addTarget:self action:@selector(handleActionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_agreeBtn];
    }
    [btnList addObject:_agreeBtn];
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20.0 leadSpacing:20.0 tailSpacing:20.0];
    [btnList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.0);
    }];
}

#pragma mark - YYTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    return NO;
}

#pragma mark - Button Method

- (void)handleActionBtnClick:(UIButton *)button {
    if (self.zxDealPopViewBtnClick) {
        self.zxDealPopViewBtnClick(button.tag);
    }
}

@end
