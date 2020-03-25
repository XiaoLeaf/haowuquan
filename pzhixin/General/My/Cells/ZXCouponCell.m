//
//  ZXCouponCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCouponCell.h"
#import <Masonry/Masonry.h>

@interface ZXCouponCell () {
    BOOL isExpand;
}

@end

@implementation ZXCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    isExpand = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [UtilsMacro drawLineOfDashByCAShapeLayer:_lineView lineLength:5 lineSpacing:3 lineColor:[UtilsMacro colorWithHexString:@"EFEFEF"] lineDirection:YES];
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:[UIColor clearColor]];
        [_bgView.layer setCornerRadius:5.0];
        [_bgView.layer setMasksToBounds:YES];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(10.0);
            make.left.mas_equalTo(self.contentView).offset(10.0);
            make.right.mas_equalTo(self.contentView).offset(-10.0);
            make.bottom.mas_equalTo(self.contentView);
        }];
//        MASAttachKeys(_bgView);
    }
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        [_bgImgView setBackgroundColor:[UIColor clearColor]];
        [_bgImgView setContentMode:UIViewContentModeScaleAspectFill];
        [_bgImgView setImage:[UIImage imageNamed:@"ic_coupon_bg"]];
        [_bgImgView setUserInteractionEnabled:YES];
        [_bgView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_bgView);
            make.left.mas_equalTo(self->_bgView);
            make.right.mas_equalTo(self->_bgView);
            make.height.mas_equalTo(100.0).priorityLow();
        }];
//        MASAttachKeys(_bgImgView);
    }
    
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
        [_tipView setBackgroundColor:[UIColor whiteColor]];
        [_bgView addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_bgView).offset(101.0);
            make.left.mas_equalTo(self->_bgView);
            make.right.mas_equalTo(self->_bgView);
            make.bottom.mas_equalTo(self->_bgView.mas_bottom).offset(0.0).priorityHigh();
        }];
//        MASAttachKeys(_tipView);
    }
    
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setTextColor:COLOR_999999];
        [_detailLabel setNumberOfLines:0];
        [_detailLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_tipView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_tipView).offset(0.0);
            make.bottom.mas_equalTo(self->_tipView.mas_bottom).offset(0.0);
            make.left.mas_equalTo(self->_tipView).offset(15.0);
            make.right.mas_equalTo(self->_tipView).offset(-15.0);
        }];
//        MASAttachKeys(_detailLabel);
    }
    
    if (!_prefixView) {
        _prefixView = [[UIView alloc] init];
        [_prefixView setBackgroundColor:[UIColor clearColor]];
        [_bgView addSubview:_prefixView];
        [_prefixView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_bgView);
            make.top.mas_equalTo(self->_bgView);
            make.bottom.mas_equalTo(self->_tipView.mas_top);
            make.width.mas_equalTo(100.0);
        }];
//        MASAttachKeys(_prefixView);
    }
    
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        [_moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [_moneyLabel setText:@"10"];
        [_moneyLabel setTextColor:[UIColor whiteColor]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:41.0]];
        [_prefixView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self->_prefixView);
            make.left.mas_equalTo(self->_prefixView);
            make.right.mas_equalTo(self->_prefixView);
            make.height.mas_equalTo(30.0);
        }];
//        MASAttachKeys(_moneyLabel);
    }
    
    if (!_condiLabel) {
        _condiLabel = [[UILabel alloc] init];
        [_condiLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_condiLabel setTextColor:[UIColor whiteColor]];
        [_condiLabel setTextAlignment:NSTextAlignmentCenter];
        [_condiLabel setText:@"满120元可用"];
        [_prefixView addSubview:_condiLabel];
        [_condiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_moneyLabel.mas_bottom).offset(10.0);
            make.left.mas_equalTo(self->_prefixView);
            make.right.mas_equalTo(self->_prefixView);
            make.height.mas_equalTo(16.0);
        }];
//        MASAttachKeys(_condiLabel);
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setUserInteractionEnabled:YES];
        [_bgView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_prefixView.mas_right);
            make.top.mas_equalTo(self->_bgView);
            make.right.mas_equalTo(self->_bgView);
            make.bottom.mas_equalTo(self->_tipView.mas_top);
        }];
//        MASAttachKeys(_mainView);
    }
    
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_mainView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_mainView).offset(10.0);
            make.left.mas_equalTo(self->_mainView).offset(15.0);
            make.right.mas_equalTo(self->_mainView);
            make.height.mas_equalTo(20.0);
        }];
//        MASAttachKeys(_titleView);
    }
    
    if (!_flagbtn) {
        _flagbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flagbtn setUserInteractionEnabled:NO];
        [_flagbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flagbtn.titleLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_flagbtn setBackgroundColor:THEME_COLOR];
        [_flagbtn.layer setCornerRadius:5.0];
        [_flagbtn.layer setMasksToBounds:YES];
        [_flagbtn setTitle:@"平台券" forState:UIControlStateNormal];
        [_flagbtn setContentEdgeInsets:UIEdgeInsetsMake(3.0, 5.0, 3.0, 5.0)];
        [_titleView addSubview:_flagbtn];
        [_flagbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_titleView);
            make.left.mas_equalTo(self->_titleView);
            make.bottom.mas_equalTo(self->_titleView);
            make.width.mas_equalTo(20.0).priorityLow();
        }];
//        MASAttachKeys(_flagbtn);
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"新人福利优惠券"];
        [_titleLabel setTextColor:COLOR_666666];
        [_titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
        [_titleView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_titleView);
            make.left.mas_equalTo(self->_flagbtn.mas_right).offset(5.0);
            make.bottom.mas_equalTo(self->_titleView);
            make.right.mas_equalTo(self->_titleView);
        }];
