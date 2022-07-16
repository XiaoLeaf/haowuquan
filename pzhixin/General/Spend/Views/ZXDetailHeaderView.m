//
//  ZXDetailHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDetailHeaderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZXDetailHeaderView

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
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.couponLabel setNeedsLayout];
    [self.couponLabel layoutIfNeeded];
    [self.commissionLabel setNeedsLayout];
    [self.commissionLabel layoutIfNeeded];
    [self.goodsView setNeedsLayout];
    [self.goodsView layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.couponLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.couponLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.couponLabel.layer.mask = maskLayer;
    //
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.commissionLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.commissionLabel.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.commissionLabel.layer.mask = maskLayer1;
    
    CGRect goodsRect = CGRectMake(0.0, 0.0, SCREENWIDTH, self.goodsView.frame.size.height);
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:goodsRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    [maskLayer2 setMasksToBounds:YES];
    maskLayer2.frame = goodsRect;
    maskLayer2.path = maskPath2.CGPath;
    self.goodsView.layer.mask = maskLayer2;
}

#pragma mark - Setter

- (void)setGoodsDetail:(ZXGoodsDetail *)goodsDetail {
    _goodsDetail = goodsDetail;
    __weak typeof(self) weakSelf = self;
    [self.bannerView setImgUrlList:_goodsDetail.row.slides_thumb];
    [self.bannerView setOrignalList:_goodsDetail.row.slides];
    if (![UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.video]) {
        [self.bannerView setVideoUrl:_goodsDetail.row.video];
//        [self.bannerView setVideoUrl:@"https://pic.rmb.bdstatic.com/qmpc_1559812202_mda-jaiza505zsc7g4ua.mp4"];
        [self.bannerView.player setPlayerDidToEnd:^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
            [weakSelf.bannerView.cycleScroll setAutoScroll:YES];
            [weakSelf.bannerView.containerView setAlpha:0.0];
            [weakSelf.bannerView setIsPlaying:NO];
            weakSelf.bannerView.currentTime = 0.0;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(detailHeaderViewPlayerDidPlayToEnd)]) {
                [weakSelf.delegate detailHeaderViewPlayerDidPlayToEnd];
            }
        }];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.price]) {
        NSString *currentStr = [NSString stringWithFormat:@"券后价￥%@",_goodsDetail.row.price];
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:currentStr];
        [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] range:NSMakeRange(0, 4)];
        [priceStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(4, currentStr.length - 4)];
        [self.currentPrice setAttributedText:priceStr];
    }
    
    NSString *originalStr = [NSString stringWithFormat:@"原价￥%@", _goodsDetail.row.ori_price];
