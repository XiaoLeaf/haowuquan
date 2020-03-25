//
//  ZXRefreshFooter.m
//  pzhixin
//
//  Created by zhixin on 2019/10/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRefreshFooter.h"
#import <Masonry/Masonry.h>

@interface ZXRefreshFooter ()

@property (strong, nonatomic) UIView *leftLine;

@property (strong, nonatomic) UIImageView *logoImg;

@property (strong, nonatomic) UIImageView *loadingImg;

@property (strong, nonatomic) UIImage *gifImg;

@property (strong, nonatomic) UIView *rightLine;

@end

@implementation ZXRefreshFooter

- (void)prepare {
    [super prepare];
    MASAttachKeys(self);
    self.mj_h = 60.0;
    
    _loadingImg = [[UIImageView alloc] init];
    [_loadingImg setContentMode:UIViewContentModeScaleAspectFit];
    [_loadingImg setClipsToBounds:YES];
    MASAttachKeys(_loadingImg);
    [self addSubview:_loadingImg];
    
    _stateLab = [[UILabel alloc] init];
    [_stateLab setTextColor:COLOR_999999];
    [_stateLab setTextAlignment:NSTextAlignmentCenter];
    [_stateLab setFont:[UIFont systemFontOfSize:10.0]];
    MASAttachKeys(_stateLab);
    [self addSubview:_stateLab];
    
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"header" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    _gifImg = [UIImage sd_imageWithGIFData:gifData];
    [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_dark]] placeholderImage:_gifImg];
    
    _logoImg = [[UIImageView alloc] init];
    [_logoImg setContentMode:UIViewContentModeScaleAspectFit];
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_dark]]];
    [_logoImg setHidden:YES];
    MASAttachKeys(_logoImg);
    [self addSubview:_logoImg];
    
    _leftLine = [[UIView alloc] init];
    [_leftLine setBackgroundColor:[[UtilsMacro colorWithHexString:@"DEDEDE"] colorWithAlphaComponent:0.8]];
    [_leftLine setHidden:YES];
    MASAttachKeys(_leftLine);
    [self addSubview:_leftLine];

    _rightLine = [[UIView alloc] init];
    [_rightLine setBackgroundColor:[[UtilsMacro colorWithHexString:@"DEDEDE"] colorWithAlphaComponent:0.8]];
    [_rightLine setHidden:YES];
    MASAttachKeys(_rightLine);
    [self addSubview:_rightLine];
}

- (void)placeSubviews {
    [super placeSubviews];
    [self.stateLabel setHidden:YES];
    
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(10.0);
        make.bottom.mas_equalTo(-5.0);
    }];
    
    [_loadingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.stateLab.mas_top).mas_offset(-5.0);
        make.top.mas_equalTo(10.0);
        make.left.right.mas_equalTo(0.0);
    }];
    
    [_logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25.0);
        make.center.mas_equalTo(self);
    }];
    
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(50.0);
        make.right.mas_equalTo(self.logoImg.mas_left).mas_offset(-10.0);
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-50.0);
        make.left.mas_equalTo(self.logoImg.mas_right).mas_offset(10.0);
    }];
}

#pragma mark - 监听控件的刷新状态

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_dark]] placeholderImage:[UIImage imageNamed:@"header"]];
            [_loadingImg setHidden:NO];
            [_stateLab setHidden:NO];
            [_leftLine setHidden:YES];
            [_rightLine setHidden:YES];
            [_logoImg setHidden:YES];
            self.stateLab.text = @"点击加载";
        }
            break;
        case MJRefreshStatePulling:
        {
            [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_dark]] placeholderImage:[UIImage imageNamed:@"header"]];
            [_loadingImg setHidden:NO];
            [_stateLab setHidden:NO];
            [_leftLine setHidden:YES];
            [_rightLine setHidden:YES];
            [_logoImg setHidden:YES];
            self.stateLab.text = @"松开加载";
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_dark]] placeholderImage:_gifImg];
            [_loadingImg setHidden:NO];
            [_stateLab setHidden:NO];
            [_leftLine setHidden:YES];
            [_rightLine setHidden:YES];
            [_logoImg setHidden:YES];
            self.stateLab.text = @"加载中";
        }
            break;
        case MJRefreshStateNoMoreData:
        {
            [_loadingImg setHidden:YES];
            [_stateLab setHidden:YES];
            [_leftLine setHidden:NO];
            [_rightLine setHidden:NO];
            [_logoImg setHidden:NO];
        }
            break;
        default:
            break;
    }
}

@end
