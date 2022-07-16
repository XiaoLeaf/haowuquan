//
//  ZXHomeToast.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeToast.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@implementation ZXHomeToast

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.couponLab setNeedsLayout];
    [self.couponLab layoutIfNeeded];
    [self.awardLab setNeedsLayout];
    [self.awardLab layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.couponLab.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.couponLab.bounds;
    maskLayer.path = maskPath.CGPath;
    self.couponLab.layer.mask = maskLayer;
    //
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.awardLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.awardLab.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.awardLab.layer.mask = maskLayer1;
}

#pragma mark - Setter

- (void)setCommonSearch:(ZXCommonSearch *)commonSearch {
    _commonSearch = commonSearch;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_commonSearch.img] imageView:_goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    if (![UtilsMacro whetherIsEmptyWithObject:_commonSearch.title]) {
        NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_commonSearch.title]]];
        YYAnimatedImageView *imageView;
        if ([_commonSearch.shop_type integerValue] == 1) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
        } else if ([_commonSearch.shop_type integerValue] == 2) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
        }
        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
        [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] alignment:YYTextVerticalAlignmentCenter];
        [nameAttri insertAttributedString:attachText atIndex:0];
        [_nameLab setAttributedText:nameAttri];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:_commonSearch.price]) {
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券后价￥%@",_commonSearch.price]];
        [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] range:NSMakeRange(0, 4)];
        [_priceLab setAttributedText:priceStr];
    }
    
    [_couponLab setText:[NSString stringWithFormat:@" 券 %@ 元   ", _commonSearch.coupon_amount]];
    [_awardLab setText:[NSString stringWithFormat:@" 最高奖 %@   ",_commonSearch.max_commission]];
}

#pragma mark - Private Methods

- (void)createSubviews {
    
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
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
            make.top.left.right.mas_equalTo(0.0);
        }];
    }
    
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        [_goodsImg setClipsToBounds:YES];
        [_goodsImg setContentMode:UIViewContentModeScaleAspectFill];
        [_mainView addSubview:_goodsImg];
        [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0.0);
            make.height.mas_equalTo(self.goodsImg.mas_width);
        }];
    }
    
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        [_mainView addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.goodsImg.mas_bottom).mas_offset(20.0);
        }];
    }
    
    if (!_nameLab) {
        _nameLab = [[YYLabel alloc] init];
        [_nameLab setTextColor:HOME_TITLE_COLOR];
        [_nameLab setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
        [_nameLab setNumberOfLines:2];
        [_nameLab setPreferredMaxLayoutWidth:SCREENWIDTH - 122.0];
        [_nameView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.nameView);
            make.left.mas_equalTo(18.0);
            make.right.mas_equalTo(-18.0);
        }];
    }
    
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        [_mainView addSubview:_priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(10.0);
        }];
    }
    
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        [_priceLab setTextColor:[UtilsMacro colorWithHexString:@"C4002C"]];
        [_priceLab setFont:[UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium]];
        [_priceView addSubview:_priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18.0);
            make.top.mas_equalTo(0.0);
            make.height.mas_equalTo(15.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_couponLab) {
        _couponLab = [[UILabel alloc] init];
        [_couponLab setTextColor:[UIColor whiteColor]];
        [_couponLab setFont:[UIFont systemFontOfSize:9.0]];
        [_couponLab setTextAlignment:NSTextAlignmentCenter];
        [_couponLab setBackgroundColor:[UtilsMacro colorWithHexString:@"CC0000"]];
        [_priceView addSubview:_couponLab];
        [_couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceLab.mas_right).mas_offset(13.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_awardLab) {
        _awardLab = [[UILabel alloc] init];
        [_awardLab setTextColor:[UIColor whiteColor]];
        [_awardLab setFont:[UIFont systemFontOfSize:9.0]];
        [_awardLab setTextAlignment:NSTextAlignmentCenter];
        [_awardLab setBackgroundColor:THEME_COLOR];
        [_priceView addSubview:_awardLab];
        [_awardLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponLab.mas_right).mas_offset(8.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [_mainView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0);
        make.top.mas_equalTo(self.priceView.mas_bottom).mas_offset(20.0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *btnView = [[UIView alloc] init];
    [btnView setBackgroundColor:[UIColor whiteColor]];
    [_mainView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(50.0).priorityHigh();
    }];
    
    UIView *secLine = [[UIView alloc] init];
    [secLine setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [btnView addSubview:secLine];
    [secLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(btnView);
        make.width.mas_equalTo(0.5);
        make.top.bottom.mas_equalTo(0.0);
    }];
    
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"搜索更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_moreBtn setTag:0];
        [_moreBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.right.mas_equalTo(secLine.mas_left);
        }];
    }

    if (!_getBtn) {
        _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getBtn setTitle:@"打开" forState:UIControlStateNormal];
        [_getBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_getBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_getBtn setTag:1];
        [_getBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_getBtn];
        [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(secLine.mas_right);
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn setTag:2];
        [_closeBtn addTarget:self action:@selector(handleTapBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(30.0);
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(32.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }

}

#pragma mark - Button Method

- (void)handleTapBtnsAction:(UIButton *)button {
    if (self.zxHomeToastBtnClick) {
        self.zxHomeToastBtnClick(button.tag);
    }
}

@end
