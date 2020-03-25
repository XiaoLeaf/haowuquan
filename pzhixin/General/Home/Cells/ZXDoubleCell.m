//
//  ZXDoubleCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDoubleCell.h"
#import <Masonry/Masonry.h>

@interface ZXDoubleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftGoodsImg;
@property (weak, nonatomic) IBOutlet UIView *leftNameView;
@property (strong, nonatomic) YYLabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *leftCurrent;
@property (weak, nonatomic) IBOutlet UILabel *leftOrignal;
@property (weak, nonatomic) IBOutlet UILabel *leftCoupon;
@property (weak, nonatomic) IBOutlet UILabel *leftCommission;
@property (weak, nonatomic) IBOutlet UILabel *leftCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCommissionLeft;

@property (weak, nonatomic) IBOutlet UIImageView *rightGoodsImg;
@property (weak, nonatomic) IBOutlet UIView *rightNameView;
@property (strong, nonatomic) YYLabel *rightName;
@property (weak, nonatomic) IBOutlet UILabel *rightCurrent;
@property (weak, nonatomic) IBOutlet UILabel *rightOrignal;
@property (weak, nonatomic) IBOutlet UILabel *rightCoupon;
@property (weak, nonatomic) IBOutlet UILabel *rightCommission;
@property (weak, nonatomic) IBOutlet UILabel *rightCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCommissionLeft;


@end

@implementation ZXDoubleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:BG_COLOR];
    [self.leftGoodsView.layer setCornerRadius:5.0];
    [self.rightGoodsView.layer setCornerRadius:5.0];
    
    self.leftName = [[YYLabel alloc] init];
    [self.leftName setNumberOfLines:0];
    [self.leftName setTextColor:HOME_TITLE_COLOR];
    [self.leftName setPreferredMaxLayoutWidth:(SCREENWIDTH - 15.0)/2.0 - 20.0];
    [self.leftName setFrame:CGRectMake(10.0, 0.0, (SCREENWIDTH - 15.0)/2.0 - 20.0, self.leftNameView.frame.size.height)];
    [self.leftName setFont:[UIFont systemFontOfSize:12.0]];
    [self.leftNameView addSubview:self.leftName];
    
    self.rightName = [[YYLabel alloc] init];
    [self.rightName setNumberOfLines:0];
    [self.rightName setTextColor:HOME_TITLE_COLOR];
    [self.rightName setPreferredMaxLayoutWidth:(SCREENWIDTH - 15.0)/2.0 - 20.0];
    [self.rightName setFrame:CGRectMake(10.0, 0.0, (SCREENWIDTH - 15.0)/2.0 - 20.0, self.rightNameView.frame.size.height)];
    [self.rightName setFont:[UIFont systemFontOfSize:12.0]];
    [self.rightNameView addSubview:self.rightName];
    
    UITapGestureRecognizer *tapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLeftGoodsViewAction)];
    [self.leftGoodsView addGestureRecognizer:tapLeft];
    
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapRightGoodsViewAction)];
    [self.rightGoodsView addGestureRecognizer:tapRight];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftCoupon setNeedsLayout];
    [self.leftCoupon layoutIfNeeded];
    [self.leftCommission setNeedsLayout];
    [self.leftCommission layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.leftCoupon.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.leftCoupon.bounds;
    maskLayer.path = maskPath.CGPath;
    self.leftCoupon.layer.mask = maskLayer;
    //
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.leftCommission.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.leftCommission.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.leftCommission.layer.mask = maskLayer1;
    
    [self.rightCoupon setNeedsLayout];
    [self.rightCoupon layoutIfNeeded];
    [self.rightCommission setNeedsLayout];
    [self.rightCommission layoutIfNeeded];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.rightCoupon.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.frame = self.rightCoupon.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.rightCoupon.layer.mask = maskLayer2;
    //
    UIBezierPath *maskPath3 = [UIBezierPath bezierPathWithRoundedRect:self.rightCommission.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer3 = [CAShapeLayer layer];
    maskLayer3.frame = self.rightCommission.bounds;
    maskLayer3.path = maskPath3.CGPath;
    self.rightCommission.layer.mask = maskLayer3;
    
    [self.leftNameView setNeedsLayout];
    [self.leftNameView layoutIfNeeded];
    [self.leftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.0);
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
    }];
    
    [self.rightNameView setNeedsLayout];
    [self.rightNameView layoutIfNeeded];
    [self.rightName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.0);
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
    }];
    
    //Dark模式适配
