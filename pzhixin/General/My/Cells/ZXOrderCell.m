//
//  ZXOrderCell.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOrderCell.h"
#import <Masonry/Masonry.h>

@implementation ZXOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:BG_COLOR];
    [self.goodsImg.layer setCornerRadius:5.0];
    [self.cpBtn.layer setCornerRadius:self.cpBtn.frame.size.height/2.0];
    [self.cpBtn.layer setBorderWidth:0.5];
    [self.cpBtn.layer setBorderColor:COLOR_999999.CGColor];
    
    self.nameLabel = [[YYLabel alloc] init];
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setTextColor:HOME_TITLE_COLOR];
    [self.nameLabel setPreferredMaxLayoutWidth:SCREENWIDTH - 142.0];
    [self.nameLabel setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [self.nameLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.nameLabel setTextColor:COLOR_666666];
    
    [self.nameView addSubview:self.nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
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

- (void)setOrder:(ZXOrder *)order {
    _order = order;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_order.img] imageView:self.goodsImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
        
    if (![UtilsMacro whetherIsEmptyWithObject:_order.title]) {
        NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_order.title]]];
        YYAnimatedImageView *imageView;
        if ([order.order_type integerValue] == 1) {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
        } else {
            imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
        }
        [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:12.0] alignment:YYTextVerticalAlignmentTop];
        [nameAttri insertAttributedString:attachText atIndex:0];
        [self.nameLabel setAttributedText:nameAttri];
    }
    
    [self.orderNumLab setText:[NSString stringWithFormat:@"订单号:%@",_order.order_id]];
    [self.statusLab setText:_order.status_str];
    [self.createTime setText:[NSString stringWithFormat:@"创建日:%@",_order.create_time]];
    [self.clearTime setText:[NSString stringWithFormat:@"结算日:%@",_order.earning_time]];
    [self.priceLab setText:[NSString stringWithFormat:@"付款金额 ￥%@",_order.amount]];
    if (![UtilsMacro whetherIsEmptyWithObject:_order.bonus]) {
        NSMutableAttributedString *earnStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估奖励 ￥%@",_order.bonus]];
        [earnStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium] range:NSMakeRange(0, 6)];
        [earnStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium] range:NSMakeRange(6, earnStr.length - 6)];
        [self.benefitLab setAttributedText:earnStr];
    }
}

#pragma mark - Button Method

- (IBAction)handleTapCpBtnAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCellHandleTapCpBtnActionWithTag:)]) {
        [self.delegate orderCellHandleTapCpBtnActionWithTag:button.tag];
    }
}

@end
