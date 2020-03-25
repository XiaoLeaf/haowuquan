//
//  ZXFavoriteCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavoriteCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZXFavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.goodsImg.layer setCornerRadius:5.0];
    [self.earnLab.layer setCornerRadius:2.0];
    [self.couponLab.layer setCornerRadius:2.0];
    
    self.nameLabel = [[YYLabel alloc] init];
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setTextColor:HOME_TITLE_COLOR];
    [self.nameLabel setPreferredMaxLayoutWidth:SCREENWIDTH - 127.0];
    [self.nameLabel setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH - 127.0, self.nameView.frame.size.height)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.nameLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [self.nameView addSubview:self.nameLabel];
    
    NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"  DanielWellington手表男丹尼尔惠灵顿腕表DW手表石英男表"]];
    YYAnimatedImageView *imageView;
    //    if ([goods.store_type integerValue] == 1) {
    //        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
    //    } else if ([goods.store_type integerValue] == 2) {
    //        imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
    //    }
    imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
    [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:12.0] alignment:YYTextVerticalAlignmentCenter];
    [nameAttri insertAttributedString:attachText atIndex:0];
    [self.nameLabel setAttributedText:nameAttri];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setFavorite:(ZXFavorite *)favorite {
    _favorite = favorite;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_favorite.img] imageView:self.goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
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
    
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券后价 %@", _favorite.price]];
    [priceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 3)];
    [self.priceLab setAttributedText:priceStr];
    
    [self.originalLab setText:[NSString stringWithFormat:@"原价 %@", _favorite.ori_price]];
    [self.countLab setText:[NSString stringWithFormat:@"销量 %@", _favorite.volume]];
    [self.couponLab setText:[NSString stringWithFormat:@"%@元券   ", _favorite.coupon_amount]];
    [self.earnLab setText:[NSString stringWithFormat:@"奖%@   ", _favorite.commission]];
}

@end
