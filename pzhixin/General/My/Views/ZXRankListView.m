//
//  ZXRankListView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRankListView.h"
#import <Masonry/Masonry.h>
#import "ZXRankListCell.h"
#import "ZXRanking.h"

@interface ZXRankListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *rankListTable;

@property (strong, nonatomic) NSMutableArray *rankingList;

@property (assign, nonatomic) NSInteger page;

@end

@implementation ZXRankListView

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
        [self createSubviews];
    }
    return self;
}

#pragma mark - Setter

- (void)setDefaultResult:(NSArray *)defaultResult {
    _defaultResult = defaultResult;
    _page = 1;
    _rankingList = [[NSMutableArray alloc] initWithArray:defaultResult];
    if ([_rankingList count] >= 20) {
        ZXRefreshFooter *refresgFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRanking)];
        _rankListTable.mj_footer = refresgFooter;
    } else {
        _rankListTable.mj_footer = nil;
    }
    [_rankListTable reloadData];
}

- (void)setIsDefault:(BOOL)isDefault {
    _isDefault = isDefault;
    if (!isDefault) {
        [self.rankListTable.mj_header beginRefreshing];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_rankListTable) {
        _rankListTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_rankListTable setBackgroundColor:[UIColor whiteColor]];
        [_rankListTable setShowsVerticalScrollIndicator:NO];
        [_rankListTable setShowsHorizontalScrollIndicator:NO];
        [_rankListTable setDelegate:self];
        [_rankListTable setDataSource:self];
        [_rankListTable setEstimatedRowHeight:0.0];
        [_rankListTable setEstimatedSectionHeaderHeight:0.0];
        [_rankListTable setEstimatedSectionFooterHeight:0.0];
        [_rankListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_rankListTable];
        [_rankListTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
        ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshRanking)];
        [refreshHeader setTimeKey:[NSString stringWithFormat:@"ZXRankListView-%@",self.timeKey]];
//        [refreshHeader.stateLab setTextColor:COLOR_999999];
        [_rankListTable setMj_header:refreshHeader];
    }
}

- (void)refreshRanking {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXRankingHelper sharedInstance] fetchRankingWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andType:_type completion:^(ZXResponse * _Nonnull response) {
            if ([self.rankListTable.mj_header isRefreshing]) {
                [self.rankListTable.mj_header endRefreshing];
            }
            ZXRankingRes *rankingRes = [ZXRankingRes yy_modelWithJSON:response.data];
            self.rankingList = [[NSMutableArray alloc] initWithArray:rankingRes.list];
            if ([self.rankingList count] >= rankingRes.pagesize) {
                ZXRefreshFooter *refresgFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRanking)];
                self.rankListTable.mj_footer = refresgFooter;
            } else {
                self.rankListTable.mj_footer = nil;
            }
            [self.rankListTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.rankListTable.mj_header isRefreshing]) {
                [self.rankListTable.mj_header endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if ([self.rankListTable.mj_header isRefreshing]) {
            [self.rankListTable.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreRanking {
    _page++;
    [[ZXRankingHelper sharedInstance] fetchRankingWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andType:_type completion:^(ZXResponse * _Nonnull response) {
        if ([self.rankListTable.mj_footer isRefreshing]) {
            [self.rankListTable.mj_footer endRefreshing];
        }
        ZXRankingRes *rankingRes = [ZXRankingRes yy_modelWithJSON:response.data];
        if ([rankingRes.list count] <= 0) {
            [self.rankListTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.rankListTable.mj_footer resetNoMoreData];
            [self.rankingList addObjectsFromArray:rankingRes.list];
            [self.rankListTable reloadData];
        }
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.rankListTable.mj_footer isRefreshing]) {
            [self.rankListTable.mj_footer endRefreshing];
        }
        if (response.status != 200) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rankingList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXRankListCell";
    ZXRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXRankListCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXRanking *ranking = (ZXRanking *)[_rankingList objectAtIndex:indexPath.row];
    [cell setRanking:ranking];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + self.frame.size.height > _rankListTable.contentSize.height) {
        return;
    }
    if (self.zxRankListViewDidScroll) {
        self.zxRankListViewDidScroll(scrollView);
    }
}

@end
