//
//  ZXOrderHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/9/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOrderHeader.h"
#import <Masonry/Masonry.h>

@implementation ZXOrderHeader

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
        [self setBackgroundColor:BG_COLOR];
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [_mainView setClipsToBounds:YES];
        UITapGestureRecognizer *tapMain = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOrderHeader)];
        [_mainView addGestureRecognizer:tapMain];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.5);
            make.height.mas_equalTo(30.0).priorityHigh();
            make.left.right.mas_equalTo(0.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setText:@"订单及其相关的常见问题，请点击次此处查看"];
        [_titleLab setFont:[UIFont systemFontOfSize:10.0]];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleLab setTextColor:COLOR_999999];
        [_mainView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13.0);
            make.right.mas_equalTo(-13.0);
            make.bottom.top.mas_equalTo(0.0);
        }];
    }
}

- (void)handleTapOrderHeader {
    if (self.zxOrderHeaderClick) {
        self.zxOrderHeaderClick();
    }
}

@end