//        MASAttachKeys(_titleLabel);
    }
    
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useBtn.layer setBorderWidth:1.0];
        [_useBtn.layer setBorderColor:THEME_COLOR.CGColor];
        [_useBtn.layer setCornerRadius:10.0];
        [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [_useBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
        [_useBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_useBtn addTarget:self action:@selector(handleTapUseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_useBtn];
        [_useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_mainView).offset(40.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-15.0);
            make.width.mas_equalTo(60.0);
            make.height.mas_equalTo(20.0);
        }];
//        MASAttachKeys(_useBtn);
    }
    
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        [_mainView addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_titleView.mas_bottom).offset(15.0);
            make.left.mas_equalTo(self->_mainView).offset(15.0);
            make.height.mas_equalTo(25.0);
            make.right.mas_equalTo(self->_useBtn.mas_left).offset(-5.0);
        }];
//        MASAttachKeys(_timeView);
    }
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setText:@"2019.04.24-2019.05.10"];
        [_timeLabel setTextColor:COLOR_999999];
        [_timeLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_timeView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_timeView);
            make.left.mas_equalTo(self->_timeView);
            make.right.mas_equalTo(self->_timeView);
            make.height.mas_equalTo(10.0);
        }];
//        MASAttachKeys(_timeLabel);
    }
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setText:@"可与品牌券叠加使用"];
        [_tipLabel setTextColor:COLOR_999999];
        [_tipLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_timeView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_timeLabel.mas_bottom).offset(5.0);
            make.left.mas_equalTo(self->_timeView);
            make.right.mas_equalTo(self->_timeView);
            make.height.mas_equalTo(10.0);
        }];
//        MASAttachKeys(_tipLabel);
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
//        [_lineView setBackgroundColor:[UIColor redColor]];
        [_mainView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_mainView).offset(15.0);
            make.height.mas_equalTo(1.0);
            make.right.mas_equalTo(self->_mainView).offset(-15.0);
            make.top.mas_equalTo(self->_timeView.mas_bottom).offset(5.0);
        }];
//        MASAttachKeys(_lineView);
    }
    
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
        [_mainView addSubview:_detailView];
        [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_mainView).offset(15.0);
            make.top.mas_equalTo(self->_lineView.mas_bottom);
            make.right.mas_equalTo(self->_mainView).offset(-15.0);
            make.height.mas_equalTo(28.0);
        }];
//        MASAttachKeys(_detailView);
    }
    
    if (!_indiLabel) {
        _indiLabel = [[UILabel alloc] init];
        [_indiLabel setText:@"详细信息"];
        [_indiLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_indiLabel setTextColor:COLOR_999999];
        [_detailView addSubview:_indiLabel];
        [_indiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_detailView);
            make.top.mas_equalTo(self->_detailView);
            make.bottom.mas_equalTo(self->_detailView);
            make.width.mas_equalTo(50.0);
        }];
//        MASAttachKeys(_indiLabel);
    }
    
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn setImage:[UIImage imageNamed:@"ic_coupon_arrow"] forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(handleTapCouponCellDetailBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailView addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self->_detailView);
            make.height.mas_equalTo(20.0);
            make.width.mas_equalTo(20.0);
            make.top.mas_equalTo(self->_detailView).offset(4.0);
        }];
//        MASAttachKeys(_detailBtn);
    }
    
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        [_tipImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_tipImageView setImage:[UIImage imageNamed:@"ic_coupon_past"]];
        [_bgView addSubview:_tipImageView];
        [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(63.0);
            make.height.mas_equalTo(36.0);
            make.top.mas_equalTo(self->_bgView);
            make.right.mas_equalTo(self->_bgView);
        }];
//        MASAttachKeys(_tipImageView);
    }
    
    if (!_flagImgView) {
        _flagImgView = [[UIImageView alloc] init];
        [_flagImgView setImage:[UIImage imageNamed:@"ic_coupon_effect"]];
        [_flagImgView setContentMode:UIViewContentModeScaleAspectFit];
        [_flagImgView setHidden:YES];
        [_bgView addSubview:_flagImgView];
        [_flagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(46.0);
            make.height.mas_equalTo(46.0);
            make.top.mas_equalTo(self->_bgView.mas_top).offset(15.0);
            make.right.mas_equalTo(self->_bgView.mas_right).offset(-15.0);
        }];
//        MASAttachKeys(_flagImgView);
    }
}

#pragma mark - Button Methods

- (void)handleTapUseBtnAction {
//    NSLog(@"1234");
}

- (void)handleTapCouponCellDetailBtnAction {
    isExpand = !isExpand;
    if (isExpand) {
        [_detailLabel setText:@"全场通用（限时秒杀商品大礼包黄金手机话费虚拟产品除外）全场通用（限时秒杀商品大礼包黄金手机话费虚拟产品除外）"];
        [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_tipView).offset(10.0);
            make.bottom.mas_equalTo(self->_tipView.mas_bottom).offset(-10.0);
        }];
        [_bgImgView setBackgroundColor:[UIColor whiteColor]];
        [UtilsMacro addRotationAnimationWithFromValue:0 AndToValue:@(M_PI) andView:_detailBtn.imageView andDuration:0.2];
    } else {
        [_detailLabel setText:@""];
        [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_tipView).offset(0.0);
            make.bottom.mas_equalTo(self->_tipView.mas_bottom).offset(0.0);
        }];
        [_bgImgView setBackgroundColor:[UIColor clearColor]];
        [_detailBtn.imageView.layer removeAnimationForKey:@"transform.rotation"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponCellHandleTapDetailBtnAction:)]) {
        [self.delegate couponCellHandleTapDetailBtnAction:self];
    }
}

@end
