//
//  ZXSpecialHeaderCell.m
//  pzhixin
//
//  Created by zhixin on 2019/11/27.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSpecialHeaderCell.h"
#import <Masonry/Masonry.h>

@implementation ZXSpecialHeaderCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBannerImg];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createBannerImg {
    if (!_bannerImg) {
        _bannerImg = [[UIImageView alloc] init];
        [_bannerImg setContentMode:UIViewContentModeScaleAspectFill];
        [_bannerImg setClipsToBounds:YES];
        [self addSubview:_bannerImg];
        [_bannerImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
}

@end
