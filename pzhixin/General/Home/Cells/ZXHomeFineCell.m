//
//  ZXHomeFineCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeFineCell.h"

@interface ZXHomeFineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation ZXHomeFineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imgBounds = CGRectMake(0.0, 0.0, (SCREENWIDTH - 10.0)/3.0 - 40.0, (SCREENWIDTH - 10.0)/3.0 - 40.0);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imgBounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = imgBounds;
    maskLayer.path = maskPath.CGPath;
    self.goodsImg.layer.mask = maskLayer;
}

#pragma mark - Setter

- (void)setGoods:(ZXGoods *)goods {
    _goods = goods;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_goods.img] imageView:_goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    [_titleLab setText:_goods.title];
    [_priceLab setText:[NSString stringWithFormat:@"￥%@ 券后", _goods.price]];
}

@end
