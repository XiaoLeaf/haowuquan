//
//  ZXPosterView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPosterView.h"
#import <Masonry/Masonry.h>

@implementation ZXPosterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:5.0];
        [self setClipsToBounds:YES];
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_posterImg) {
        _posterImg = [[UIImageView alloc] init];
        [_posterImg setClipsToBounds:YES];
        [_posterImg setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_posterImg];
        [_posterImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0.0);
        }];
    }
}

@end
