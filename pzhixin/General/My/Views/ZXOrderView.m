//
//  ZXOrderView.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOrderView.h"
#import "ZXOrderCell.h"
#import "ZXOrderHeader.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXOrder.h"

@interface ZXOrderView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ZXOrderCellDelegate> {
    
}

@property (strong, nonatomic) NSMutableArray *orderList;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *isMine;

@property (strong, nonatomic) NSString *s_time;

@property (strong, nonatomic) NSString *e_time;

@property (assign, nonatomic) BOOL isLoaded;

@end

@implementation ZXOrderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = BG_COLOR;
    [self.orderTableView setDelegate:self];
    [self.orderTableView setDataSource:self];
    [self.orderTableView setBackgroundColor:BG_COLOR];
    self.orderTableView.emptyDataSetDelegate = self;
    self.orderTableView.emptyDataSetSource = self;
}

#pragma mark - Setter

- (void)setDefaultResult:(NSArray *)defaultResult {
    _defaultResult = defaultResult;
    _orderList = [[NSMutableArray alloc] init];
    NSArray *resultList;
    if ([UtilsMacro whetherIsEmptyWithObject:defaultResult]) {
        resultList = [[NSArray alloc] init];
        [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        resultList = [[NSArray alloc] initWithArray:defaultResult];
        if ([resultList count] < 20) {
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            _page++;
            self.orderTableView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
            [self.orderTableView.mj_footer setHidden:NO];
        }
    }
    _orderList = [[NSMutableArray alloc] initWithArray:resultList];
    
    [self.orderTableView reloadData];
    [self.orderTableView reloadEmptyDataSet];
    _isLoaded = YES;
}

- (void)setParatemers:(NSDictionary *)paratemers {
    _paratemers = paratemers;
    BOOL change = NO;
    if (![[_paratemers valueForKey:@"status"] isEqualToString:_status]) {
        change = YES;
        _status = [_paratemers valueForKey:@"status"];
    }
    if (![[_paratemers valueForKey:@"mine"] isEqualToString:_isMine]) {
        change = YES;
        _isMine = [_paratemers valueForKey:@"mine"];
    }
    if (![[_paratemers valueForKey:@"s_time"] isEqualToString:_s_time]) {
        change = YES;
        _s_time = [_paratemers valueForKey:@"s_time"];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[_paratemers valueForKey:@"e_time"]]) {
        _e_time = nil;
    } else {
        _e_time = [_paratemers valueForKey:@"e_time"];
    }
    if (!self.orderTableView.mj_header) {
        ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshOrderList)];
        [refreshHeader.stateLab setTextColor:COLOR_999999];
        [self.orderTableView setMj_header:refreshHeader];
    }
    if (change) {
        if (self.tag == [[_paratemers valueForKey:@"index"] integerValue]) {
            if (_isLoaded) {
                [self.orderTableView.mj_header beginRefreshing];
            }
        } else {
            [self.orderTableView.mj_header beginRefreshing];
        }
    }
}

- (void)setNotice:(ZXCommonNotice *)notice {
    _notice = notice;
}

#pragma mark - Private Methods

- (void)refreshOrderList {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXOrderListHelper sharedInstance] fetchOrderListWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andMine:_isMine andStatus:_status andS_time:_s_time andE_time:_e_time completion:^(ZXResponse * _Nonnull response) {
            if ([self.orderTableView.mj_header isRefreshing]) {
                [self.orderTableView.mj_header endRefreshing];
            }
            [ZXProgressHUD hideAllHUD];
            self.orderList = [[NSMutableArray alloc] init];
            ZXOrderList *orderList = [ZXOrderList yy_modelWithJSON:response.data];
            if ([UtilsMacro whetherIsEmptyWithObject:orderList.list]) {
                [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.orderList = [[NSMutableArray alloc] initWithArray:orderList.list];
                if ([self.orderList count] < orderList.pagesize) {
                    [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.page++;
                    self.orderTableView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
                    [self.orderTableView.mj_footer setHidden:NO];
                }
            }
            
            [self.orderTableView reloadData];
            [self.orderTableView reloadEmptyDataSet];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.orderTableView.mj_header isRefreshing]) {
                [self.orderTableView.mj_header endRefreshing];
            }
            if ([[response.data allKeys] count] <= 0) {
                [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if ([self.orderTableView.mj_header isRefreshing]) {
            [self.orderTableView.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreOrderList {
    _page++;
    [[ZXOrderListHelper sharedInstance] fetchOrderListWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andMine:_isMine andStatus:_status andS_time:_s_time andE_time:_e_time completion:^(ZXResponse * _Nonnull response) {
        if ([self.orderTableView.mj_footer isRefreshing]) {
            [self.orderTableView.mj_footer endRefreshing];
        }
        [ZXProgressHUD hideAllHUD];
        ZXOrderList *orderList = [ZXOrderList yy_modelWithJSON:response.data];
        NSArray *resultList;
        if ([UtilsMacro whetherIsEmptyWithObject:orderList.list]) {
            resultList = [[NSArray alloc] init];
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            resultList = [[NSArray alloc] initWithArray:orderList.list];
            if ([resultList count] < orderList.pagesize) {
                [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.page++;
                self.orderTableView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
                [self.orderTableView.mj_footer setHidden:NO];
            }
        }
        [self.orderList addObjectsFromArray:orderList.list];
        [self.orderTableView reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.orderTableView.mj_footer isRefreshing]) {
            [self.orderTableView.mj_footer endRefreshing];
        }
        if (response.status != 0) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
        }
        if ([[response.data allKeys] count] <= 0) {
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
        }
        return;
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_orderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 139.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_notice) {
            return 37.0;
        }
        return 0.0001;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_notice) {
            __weak typeof(self) weakSelf = self;
            ZXOrderHeader *orderHeader = [[ZXOrderHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 32.0)];
            [orderHeader.titleLab setText:[_notice txt]];
            orderHeader.zxOrderHeaderClick = ^{
                if (weakSelf.zxOrderViewHeaderClick) {
                    weakSelf.zxOrderViewHeaderClick();
                }
            };
            return orderHeader;
        }
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 5.0)];
    [footerView setBackgroundColor:BG_COLOR];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXOrderCell";
    ZXOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXOrderCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    ZXOrder *order = (ZXOrder *)[_orderList objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.cpBtn setTag:indexPath.row];
    [cell setDelegate:self];
    [cell setOrder:order];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderViewTableView:didSelectRowAtIndexPath:)]) {
        [self.delegate orderViewTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - ZXOrderCellDelegate

- (void)orderCellHandleTapCpBtnActionWithTag:(NSInteger)btnTag {
    ZXOrder *order = (ZXOrder *)[_orderList objectAtIndex:btnTag];
    [UtilsMacro generalPasteboardCopy:order.order_id];
    [ZXProgressHUD loadSucceedWithMsg:@"复制成功"];
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_order_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"还没有相关订单呢~";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100.0;
}

@end
