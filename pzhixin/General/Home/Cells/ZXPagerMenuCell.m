//
//  ZXPagerMenuCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/31.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPagerMenuCell.h"
#import <Masonry/Masonry.h>

@implementation ZXPagerMenuCell


- (id)init {
    self = [super init];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setUserInteractionEnabled:NO];
        [_menuBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self addSubview:_menuBtn];
        [_menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_menuImg) {
        _menuImg = [[UIImageView alloc] init];
        [_menuImg setClipsToBounds:NO];
        [_menuImg setContentMode:UIViewContentModeScaleAspectFit];
        [_menuImg setUserInteractionEnabled:YES];
        [self addSubview:_menuImg];
        [_menuImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0.0);
        }];
    }
}

@synthesize titleLabel;

@end
