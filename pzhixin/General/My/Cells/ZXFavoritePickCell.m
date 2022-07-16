//
//  ZXFavoritePickCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavoritePickCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZXFavoritePickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self.pickBtn.layer setCornerRadius:self.pickBtn.frame.size.height/2.0];
//    [self.pickBtn.layer setBorderWidth:1.0];
//    [self.pickBtn.layer setBorderColor:[UtilsMacro colorWithHexString:@"DEDEDE"].CGColor];
    [self.goodsImg.layer setCornerRadius:5.0];
    [self.earnLab.layer setCornerRadius:2.0];
    [self.couponLab.layer setCornerRadius:2.0];
    
    self.nameLabel = [[YYLabel alloc] init];
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setTextColor:HOME_TITLE_COLOR];
    [self.nameLabel setPreferredMaxLayoutWidth:SCREENWIDTH - 157.0];
    [self.nameLabel setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH - 167.0, self.nameView.frame.size.height)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.nameLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [self.nameView addSubview:self.nameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setFavorite:(ZXFavorite *)favorite {
    _favorite = favorite;
    [self.pickBtn setSelected:_favorite.isSelected];
    
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_favorite.img] imageView:self.goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    if (![UtilsMacro whetherIsEmptyWithObject:_favorite.title]) {
        NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",_favorite.title]]];
        YYAnimatedImageView *imageView;
        if ([_favorite.shop_type integerValue] == 1) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
        } else if ([_favorite.shop_type integerValue] == 2) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
        }
        [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:12.0] alignment:YYTextVerticalAlignmentCenter];
        [nameAttri insertAttributedString:attachText atIndex:0];
        [self.nameLabel setAttributedText:nameAttri];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:_favorite.price]) {
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券后价 %@", _favorite.price]];
        [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 3)];
        [self.priceLab setAttributedText:priceStr];
    }
    
    [self.originalLab setText:[NSString stringWithFormat:@"原价 %@", _favorite.ori_price]];
    [self.countLab setText:[NSString stringWithFormat:@"销量 %@", _favorite.volume]];
    [self.couponLab setText:[NSString stringWithFormat:@"%@元券   ", _favorite.coupon_amount]];
    [self.earnLab setText:[NSString stringWithFormat:@"奖%@   ", _favorite.commission]];
}

#pragma mark - Button Method

- (IBAction)handleTapPickBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(favoritePickCellHandleTapPickBtnWithTag:andCell:)]) {
        [self.delegate favoritePickCellHandleTapPickBtnWithTag:btn.tag andCell:self];
    }
}

@end
