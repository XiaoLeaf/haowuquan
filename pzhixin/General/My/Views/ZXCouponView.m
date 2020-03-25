//
//  ZXCouponView.m
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCouponView.h"
#import <MJRefresh/MJRefresh.h>

@interface ZXCouponView () <UITableViewDelegate, UITableViewDataSource, ZXCouponCellDelegate> {
    
}

@end

@implementation ZXCouponView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.couponTable setDelegate:self];
    [self.couponTable setDataSource:self];
    [self.couponTable setEstimatedRowHeight:110.0];
    [self.couponTable setRowHeight:UITableViewAutomaticDimension];
    self.couponTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCouponInfo)];
}

#pragma mark - MJRefresh

- (void)refreshCouponInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponViewRefreshCouponInfo:)]) {
        [self.delegate couponViewRefreshCouponInfo:self];
    }
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self;
}

- (void)listDidAppear {
    
}

- (void)listDidDisappear {
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXCouponCell";
    ZXCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZXCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponViewTableView:didSelectRowAtIndexPath:)]) {
        [self.delegate couponViewTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - ZXCouponCellDelegate

- (void)couponCellHandleTapDetailBtnAction:(ZXCouponCell *)cell {
    [self.couponTable beginUpdates];
    [self.couponTable endUpdates];
    if (self.delegate && [self.delegate respondsToSelector:@selector(couponViewCellHandleTapDetailBtnAction:)]) {
        [self.delegate couponViewCellHandleTapDetailBtnAction:cell];
    }
}

@end
