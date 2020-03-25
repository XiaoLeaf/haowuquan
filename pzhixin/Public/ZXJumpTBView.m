//
//  ZXJumpTBView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXJumpTBView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImage+GIF.h>

@interface ZXJumpTBView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIImageView *topBgImg;

@property (strong, nonatomic) UIImageView *ppImg;

@property (strong, nonatomic) UIView *tipView;

@property (strong, nonatomic) UILabel *tipLab;

@property (strong, nonatomic) UIImageView *tipImg;

@property (strong, nonatomic) UIImageView *tbImg;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIView *couponView;

@property (strong, nonatomic) UILabel *couponTitle;

@property (strong, nonatomic) UIImageView *couponImg;

@property (strong, nonatomic) UILabel *couponCount;

@property (strong, nonatomic) UIView *awardView;

@property (strong, nonatomic) UILabel *awardTitle;

@property (strong, nonatomic) UIImageView *awardImg;

@property (strong, nonatomic) UILabel *awardCount;

@property (strong, nonatomic) UILabel *saveLab;

@property (strong, nonatomic) UILabel *alertLab;

@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation ZXJumpTBView

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

#pragma mark - Setter

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    [_couponCount setText:[NSString stringWithFormat:@"￥%@",[awardInfo valueForKey:@"coupon_amount"]]];
    [_awardCount setText:[NSString stringWithFormat:@"￥%@", [awardInfo valueForKey:@"commission"]]];
    NSMutableAttributedString *saveStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"为您省了￥%@",[NSString stringWithFormat:@"%@", @([[awardInfo valueForKey:@"coupon_amount"] floatValue] + [[awardInfo valueForKey:@"commission"] floatValue])]]];
    [saveStr addAttribute:NSForegroundColorAttributeName value:HOME_TITLE_COLOR range:NSMakeRange(0, 4)];
    [_saveLab setAttributedText:saveStr];
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
        [_mainView setClipsToBounds:YES];
        [_mainView.layer setCornerRadius:10.0];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_topView) {
        _topView = [[UIView alloc] init];
        [_mainView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(90.0);
        }];
    }
    
    if (!_topBgImg) {
        _topBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_tb_bg"]];
        [_topBgImg setClipsToBounds:YES];
        [_topBgImg setContentMode:UIViewContentModeScaleAspectFill];
        [_topView addSubview:_topBgImg];
        [_topBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
        [_topView addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.topView);
            make.width.mas_equalTo(80.0);
        }];
    }
    
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        [_tipLab setText:@"正在为您跳转"];
        [_tipLab setTextColor:COLOR_666666];
        [_tipLab setFont:[UIFont systemFontOfSize:10.0]];
        [_tipLab setTextAlignment:NSTextAlignmentCenter];
        [_tipView addSubview:_tipLab];
        [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(10.0);
        }];
    }
    
    if (!_tipImg) {
        _tipImg = [[UIImageView alloc] init];
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"jump_tb_line" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        UIImage *gifImg = [UIImage sd_imageWithGIFData:gifData];
        [_tipImg setImage:gifImg];
        [_tipView addSubview:_tipImg];
        [_tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(10.0);
            make.top.mas_equalTo(self.tipLab.mas_bottom).mas_offset(5.0);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
    
    if (!_ppImg) {
        _ppImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_tb_logo"]];
        [_ppImg setClipsToBounds:YES];
        [_ppImg setContentMode:UIViewContentModeScaleAspectFill];
        [_topView addSubview:_ppImg];
        [_ppImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView);
            make.width.height.mas_equalTo(30.0);
            make.right.mas_equalTo(self.tipView.mas_left).mas_offset(-30.0);
        }];
    }
    
    if (!_tbImg) {
        _tbImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_tb_taobao"]];
        [_tbImg setClipsToBounds:YES];
        [_tbImg setContentMode:UIViewContentModeScaleAspectFill];
        [_topView addSubview:_tbImg];
        [_tbImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView);
            make.width.height.mas_equalTo(30.0);
            make.left.mas_equalTo(self.tipView.mas_right).mas_offset(30.0);
        }];
    }
    
    if (!_couponView) {
        _couponView = [[UIView alloc] init];
        [_mainView addSubview:_couponView];
        [_couponView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(50.0);
        }];
    }
    
    if (!_couponImg) {
        _couponImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_tb_dot"]];
        [_couponImg setClipsToBounds:YES];
        [_couponImg setContentMode:UIViewContentModeScaleAspectFill];
        [_couponView addSubview:_couponImg];
        [_couponImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.couponView);
            make.width.mas_equalTo(50.0);
            make.height.mas_equalTo(3.0);
        }];
    }
    
    if (!_couponTitle) {
        _couponTitle = [self titleLabWithText:@"领券"];
        [_couponView addSubview:_couponTitle];
        [_couponTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.ppImg);
            make.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_couponCount) {
        _couponCount = [self countLab];
        [_couponCount setText:@"￥300"];
        [_couponView addSubview:_couponCount];
        [_couponCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.tbImg);
            make.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_awardView) {
        _awardView = [[UIView alloc] init];
        [_mainView addSubview:_awardView];
        [_awardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.couponView.mas_bottom);
            make.height.mas_equalTo(50.0);
        }];
    }
    
    if (!_awardImg) {
        _awardImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump_tb_dot"]];
        [_awardImg setClipsToBounds:YES];
        [_awardImg setContentMode:UIViewContentModeScaleAspectFill];
        [_awardView addSubview:_awardImg];
        [_awardImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.awardView);
            make.width.mas_equalTo(50.0);
            make.height.mas_equalTo(3.0);
        }];
    }
    
    if (!_awardTitle) {
        _awardTitle = [self titleLabWithText:@"奖励"];
        [_awardView addSubview:_awardTitle];
        [_awardTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.ppImg);
            make.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_awardCount) {
        _awardCount = [self countLab];
        [_awardCount setText:@"￥2.80"];
        [_awardView addSubview:_awardCount];
        [_awardCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.tbImg);
            make.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_saveLab) {
        _saveLab = [[UILabel alloc] init];
        [_saveLab setText:@"为您省了￥120"];
        [_saveLab setTextAlignment:NSTextAlignmentCenter];
        [_saveLab setTextColor:[UtilsMacro colorWithHexString:@"C4002C"]];
        [_saveLab setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
        [_mainView addSubview:_saveLab];
        [_saveLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.awardView.mas_bottom).mas_equalTo(5.0);
            make.height.mas_equalTo(15.0);
        }];
    }
    
    if (!_alertLab) {
        _alertLab = [[UILabel alloc] init];
        [_alertLab setText:@"注意不要使用集分宝、红包下单，会无收益哦~"];
        [_alertLab setTextColor:COLOR_999999];
        [_alertLab setFont:[UIFont systemFontOfSize:10.0]];
        [_alertLab setTextAlignment:NSTextAlignmentCenter];
        [_mainView addSubview:_alertLab];
        [_alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.saveLab.mas_bottom).mas_offset(17.0);
            make.height.mas_equalTo(12.0);
            make.bottom.mas_equalTo(-25.0).priorityHigh();
        }];
    }
    
//    if (!_closeBtn) {
//        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
//        [_closeBtn setTag:0];
//        [_closeBtn addTarget:self action:@selector(handleTapJumpTBViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_containerView addSubview:_closeBtn];
//        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mainView.mas_bottom).mas_equalTo(30.0);
//            make.width.height.mas_equalTo(40.0);
//            make.centerX.mas_equalTo(self.containerView);
//            make.bottom.mas_equalTo(0.0).priorityHigh();
//        }];
//    }
}

- (UILabel *)titleLabWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    [label setText:text];
    [label setTextColor:HOME_TITLE_COLOR];
    [label setFont:[UIFont systemFontOfSize:14.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (UILabel *)countLab {
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UtilsMacro colorWithHexString:@"C4002C"]];
    [label setFont:[UIFont systemFontOfSize:13.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

#pragma mark - Button Method

- (void)handleTapJumpTBViewBtnAction:(UIButton *)button {
    if (self.zxJumpTBViewBtnClick) {
        self.zxJumpTBViewBtnClick(button.tag);
    }
}

- (void)handleTapViewAction {
    if (self.zxJumpTBViewBtnClick) {
        self.zxJumpTBViewBtnClick((0));
    }
}

@end
