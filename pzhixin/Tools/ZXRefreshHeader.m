//
//  ZXNewRefreshHeader.m
//  pzhixin
//
//  Created by zhixin on 2020/3/31.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXRefreshHeader.h"

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
}

#pragma mark -  setter

- (void)setTimeKey:(NSString *)timeKey {
    _timeKey = timeKey;
    [self setLastUpdatedTimeKey:_timeKey];
}

- (void)setLight:(BOOL)light {
    _light = light;
    if (_light) {
        [self.loadingView setColor:[UIColor whiteColor]];
        [self.lastUpdatedTimeLabel setTextColor:[UIColor whiteColor]];
        [self.stateLabel setTextColor:[UIColor whiteColor]];
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
            if (oldState == MJRefreshStateRefreshing) {
                self.stateLabel.text = @"刷新完成";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshFastAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.stateLabel.text = @"下拉刷新";
                });
            } else {
                self.stateLabel.text = @"下拉刷新";
            }
        }
            break;
        default:
            break;
    }
}

@end
