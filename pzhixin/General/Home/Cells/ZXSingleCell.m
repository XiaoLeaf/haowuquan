//
//  ZXSingleCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSingleCell.h"
#import <Masonry/Masonry.h>

@interface ZXSingleCell ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) YYLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *currentLab;
@property (weak, nonatomic) IBOutlet UILabel *orignalLab;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UILabel *comissionLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissionLeft;

@end

@implementation ZXSingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.goodsImg.layer setCornerRadius:5.0];
    
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
    [self.couponLab setNeedsLayout];
    [self.couponLab layoutIfNeeded];
    [self.comissionLab setNeedsLayout];
    [self.comissionLab layoutIfNeeded];
    //    NSLog(@"self.couponLabel:%@",self.couponLabel);
    //    NSLog(@"self.commissionLabel:%@",self.commissionLabel);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.couponLab.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.couponLab.bounds;
    maskLayer.path = maskPath.CGPath;
    self.couponLab.layer.mask = maskLayer;
    //
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.comissionLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.comissionLab.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.comissionLab.layer.mask = maskLayer1;
    
    [self.nameView setNeedsLayout];
    [self.nameView layoutIfNeeded];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        [self.currentLab setAttributedText:attri];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:goods.zk_price]) {
        NSString *originalStr = [NSString stringWithFormat:@"￥%@",goods.zk_price];
        NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
        [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
        [self.orignalLab setText:originalStr];
    }
    
    [self.countLab setText:[NSString stringWithFormat:@"已售%@", goods.volume]];
    
    if ([goods.coupon_amount integerValue] == 0 || [goods.coupon_amount isEqualToString:@""]) {
        [self.couponLab setText:@""];
        self.commissionLeft.constant = 0.0;
    } else {
        [self.couponLab setText:[NSString stringWithFormat:@" 劵 %@元  ", goods.coupon_amount]];
        self.commissionLeft.constant = 5.0;
    }
    
    [self.comissionLab setText:[NSString stringWithFormat:@" 奖 %@  ", goods.commission]];
}

@end
