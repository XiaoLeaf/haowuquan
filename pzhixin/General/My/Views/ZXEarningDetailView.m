//
//  ZXEarningDetailView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningDetailView.h"
#import "ZXEarningDetailCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXProfitListStausCell.h"
#import "ZXProfitListNoUserCell.h"

@interface ZXEarningDetailView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    
}

@property (strong, nonatomic) NSMutableArray *profitList;

@property (strong, nonatomic) ZXProfit *profit;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *isMine;

@property (strong, nonatomic) NSString *s_time;

@property (strong, nonatomic) NSString *e_time;

@property (assign, nonatomic) BOOL isLoaded;

@end

@implementation ZXEarningDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.detailTable setDelegate:self];
    [self.detailTable setDataSource:self];
    [self.detailTable setBackgroundColor:BG_COLOR];
    [self.detailTable setEstimatedRowHeight:100.0];
    [self.detailTable setRowHeight:UITableViewAutomaticDimension];
    [self.detailTable registerClass:[ZXEarningDetailCell class] forCellReuseIdentifier:@"ZXEarningDetailCell"];
    [self.detailTable registerClass:[ZXProfitListStausCell class] forCellReuseIdentifier:@"ZXProfitListStausCell"];
    [self.detailTable registerClass:[ZXProfitListNoUserCell class] forCellReuseIdentifier:@"ZXProfitListNoUserCell"];
    self.detailTable.emptyDataSetSource = self;
    self.detailTable.emptyDataSetDelegate = self;
}

#pragma mark - Setter

- (void)setDefaultResult:(NSDictionary *)defaultResult {
    _defaultResult = defaultResult;
    _profitList = [[NSMutableArray alloc] init];
    if ([UtilsMacro whetherIsEmptyWithObject:[defaultResult valueForKey:@"list"]]) {
        [self.detailTable.mj_footer endRefreshingWithNoMoreData];
    } else {
        if ([[defaultResult valueForKey:@"list"] count] < [[defaultResult valueForKey:@"pagesize"] integerValue]) {
            [self.detailTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            _page++;
            self.detailTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProfitList)];
            [self.detailTable.mj_footer setHidden:NO];
        }
    }
    _profit = [ZXProfit yy_modelWithDictionary:defaultResult];
    [_profitList addObjectsFromArray:_profit.list];
    [self.detailTable reloadData];
    [self.detailTable reloadEmptyDataSet];
    
    [self.totalLab setText:[NSString stringWithFormat:@"%@￥%@", _profit.profit_str, _profit.sum]];
    [self.monthBtn setTitle:_profit.date forState:UIControlStateNormal];
    [self.tipLab setText:_profit.account_str];
    _isLoaded = YES;
}

- (void)setParameters:(NSDictionary *)parameters {
    _parameters = parameters;
    BOOL change = NO;
    if (![[_parameters valueForKey:@"type"] isEqualToString:_type]) {
        change = YES;
        _type = [_parameters valueForKey:@"type"];
    }
    if (![[_parameters valueForKey:@"mine"] isEqualToString:_isMine]) {
        change = YES;
        _isMine = [_parameters valueForKey:@"mine"];
    }
    if (![[_parameters valueForKey:@"s_time"] isEqualToString:_s_time]) {
        change = YES;
        _s_time = [_parameters valueForKey:@"s_time"];
    }
    if (![UtilsMacro whetherIsEmptyWithObject:_s_time]) {
        [_monthBtn setTitle:[NSString stringWithFormat:@"%@月",[_s_time substringFromIndex:5]] forState:UIControlStateNormal];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[_parameters valueForKey:@"e_time"]]) {
        _e_time = nil;
    } else {
        _e_time = [_parameters valueForKey:@"e_time"];
    }
    if (!self.detailTable.mj_header) {
        ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshProfitList)];
        [refreshHeader setTimeKey:[NSString stringWithFormat:@"ZXEarningDetailView%zd",self.tag]];
//        [refreshHeader.stateLab setTextColor:COLOR_999999];
        [self.detailTable setMj_header:refreshHeader];
    }
    if (change) {
        if (self.tag == [[_parameters valueForKey:@"index"] integerValue]) {
            if (_isLoaded) {
                [self.detailTable.mj_header beginRefreshing];
            }
        } else {
            [self.detailTable.mj_header beginRefreshing];
        }
    }
}

