//
//  ZXWelfareCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXWelfareCell.h"

@interface ZXWelfareCell () {
    BOOL againLoad;
}

@end

@implementation ZXWelfareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    againLoad = NO;
    [self setFd_enforceFrameLayout:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setWelfare:(ZXWelfare *)welfare {
    _welfare = welfare;
//    [self.testImg sd_setImageWithURL:[NSURL URLWithString:welfare.imgUrl] placeholderImage:nil];
    [self.testImg sd_setImageWithURL:[NSURL URLWithString:welfare.imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (self->againLoad) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(welfareCellImgDownloadCompletedWithIndexPath:)]) {
            self->againLoad = YES;
            [self.delegate welfareCellImgDownloadCompletedWithIndexPath:welfare.indexPath];
        }
    }];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.testImg sizeThatFits:size].height;
    return CGSizeMake(size.width, totalHeight);
}

@end
