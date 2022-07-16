//
//  ZXSubSingleCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSubSingleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@implementation ZXSubSingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.goodsImg.layer setCornerRadius:5.0];
//    [self.commissionLabel.layer setCornerRadius:3.0];
//    [self.couponLabel.layer setCornerRadius:3.0];
    
    self.nameLabel = [[YYLabel alloc] init];
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setTextColor:HOME_TITLE_COLOR];
    [self.nameLabel setPreferredMaxLayoutWidth:SCREENWIDTH - 150.0];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.nameLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [self.nameView addSubview:self.nameLabel];
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
    
    [self.nameView setNeedsLayout];
    [self.nameView layoutIfNeeded];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.0);
    }];
}

- (void)setGoods:(ZXGoods *)goods {
    _goods = goods;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:goods.img] imageView:self.goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [self.shopName setText:_goods.shop_title];
    
    if (![UtilsMacro whetherIsEmptyWithObject:goods.title]) {
        NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",goods.title]]];
        YYAnimatedImageView *imageView;
        if ([goods.store_type integerValue] == 1) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
        } else if ([goods.store_type integerValue] == 2) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
        }
        [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13.0] alignment:YYTextVerticalAlignmentCenter];
        [nameAttri insertAttributedString:attachText atIndex:0];
        [self.nameLabel setAttributedText:nameAttri];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:goods.price]) {
        NSString *current = [NSString stringWithFormat:@"￥%@", goods.price];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:current];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
        [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0] range:NSMakeRange(1, current.length - 1)];
        [self.currentPrice setAttributedText:attri];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:goods.zk_price]) {
        NSString *originalStr = [NSString stringWithFormat:@"￥%@",goods.zk_price];
        NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
        [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
        [self.originalPrice setText:originalStr];
    }
    
    [self.countLabel setText:[NSString stringWithFormat:@"已售%@", goods.volume]];
    
    if ([goods.coupon_amount integerValue] == 0 || [goods.coupon_amount isEqualToString:@""]) {
        [self.couponLabel setText:@""];
        self.commissionLeft.constant = 0.0;
    } else {
        [self.couponLabel setText:[NSString stringWithFormat:@" 劵 %@元  ", goods.coupon_amount]];
        self.commissionLeft.constant = 10.0;
    }
    
    [self.commissionLabel setText:[NSString stringWithFormat:@" 奖 %@  ", goods.commission]];
}

@end