//    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//        [self.leftName setTextColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
//        [self.rightName setTextColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
//    } else {
//        [self.leftName setTextColor:HOME_TITLE_COLOR];
//        [self.rightName setTextColor:HOME_TITLE_COLOR];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftGoods:(ZXGoods *)leftGoods {
    _leftGoods = leftGoods;
    
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_leftGoods.img] imageView:self.leftGoodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_leftGoods.title]]];
    YYAnimatedImageView *imageView;
    if ([_leftGoods.store_type integerValue] == 1) {
        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
    } else if ([_leftGoods.store_type integerValue] == 2) {
        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
    }
    [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13.0] alignment:YYTextVerticalAlignmentCenter];
    [nameAttri insertAttributedString:attachText atIndex:0];
    [self.leftName setAttributedText:nameAttri];
    
    NSString *current = [NSString stringWithFormat:@"￥%@", _leftGoods.price];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:current];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0] range:NSMakeRange(1, current.length - 1)];
    [self.leftCurrent setAttributedText:attri];
    
    NSString *originalStr = [NSString stringWithFormat:@"￥%@",_leftGoods.zk_price];
    NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
    [self.leftOrignal setText:originalStr];
    
    [self.leftCount setText:[NSString stringWithFormat:@"已售%@", _leftGoods.volume]];
    
    if ([_leftGoods.coupon_amount integerValue] == 0 || [_leftGoods.coupon_amount isEqualToString:@""]) {
        [self.leftCoupon setText:@""];
        self.leftCommissionLeft.constant = 0.0;
    } else {
        [self.leftCoupon setText:[NSString stringWithFormat:@" 劵 %@元  ", _leftGoods.coupon_amount]];
        self.leftCommissionLeft.constant = 5.0;
    }
    
    [self.leftCommission setText:[NSString stringWithFormat:@" 奖 %@  ", _leftGoods.commission]];
}

- (void)setRightGoods:(ZXGoods *)rightGoods {
    _rightGoods = rightGoods;
    
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_rightGoods.img] imageView:self.rightGoodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_rightGoods.title]]];
    YYAnimatedImageView *imageView;
    if ([_rightGoods.store_type integerValue] == 1) {
        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
    } else if ([_rightGoods.store_type integerValue] == 2) {
        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
    }
    [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13.0] alignment:YYTextVerticalAlignmentCenter];
    [nameAttri insertAttributedString:attachText atIndex:0];
    [self.rightName setAttributedText:nameAttri];
    
    NSString *current = [NSString stringWithFormat:@"￥%@", _rightGoods.price];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:current];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0] range:NSMakeRange(1, current.length - 1)];
    [self.rightCurrent setAttributedText:attri];
    
    NSString *originalStr = [NSString stringWithFormat:@"￥%@",_rightGoods.zk_price];
    NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
    [self.rightOrignal setText:originalStr];
    
    [self.rightCount setText:[NSString stringWithFormat:@"已售%@", _rightGoods.volume]];
    
    if ([_rightGoods.coupon_amount integerValue] == 0 || [_rightGoods.coupon_amount isEqualToString:@""]) {
        [self.rightCoupon setText:@""];
        self.rightCommissionLeft.constant = 0.0;
    } else {
        [self.rightCoupon setText:[NSString stringWithFormat:@" 劵 %@元  ", _rightGoods.coupon_amount]];
        self.rightCommissionLeft.constant = 5.0;
    }
    
    [self.rightCommission setText:[NSString stringWithFormat:@" 奖 %@  ", _rightGoods.commission]];
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapLeftGoodsViewAction {
    if (self.zxDoubleCellLeftGoodsClick) {
        self.zxDoubleCellLeftGoodsClick(self.leftGoodsView.tag);
    }
}

- (void)handleTapRightGoodsViewAction {
    if (self.zxDoubleCellRightGoodsClick) {
        self.zxDoubleCellRightGoodsClick(self.rightGoodsView.tag);
    }
}

@end
