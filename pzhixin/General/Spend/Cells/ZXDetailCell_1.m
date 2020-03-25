//
//  ZXDetailCell_1.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDetailCell_1.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import <YYImage/YYImage.h>

@implementation ZXDetailCell_1

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:BG_COLOR];
    self.goodsViewTop.constant = SCREENWIDTH - 5.0;
    // Initialization code
    CGRect goodsRect = CGRectMake(0.0, 0.0, SCREENWIDTH, self.goodsView.frame.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:goodsRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = goodsRect;
    maskLayer.path = maskPath.CGPath;
    self.goodsView.layer.mask = maskLayer;
    
    [self.shopImg.layer setCornerRadius:5.0];
//    [self.commissionLabel.layer setCornerRadius:5.0];
    
    self.nameLabel = [[YYLabel alloc] init];
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    [self.nameLabel setPreferredMaxLayoutWidth:SCREENWIDTH - 20.0];
    [self.nameLabel setFrame:CGRectMake(10.0, 0.0, SCREENWIDTH - 20.0, self.nameView.frame.size.height)];
    [self.nameLabel setTextColor:[UtilsMacro colorWithHexString:@"333333"]];
    [self.nameView addSubview:self.nameLabel];
    
//    NSLog(@"self.awardView:%@",self.awardView);
    
    self.couponLabel = [[UILabel alloc] init];
    [self.couponLabel setTextColor:[UIColor whiteColor]];
    [self.couponLabel setBackgroundColor:[UtilsMacro colorWithHexString:@"CC0000"]];
    [self.couponLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.awardView addSubview:self.couponLabel];
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.awardView).mas_offset(10.0);
        make.top.mas_equalTo(self.awardView).mas_offset(6.0);
        make.bottom.mas_equalTo(self.awardView).mas_offset(-6.0);
        make.width.mas_equalTo(0.0).priorityLow();
    }];
    
    self.commissionLabel = [[UILabel alloc] init];
    [self.commissionLabel setTextColor:[UIColor whiteColor]];
    [self.commissionLabel setBackgroundColor:THEME_COLOR];
    [self.commissionLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.awardView addSubview:self.commissionLabel];
    [self.commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.couponLabel.mas_right).mas_offset(5.0);
        make.top.mas_equalTo(self.awardView).mas_offset(6.0);
        make.bottom.mas_equalTo(self.awardView).mas_offset(-6.0);
        make.width.mas_equalTo(0.0).priorityLow();
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.couponLabel setNeedsLayout];
    [self.couponLabel layoutIfNeeded];
    [self.commissionLabel setNeedsLayout];
    [self.commissionLabel layoutIfNeeded];
//    NSLog(@"self.couponLabel:%@",self.couponLabel);
//    NSLog(@"self.commissionLabel:%@",self.commissionLabel);
    
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
}

- (void)setGoodsDetail:(ZXGoodsDetail *)goodsDetail {
    _goodsDetail = goodsDetail;
    [self.bannerView setImgUrlList:_goodsDetail.row.slides];
    if (![UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.video]) {
        [self.bannerView setVideoUrl:_goodsDetail.row.video];
        [self.bannerView.player setPlayerDidToEnd:^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell1PlayerDidPlayToEnd)]) {
                [self.delegate detailCell1PlayerDidPlayToEnd];
            }
        }];
    }
    
    NSString *currentStr = [NSString stringWithFormat:@"券后价￥%@",_goodsDetail.row.price];
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:currentStr];
    [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] range:NSMakeRange(0, 4)];
    [priceStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0] range:NSMakeRange(4, currentStr.length - 4)];
    [self.currentPrice setAttributedText:priceStr];
    
    NSString *originalStr = [NSString stringWithFormat:@"原价￥%@", _goodsDetail.row.ori_price];
    NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
    [self.originalPrice setAttributedText:originalAttri];
    
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
    
    [self.commissionLabel setText:[NSString stringWithFormat:@"  奖 %@  ",_goodsDetail.row.commission]];
    [self.soldLab setText:[NSString stringWithFormat:@"已售%@", _goodsDetail.row.volume]];
    
    if ([_goodsDetail.row.coupon_amount integerValue] == 0 || [_goodsDetail.row.coupon_amount isEqualToString:@""]) {
        [self.couponLabel setText:@""];
        [self.couponLab setText:@""];
        self.commissionLeft.constant = 0.0;
        [self.timeLab setText:@""];
        [self.couponNameLab setText:@""];
    } else {
        [self.couponNameLab setText:_goodsDetail.row.coupon_info];
        [self.couponLabel setText:[NSString stringWithFormat:@"  券 %@ 元  ", _goodsDetail.row.coupon_amount]];
        [self.couponLab setText: _goodsDetail.row.coupon_amount];
        self.commissionLeft.constant = 5.0;
        [self.timeLab setText:[NSString stringWithFormat:@"%@ ~ %@", _goodsDetail.row.coupon_start_time, _goodsDetail.row.coupon_end_time]];
    }
    [self.descLab setText:_goodsDetail.row.desc];
    
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

#pragma mark - Button Methods

- (IBAction)handleTapFetchBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell1HandleTapFetchBtnAction)]) {
        [self.delegate detailCell1HandleTapFetchBtnAction];
    }
}

- (IBAction)handleTapFavoriteBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell1HandleTapFavoriteBtnAction)]) {
        [self.delegate detailCell1HandleTapFavoriteBtnAction];
    }
}
@end