//    NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
//    [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
    [self.originalPrice setText:originalStr];
    
    if (![UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.title]) {
        NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_goodsDetail.row.title]]];
        YYAnimatedImageView *imageView;
        if ([_goodsDetail.row.shop_type integerValue] == 1) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
        } else if ([_goodsDetail.row.shop_type integerValue] == 2) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
        }
        [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13.0] alignment:YYTextVerticalAlignmentCenter];
        [nameAttri insertAttributedString:attachText atIndex:0];
        [self.nameLabel setAttributedText:nameAttri];
    }
    
    [self.commissionLabel setText:[NSString stringWithFormat:@"  奖 %@  ",_goodsDetail.row.commission]];
    [self.soldLab setText:[NSString stringWithFormat:@"已售%@", _goodsDetail.row.volume]];
    
    if ([[goodsDetail.row is_fav] integerValue] == 1) {
        [self.favoriteBtn setSelected:YES];
    } else {
        [self.favoriteBtn setSelected:NO];
    }
    
    if ([_goodsDetail.row.coupon_amount integerValue] == 0 || [_goodsDetail.row.coupon_amount isEqualToString:@""]) {
        [_couponView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0);
        }];
        [_shopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.couponView.mas_bottom).mas_offset(0.0);
        }];
        [self.couponLabel setText:@""];
        [self.couponLab setText:@""];
        [self.timeLab setText:@""];
        [self.couponNameLab setText:@""];
    } else {
        [_couponView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100.0);
        }];
        [_shopView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.couponView.mas_bottom).mas_offset(5.0);
        }];
        [self.couponNameLab setText:_goodsDetail.row.coupon_info];
        [self.couponLabel setText:[NSString stringWithFormat:@"  券 %@ 元  ", _goodsDetail.row.coupon_amount]];
        [self.couponLab setText:_goodsDetail.row.coupon_amount];
        CGFloat width = [UtilsMacro widthForString2:_goodsDetail.row.coupon_amount font:[UIFont systemFontOfSize:30.0] andHeight:76.0].size.width + 5.0;
        [_couponLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        //        self.commissionLeft.constant = 5.0;
        [self.timeLab setText:[NSString stringWithFormat:@"%@ ~ %@", _goodsDetail.row.coupon_start_time, _goodsDetail.row.coupon_end_time]];
    }
    
    if ([UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.up_arr.txt]) {
        [_promoteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0);
        }];
    } else {
        [_promoteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30.0);
        }];
        [_promoteLab setText:_goodsDetail.row.up_arr.txt];
        [_checkPromote setTitle:_goodsDetail.row.up_arr.btn_txt forState:UIControlStateNormal];
    }
    
    if ([UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.desc]) {
        [_descImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0);
        }];
        [_descLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0.0);
        }];
    } else {
        [_descImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10.0);
        }];
        [_descLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-15.0);
        }];
        [self.descLab setText:_goodsDetail.row.desc];
    }
    
    for (int i = 0; i < [_goodsDetail.row.score count]; i++) {
        NSDictionary *dict = [_goodsDetail.row.score objectAtIndex:i];
        switch (i) {
            case 0:
            {
                [self.evaluateLab setText:[dict valueForKey:@"text"]];
                switch ([[dict valueForKey:@"level"] integerValue]) {
                    case -1:
                        [self.goodsEvaluate setText:[NSString stringWithFormat:@"%@低", [dict valueForKey:@"val"]]];
                        break;
                    case 0:
                        [self.goodsEvaluate setText:[NSString stringWithFormat:@"%@平", [dict valueForKey:@"val"]]];
                        break;
                    case 1:
                        [self.goodsEvaluate setText:[NSString stringWithFormat:@"%@高", [dict valueForKey:@"val"]]];
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 1:
            {
                [self.serviceLab setText:[dict valueForKey:@"text"]];
                switch ([[dict valueForKey:@"level"] integerValue]) {
                    case -1:
                        [self.serviceLabel setText:[NSString stringWithFormat:@"%@低", [dict valueForKey:@"val"]]];
                        break;
                    case 0:
                        [self.serviceLabel setText:[NSString stringWithFormat:@"%@平", [dict valueForKey:@"val"]]];
                        break;
                    case 1:
                        [self.serviceLabel setText:[NSString stringWithFormat:@"%@高", [dict valueForKey:@"val"]]];
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                [self.diliverLab setText:[dict valueForKey:@"text"]];
                switch ([[dict valueForKey:@"level"] integerValue]) {
                    case -1:
                        [self.diliverLabel setText:[NSString stringWithFormat:@"%@低", [dict valueForKey:@"val"]]];
                        break;
                    case 0:
                        [self.diliverLabel setText:[NSString stringWithFormat:@"%@平", [dict valueForKey:@"val"]]];
                        break;
                    case 1:
                        [self.diliverLabel setText:[NSString stringWithFormat:@"%@高", [dict valueForKey:@"val"]]];
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    }
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_goodsDetail.row.shop_icon] imageView:self.shopImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [self.shopCount setText:[NSString stringWithFormat:@"总销售%@件", _goodsDetail.row.shop_sell_count]];
    [self.shopName setText:_goodsDetail.row.shop_title];
    [self.shopScore setText:[NSString stringWithFormat:@"综合评分 %@", _goodsDetail.row.shop_dsr]];
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    
    if (!_bannerView) {
        _bannerView = [[ZXBannerView alloc] init];
        [self.mainView addSubview:_bannerView];
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainView).mas_offset(0.0);
            make.right.mas_equalTo(self.mainView).mas_offset(0.0);
            make.top.mas_equalTo(self.mainView).mas_offset(0.0);
            make.height.mas_equalTo(self.bannerView.mas_width).multipliedBy(1.0);
        }];
    }
    
    if (!_goodsView) {
        _goodsView = [[UIView alloc] init];
        [_goodsView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_goodsView];
        [_goodsView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainView);
            make.right.mas_equalTo(self.mainView);
            make.height.mas_equalTo(0.0).priorityLow();
            make.top.mas_equalTo(SCREENWIDTH - 10.0);
        }];
    }

    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        [_goodsView addSubview:_priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.goodsView).mas_offset(15.0);
            make.left.mas_equalTo(self.goodsView);
            make.right.mas_equalTo(self.goodsView);
            make.height.mas_equalTo(20.0);
        }];
    }

    if (!_currentPrice) {
        _currentPrice = [[UILabel alloc] init];
        [_currentPrice setTextColor:[UtilsMacro colorWithHexString:@"C4002C"]];
        [_currentPrice setFont:[UIFont systemFontOfSize:20.0]];
        [_priceView addSubview:_currentPrice];
        [_currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceView).mas_offset(13.0);
            make.top.mas_equalTo(self.priceView);
            make.bottom.mas_equalTo(self.priceView);
        }];
    }

    if (!_originalPrice) {
        _originalPrice = [[UILabel alloc] init];
        [_originalPrice setTextColor:COLOR_999999];
        [_originalPrice setFont:[UIFont systemFontOfSize:11.0]];
        [_priceView addSubview:_originalPrice];
        [_originalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.currentPrice.mas_right).mas_offset(13.0);
            make.top.mas_equalTo(self.priceView).mas_offset(5.0);
            make.bottom.mas_equalTo(self.priceView);
        }];
    }

    if (!_favoriteBtn) {
        _favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteBtn setImage:[UIImage imageNamed:@"ic_detail_favorite_nor.png"] forState:UIControlStateNormal];
        [_favoriteBtn setImage:[UIImage imageNamed:@"ic_detail_favorite_selected.png"] forState:UIControlStateSelected];
        [_favoriteBtn setHidden:YES];
        [_priceView addSubview:_favoriteBtn];
        [_favoriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.width.mas_equalTo(20.0);
            make.height.mas_equalTo(20.0);
            make.right.mas_equalTo(self.priceView).mas_offset(-20.0);
        }];
        [_favoriteBtn addTarget:self action:@selector(handleTapFavoriteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }

    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        [_goodsView addSubview:_nameView];
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceView.mas_bottom).mas_offset(15.0);
            make.left.mas_equalTo(self.goodsView);
            make.right.mas_equalTo(self.goodsView);
            make.height.mas_equalTo(0.0).priorityLow();
        }];
    }

    if (!_nameLabel) {
        _nameLabel = [[ZXLabel alloc] init];
        [_nameLabel setNumberOfLines:0];
        [_nameLabel setFont:[UIFont systemFontOfSize:[self autoScaleWidth:13.0] weight:UIFontWeightMedium]];
        [_nameLabel setPreferredMaxLayoutWidth:SCREENWIDTH - 26.0];
        [_nameLabel setTextColor:[UtilsMacro colorWithHexString:@"333333"]];
        [_nameView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.nameView);
            make.left.mas_equalTo(13.0);
            make.right.mas_equalTo(-13.0);
        }];
    }

    if (!_awardView) {
        _awardView = [[UIView alloc] init];
        [_goodsView addSubview:_awardView];
        [_awardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.goodsView);
            make.height.mas_equalTo(30.0);
            make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(5.0);
        }];
    }

    if (!_couponLabel) {
        _couponLabel = [[UILabel alloc] init];
        [_couponLabel setTextColor:[UIColor whiteColor]];
        [_couponLabel setBackgroundColor:[UtilsMacro colorWithHexString:@"CC0000"]];
        [_couponLabel setFont:[UIFont systemFontOfSize:10.0]];
        [self.awardView addSubview:_couponLabel];
        [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.awardView).mas_offset(10.0);
            make.top.mas_equalTo(self.awardView).mas_offset(6.0);
            make.bottom.mas_equalTo(self.awardView).mas_offset(-6.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }

    if (!_commissionLabel) {
        _commissionLabel = [[UILabel alloc] init];
        [_commissionLabel setTextColor:[UIColor whiteColor]];
        [_commissionLabel setBackgroundColor:[UtilsMacro colorWithHexString:@"FE560F"]];
        [_commissionLabel setFont:[UIFont systemFontOfSize:10.0]];
        [self.awardView addSubview:_commissionLabel];
        [_commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponLabel.mas_right).mas_offset(5.0);
            make.top.mas_equalTo(self.awardView).mas_offset(6.0);
            make.bottom.mas_equalTo(self.awardView).mas_offset(-6.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }

    if (!_soldLab) {
        _soldLab = [[UILabel alloc] init];
        [_soldLab setFont:[UIFont systemFontOfSize:10.0]];
        [_soldLab setTextColor:COLOR_999999];
        [_awardView addSubview:_soldLab];
        [_soldLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.awardView).mas_offset(5.0);
            make.bottom.mas_equalTo(self.awardView).mas_offset(-5.0);
            make.width.mas_equalTo(0.0).priorityLow();
            make.right.mas_equalTo(self.awardView).mas_offset(-15.0);
        }];
    }
    
    if (!_promoteView) {
        _promoteView = [[UIView alloc] init];
        [_promoteView setBackgroundColor:[UtilsMacro colorWithHexString:@"FFEEEE"]];
        [_promoteView setClipsToBounds:YES];
        [_promoteView.layer setCornerRadius:5.0];
        [_goodsView addSubview:_promoteView];
        [_promoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.awardView.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(13.0);
            make.right.mas_equalTo(-13.0);
            make.height.mas_equalTo(30.0);
        }];
    }
    
    if (!_promoteLab) {
        _promoteLab = [[UILabel alloc] init];
//        [_promoteLab setText:@"升级最高奖励20.50"];
        [_promoteLab setTextColor:THEME_COLOR];
        [_promoteLab setFont:[UIFont systemFontOfSize:10.0]];
        [_promoteView addSubview:_promoteLab];
        [_promoteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(10.0);
        }];
    }
    
    if (!_checkPromote) {
        _checkPromote = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkPromote.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_checkPromote setTitleColor:[UtilsMacro colorWithHexString:@"FF6B2C"] forState:UIControlStateNormal];
        [_checkPromote setImage:[UIImage imageNamed:@"ic_detail_check"] forState:UIControlStateNormal];
