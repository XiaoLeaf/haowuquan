//
//  ZXDetailRecommendCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDetailRecommendCell.h"

@implementation ZXDetailRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self.goodsImg.layer setCornerRadius:5.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imgBounds = CGRectMake(0.0, 0.0, (SCREENWIDTH - 40.0)/3.0, 195.0);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imgBounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = imgBounds;
    maskLayer.path = maskPath.CGPath;
    self.goodsImg.layer.mask = maskLayer;
}

- (void)setGoodsInfo:(NSDictionary *)goodsInfo {
    _goodsInfo = goodsInfo;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[_goodsInfo valueForKey:@"img"]] imageView:self.goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [self.nameLabel setText:[_goodsInfo valueForKey:@"title"]];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@",[_goodsInfo valueForKey:@"price"]]];
}

- (void)setGoods:(ZXGoods *)goods {
    _goods = goods;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_goods.img] imageView:self.goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [self.nameLabel setText:_goods.title];
    
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@ 券后",_goods.price]];
    [priceStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]} range:NSMakeRange(priceStr.length - 2, 2)];
    [self.priceLabel setAttributedText:priceStr];
}

@end
