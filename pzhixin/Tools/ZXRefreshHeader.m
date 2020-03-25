//
//  ZXRefreshHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRefreshHeader.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Masonry/Masonry.h>

@interface ZXRefreshHeader ()

@property (strong, nonatomic) UIImage *gifImg;

@end

@implementation ZXRefreshHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare {
    [super prepare];
    
    self.mj_h = 65.0;
    
    _loadingImg = [[UIImageView alloc] init];
    [_loadingImg setContentMode:UIViewContentModeScaleAspectFit];
    [_loadingImg setClipsToBounds:YES];
    [self addSubview:_loadingImg];
    
    _stateLab = [[UILabel alloc] init];
    [_stateLab setTextColor:[UIColor whiteColor]];
    [_stateLab setTextAlignment:NSTextAlignmentCenter];
    [_stateLab setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:_stateLab];
    
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"header" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    _gifImg = [UIImage sd_imageWithGIFData:gifData];
    [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_dark]] placeholderImage:_gifImg];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0);
        make.bottom.mas_equalTo(-5.0);
        make.height.mas_equalTo(10.0);
    }];
    
    [_loadingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.stateLab.mas_top).mas_offset(-5.0);
        make.top.mas_equalTo(10.0);
        make.left.right.mas_equalTo(0.0);
    }];
    
    [self.stateLabel setHidden:YES];
    [self.lastUpdatedTimeLabel setHidden:YES];
}

- (void)setTopMargin:(CGFloat)topMargin {
    [_loadingImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.stateLab.mas_top).mas_offset(-5.0);
        make.top.mas_equalTo(10.0 + topMargin);
        make.left.right.mas_equalTo(0.0);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self layoutSubviews];
}

#pragma mark - Setter

- (void)setLight:(BOOL)light {
    _light = light;
    if (_light) {
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"header_white" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        _gifImg = [UIImage sd_imageWithGIFData:gifData];
        [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_light]] placeholderImage:_gifImg];
    } else {
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"header" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        _gifImg = [UIImage sd_imageWithGIFData:gifData];
        [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_dark]] placeholderImage:_gifImg];
    }
}

#pragma mark 监听scrollView的contentOffset改变

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
        {
            if (_light) {
                [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_light]] placeholderImage:[UIImage imageNamed:@"header_white"]];
            } else {
                [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_dark]] placeholderImage:[UIImage imageNamed:@"header"]];
            }
            if (oldState == MJRefreshStateRefreshing) {
                self.stateLab.text = @"刷新完成";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshFastAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.stateLab.text = @"下拉刷新";
                });
            } else {
                self.stateLab.text = @"下拉刷新";
            }
        }
            break;
        case MJRefreshStatePulling:
        {
            if (_light) {
                [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_light]] placeholderImage:[UIImage imageNamed:@"header_white"]];
            } else {
                [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] load_dark]] placeholderImage:[UIImage imageNamed:@"header"]];
            }
            self.stateLab.text = @"松开刷新";
        }
            break;
        case MJRefreshStateRefreshing:
        {
            if (_light) {
                [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_light]] placeholderImage:_gifImg];
            } else {
                [self.loadingImg sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading_dark]] placeholderImage:_gifImg];
            }
            self.stateLab.text = @"加载中";
        }
            break;
        default:
            break;
    }
}

@end