//        [_checkPromote setTitle:@"了解详情" forState:UIControlStateNormal];
        [_checkPromote setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_checkPromote addTarget:self action:@selector(handleTapCheckPromoteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_promoteView addSubview:_checkPromote];
        [_checkPromote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.right.mas_equalTo(-3.0);
        }];
    }

    if (!_descView) {
        _descView = [[UIView alloc] init];
        [_goodsView addSubview:_descView];
        [_descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.goodsView);
            make.right.mas_equalTo(self.goodsView);
            make.height.mas_equalTo(0.0).priorityLow();
            make.top.mas_equalTo(self.promoteView.mas_bottom).mas_offset(15.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }

    if (!_descImg) {
        _descImg = [[UIImageView alloc] init];
        [_descImg setContentMode:UIViewContentModeScaleAspectFit];
        [_descImg setImage:[UIImage imageNamed:@"ic_detail_flag.png"]];
        [_descView addSubview:_descImg];
        [_descImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.descView);
            make.left.mas_equalTo(self.descView).mas_offset(13.0);
            make.width.mas_equalTo(17.0);
            make.height.mas_equalTo(10.0);
        }];
    }

    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        [_descLab setFont:[UIFont systemFontOfSize:[self autoScaleWidth:11.0]]];
        [_descLab setNumberOfLines:0];
        [_descLab setPreferredMaxLayoutWidth:SCREENWIDTH - 51.0];
        [_descLab setTextColor:COLOR_666666];
        [_descView addSubview:_descLab];
        [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descImg.mas_right).mas_offset(8.0);
            make.top.mas_equalTo(0.0);
            make.right.mas_equalTo(-13.0);
            make.bottom.mas_equalTo(-15.0);
        }];
    }

    if (!_couponView) {
        _couponView = [[UIView alloc] init];
        [_couponView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_couponView];
        [_couponView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.mainView);
            make.height.mas_equalTo(100.0);
            make.top.mas_equalTo(self.goodsView.mas_bottom).mas_offset(5.0);
        }];
    }

    if (!_couponBgImg) {
        _couponBgImg = [[UIImageView alloc] init];
        [_couponBgImg setUserInteractionEnabled:YES];
        [_couponBgImg setImage:[UIImage imageNamed:@"icon_detail_coupon.png"]];
        [_couponView addSubview:_couponBgImg];
        [_couponBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponView).mas_offset(12.0);
            make.right.mas_equalTo(self.couponView).mas_offset(-12.0);
            make.top.mas_equalTo(self.couponView).mas_offset(12.0);
            make.bottom.mas_equalTo(self.couponView).mas_offset(-12.0);
        }];
    }

    if (!_couponContentView) {
        _couponContentView = [[UIView alloc] init];
        [_couponView addSubview:_couponContentView];
        [_couponContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponView).mas_offset(12.0);
            make.right.mas_equalTo(-132.0);
            make.top.mas_equalTo(self.couponView).mas_offset(12.0);
            make.bottom.mas_equalTo(self.couponView).mas_offset(-12.0);
        }];
    }

    if (!_couponTipImg) {
        _couponTipImg = [[UIImageView alloc] init];
        [_couponTipImg setContentMode:UIViewContentModeScaleAspectFit];
        [_couponTipImg setImage:[UIImage imageNamed:@"icon_detail_sum.png"]];
        [_couponContentView addSubview:_couponTipImg];
        [_couponTipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponContentView).mas_offset(18.0);
            make.top.mas_equalTo(self.couponContentView).mas_offset(34.0);
            make.width.mas_equalTo(15.0);
            make.height.mas_equalTo(15.0);
        }];
    }

    if (!_couponLab) {
        _couponLab = [[UILabel alloc] init];
        [_couponLab setTextColor:[UIColor whiteColor]];
        [_couponLab setFont:[UIFont systemFontOfSize:28.0]];
//        if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0) {
//            [_couponLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        } else {
//            [_couponLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        }
        [_couponContentView addSubview:_couponLab];
        [_couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponTipImg.mas_right).mas_offset(5.0);
            make.top.mas_equalTo(self.couponContentView);
            make.bottom.mas_equalTo(self.couponContentView);
            make.width.mas_equalTo(0.0);
        }];
    }

    UIView *couponTipView = [[UIView alloc] init];
    [_couponContentView addSubview:couponTipView];
    [couponTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.couponLab.mas_right).mas_offset(10.0);
        make.right.mas_equalTo(self.couponContentView);
        make.top.mas_equalTo(self.couponContentView);
        make.bottom.mas_equalTo(self.couponContentView);
    }];

    if (!_couponNameLab) {
        _couponNameLab = [[UILabel alloc] init];
        [_couponNameLab setFont:[UIFont systemFontOfSize:9.0]];
        [_couponNameLab setTextColor:[UIColor whiteColor]];
        [couponTipView addSubview:_couponNameLab];
        [_couponNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(couponTipView);
            make.right.mas_equalTo(couponTipView);
            make.height.mas_equalTo(15.0);
            make.top.mas_equalTo(couponTipView).mas_offset(22.0);
        }];
    }

    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setFont:[UIFont systemFontOfSize:9.0]];
        [_timeLab setTextColor:[UtilsMacro colorWithHexString:@"FEC998"]];
        [couponTipView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(couponTipView);
            make.right.mas_equalTo(couponTipView);
            make.top.mas_equalTo(self.couponNameLab.mas_bottom).mas_offset(5.0);
            make.height.mas_equalTo(11.0);
        }];
    }

    if (!_fetchBtn) {
        _fetchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        [_fetchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_couponView addSubview:_fetchBtn];
        [_fetchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12.0);
            make.right.mas_equalTo(-12.0);
            make.bottom.mas_equalTo(-12.0);
            make.width.mas_equalTo(100.0);
        }];
        [_fetchBtn addTarget:self action:@selector(handleTapFetchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!_dotImg) {
        _dotImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_dot"]];
        [_dotImg setContentMode:UIViewContentModeScaleAspectFit];
        [_dotImg setClipsToBounds:YES];
        [_couponView addSubview:_dotImg];
        [_dotImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.fetchBtn.mas_left).mas_offset(0.0);
            make.top.mas_equalTo(12.0);
            make.bottom.mas_equalTo(-12.0);
            make.width.mas_equalTo(20.0);
        }];
    }

    if (!_shopView) {
        _shopView = [[UIView alloc] init];
        [_shopView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_shopView];
        [_shopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.mainView);
            make.top.mas_equalTo(self.couponView.mas_bottom).mas_offset(5.0);
            make.height.mas_equalTo(80.0);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }

    if (!_shopImg) {
        _shopImg = [[UIImageView alloc] init];
        [_shopImg setContentMode:UIViewContentModeScaleAspectFill];
        [_shopImg.layer setCornerRadius:5.0];
        [_shopImg setClipsToBounds:YES];
        [_shopImg setBackgroundColor:[UIColor whiteColor]];
        [_shopView addSubview:_shopImg];
        [_shopImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13.0);
            make.top.mas_equalTo(self.shopView).mas_offset(15.0);
            make.bottom.mas_equalTo(self.shopView).mas_offset(-15.0);
            make.width.mas_equalTo(50.0);
        }];
    }

    UIView *topView = [[UIView alloc] init];
    [_shopView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopImg.mas_right).mas_offset(10.0);
        make.height.mas_equalTo(15.0);
        make.top.mas_equalTo(self.shopView).mas_offset(15.0);
        make.right.mas_equalTo(self.shopView);
    }];

    if (!_shopName) {
        _shopName = [[UILabel alloc] init];
        [_shopName setFont:[UIFont systemFontOfSize:12.0]];
        [_shopName setTextColor:HOME_TITLE_COLOR];
        [topView addSubview:_shopName];
        [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(topView);
            make.top.bottom.mas_equalTo(topView);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }

    if (!_shopScore) {
        _shopScore = [[UILabel alloc] init];
        [_shopScore setFont:[UIFont systemFontOfSize:10.0]];
        [_shopScore setTextColor:COLOR_999999];
        [topView addSubview:_shopScore];
        [_shopScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(topView).mas_offset(-13.0);
            make.top.bottom.mas_equalTo(topView);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }

    UIView *middleView = [[UIView alloc] init];
    [_shopView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopImg.mas_right).mas_offset(10.0);
        make.height.mas_equalTo(15.0);
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(0.0);
        make.right.mas_equalTo(self.shopView).mas_offset(13.0);
    }];

    if (!_shopCount) {
        _shopCount = [[UILabel alloc] init];
        [_shopCount setFont:[UIFont systemFontOfSize:10.0]];
        [_shopCount setTextColor:COLOR_999999];
        [middleView addSubview:_shopCount];
        [_shopCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(middleView);
        }];
    }

    UIView *bottomView = [[UIView alloc] init];
    [_shopView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopImg.mas_right).mas_offset(10.0);
        make.height.mas_equalTo(20.0);
        make.top.mas_equalTo(middleView.mas_bottom).mas_offset(0.0);
        make.right.mas_equalTo(self.shopView).mas_offset(13.0);
    }];
    UIView *evaluateView = [[UIView alloc] init];
    UIView *serviceView = [[UIView alloc] init];
    UIView *diliverView = [[UIView alloc] init];

    [bottomView addSubview:evaluateView];
    [bottomView addSubview:serviceView];
    [bottomView addSubview:diliverView];
    NSMutableArray *viewList = [[NSMutableArray alloc] initWithObjects:evaluateView, serviceView, diliverView, nil];
    [viewList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.0);
    }];

    if (!_evaluateLab) {
        _evaluateLab = [[UILabel alloc] init];
        [_evaluateLab setFont:[UIFont systemFontOfSize:10.0]];
        [_evaluateLab setTextColor:COLOR_999999];
        [evaluateView addSubview:_evaluateLab];
        [_evaluateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(45.0);
        }];
    }

    if (!_goodsEvaluate) {
        _goodsEvaluate = [[UILabel alloc] init];
        [_goodsEvaluate setFont:[UIFont systemFontOfSize:10.0]];
        [_goodsEvaluate setTextColor:[UtilsMacro colorWithHexString:@"64A942"]];
        [evaluateView addSubview:_goodsEvaluate];
        [_goodsEvaluate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(self.evaluateLab.mas_right);
        }];
    }

    if (!_serviceLab) {
        _serviceLab = [[UILabel alloc] init];
        [_serviceLab setFont:[UIFont systemFontOfSize:10.0]];
        [_serviceLab setTextColor:COLOR_999999];
        [serviceView addSubview:_serviceLab];
        [_serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(45.0);
        }];
    }

    if (!_serviceLabel) {
        _serviceLabel = [[UILabel alloc] init];
        [_serviceLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_serviceLabel setTextColor:[UtilsMacro colorWithHexString:@"64A942"]];
        [serviceView addSubview:_serviceLabel];
        [_serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(self.serviceLab.mas_right);
        }];
    }

    if (!_diliverLab) {
        _diliverLab = [[UILabel alloc] init];
        [_diliverLab setFont:[UIFont systemFontOfSize:10.0]];
        [_diliverLab setTextColor:COLOR_999999];
        [diliverView addSubview:_diliverLab];
        [_diliverLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(45.0);
        }];
    }

    if (!_diliverLabel) {
        _diliverLabel = [[UILabel alloc] init];
        [_diliverLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_diliverLabel setTextColor:[UtilsMacro colorWithHexString:@"64A942"]];
        [diliverView addSubview:_diliverLabel];
        [_diliverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(self.diliverLab.mas_right);
        }];
    }
}

#pragma mark - Button Methods

- (void)handleTapFavoriteBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeaderViewHandleTapFavoriteBtnAction)]) {
        [self.delegate detailHeaderViewHandleTapFavoriteBtnAction];
    }
}

- (void)handleTapFetchBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeaderViewHandleTapFetchBtnAction)]) {
        [self.delegate detailHeaderViewHandleTapFetchBtnAction];
    }
}

- (void)handleTapCheckPromoteBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeaderViewHandleTapCheckPromoteBtnAction)]) {
        [self.delegate detailHeaderViewHandleTapCheckPromoteBtnAction];
    }
}

@end