#pragma mark - MJRefresh

- (void)refreshProfitList {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXProfitListHelper sharedInstance] fetchProfitListWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andMine:_isMine andType:_type andS_time:_s_time andE_time:_e_time completion:^(ZXResponse * _Nonnull response) {
            if ([self.detailTable.mj_header isRefreshing]) {
                [self.detailTable.mj_header endRefreshing];
            }
            [ZXProgressHUD hideAllHUD];
            self.profitList = [[NSMutableArray alloc] init];
            if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"list"]]) {
                [self.detailTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ([[response.data valueForKey:@"list"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                    [self.detailTable.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.page++;
                    self.detailTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProfitList)];
                    [self.detailTable.mj_footer setHidden:NO];
                }
            }
            self.profit = [ZXProfit yy_modelWithDictionary:response.data];
            [self.profitList addObjectsFromArray:self.profit.list];
            [self.detailTable reloadData];
            [self.detailTable reloadEmptyDataSet];
            
            [self.totalLab setText:[NSString stringWithFormat:@"%@￥%@", self.profit.profit_str, self.profit.sum]];
            [self.monthBtn setTitle:self.profit.date forState:UIControlStateNormal];
            [self.tipLab setText:self.profit.account_str];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.detailTable.mj_header isRefreshing]) {
                [self.detailTable.mj_header endRefreshing];
            }
            if (response.status != 0) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
            }
            if ([[response.data allKeys] count] <= 0) {
                [self.detailTable.mj_footer endRefreshingWithNoMoreData];
            }
            [self.detailTable reloadData];
            [self.detailTable reloadEmptyDataSet];
            return;
        }];
    } else {
        if ([self.detailTable.mj_header isRefreshing]) {
            [self.detailTable.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreProfitList {
    _page++;
    [[ZXProfitListHelper sharedInstance] fetchProfitListWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andMine:_isMine andType:_type andS_time:_s_time andE_time:_e_time completion:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD hideAllHUD];
        if ([self.detailTable.mj_footer isRefreshing]) {
            [self.detailTable.mj_footer endRefreshing];
        }
        if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"list"]]) {
            [self.detailTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            if ([[response.data valueForKey:@"list"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                [self.detailTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.page++;
                self.detailTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProfitList)];
                [self.detailTable.mj_footer setHidden:NO];
            }
        }
        self.profit = [ZXProfit yy_modelWithDictionary:response.data];
        [self.profitList addObjectsFromArray:self.profit.list];
        [self.detailTable reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.detailTable.mj_footer isRefreshing]) {
            [self.detailTable.mj_footer endRefreshing];
        }
        if (response.status != 0) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
        }
        if ([[response.data allKeys] count] <= 0) {
            [self.detailTable.mj_footer endRefreshingWithNoMoreData];
        }
        return;
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_profitList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 5.0)];
    [headerView setBackgroundColor:BG_COLOR];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [_profitList count] - 1) {
        return 5.0;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == [_profitList count] - 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 5.0)];
        [footerView setBackgroundColor:BG_COLOR];
        return footerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXProfitList *profitList = (ZXProfitList *)[_profitList objectAtIndex:indexPath.section];
    if ([UtilsMacro whetherIsEmptyWithObject:profitList.user.icon] && [UtilsMacro whetherIsEmptyWithObject:profitList.status_str]) {
        static NSString *identifier = @"ZXProfitListNoUserCell";
        ZXProfitListNoUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];;
        [cell setProfitList:profitList];
        return cell;
    } else if ([UtilsMacro whetherIsEmptyWithObject:profitList.user.icon]) {
        static NSString *identifier = @"ZXProfitListStausCell";
        ZXProfitListStausCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];;
        [cell setProfitList:profitList];
        return cell;
    } else {
        static NSString *identifier = @"ZXEarningDetailCell";
        ZXEarningDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];;
        [cell setProfitList:profitList];
        return cell;
    }
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_general_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"还没有相关记录呢~";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100.0;
}

#pragma mark - Button Method

- (IBAction)handleTapMonthBtnAction:(id)sender {
    if (self.zxEarningDetailViewMonthBtnClick) {
        self.zxEarningDetailViewMonthBtnClick();
    }
}

@end
