//
//  ZXCashDetailVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashDetailVC.h"
#import "ZXCashDetailCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXCashList.h"

@interface ZXCashDetailVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSMutableArray *cashList;

@end

@implementation ZXCashDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    [self.detailTable setBackgroundColor:BG_COLOR];
    [self setTitle:@"提现明细" font:TITLE_FONT color:HOME_TITLE_COLOR];
    // Do any additional setup after loading the view from its nib.
    
    [self.detailTable setEstimatedRowHeight:100.0];
    [self.detailTable setRowHeight:UITableViewAutomaticDimension];
    [self.detailTable registerClass:[ZXCashDetailCell class] forCellReuseIdentifier:@"ZXCashDetailCell"];
    [self.detailTable setEmptyDataSetSource:self];
    [self.detailTable setEmptyDataSetDelegate:self];
    
    ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCashList)];
    [refreshHeader setTimeKey:@"ZXCashDetailVC"];
//    [refreshHeader.stateLab setTextColor:COLOR_999999];
    self.detailTable.mj_header = refreshHeader;
    [self refreshCashList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MJRefresh

- (void)refreshCashList {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXCashListHelper sharedInstance] fetchCashListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(ZXResponse * _Nonnull response) {
            if ([self.detailTable.mj_header isRefreshing]) {
                [self.detailTable.mj_header endRefreshing];
            }
            [ZXProgressHUD hideAllHUD];
            self.cashList = [[NSMutableArray alloc] init];
            NSArray *resultList;
            if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"list"]]) {
                resultList = [[NSArray alloc] init];
                [self.detailTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"list"]];
                if ([resultList count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                    [self.detailTable.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.page++;
                    self.detailTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCashList)];
                    [self.detailTable.mj_footer setHidden:NO];
                }
            }
            for (int i = 0; i < [resultList count]; i++) {
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                ZXCashList *cashList = [ZXCashList yy_modelWithDictionary:dict];
                [self.cashList addObject:cashList];
            }
            
            [self.detailTable reloadData];
            [self.detailTable reloadEmptyDataSet];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.detailTable.mj_header isRefreshing]) {
                [self.detailTable.mj_header endRefreshing];
            }
            self.cashList = [[NSMutableArray alloc] init];
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

- (void)loadMoreCashList {
    _page++;
    [[ZXCashListHelper sharedInstance] fetchCashListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(ZXResponse * _Nonnull response) {
        if ([self.detailTable.mj_footer isRefreshing]) {
            [self.detailTable.mj_footer endRefreshing];
        }
        NSArray *resultList;
        if (![[response.data valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
            resultList = [[NSArray alloc] init];
            [self.detailTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"list"]]) {
                resultList = [[NSArray alloc] init];
                [self.detailTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"list"]];
                if ([resultList count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                    [self.detailTable.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.page++;
                    self.detailTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCashList)];
                    [self.detailTable.mj_footer setHidden:NO];
                }
            }
            for (int i = 0; i < [resultList count]; i++) {
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                ZXCashList *cashList = [ZXCashList yy_modelWithDictionary:dict];
                [self.cashList addObject:cashList];
            }
        }
        
        [self.detailTable reloadData];
        [self.detailTable reloadEmptyDataSet];
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

#pragma mark - Private Methods

- (void)revocationCashWitCashList:(ZXCashList *)cashList {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXCashCancelHelper sharedInstance] fetchCashCancelWithId:cashList.cash_id completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self refreshCashList];
                if (self.zxCashDetailVCBlcok) {
                    self.zxCashDetailVCBlcok();
                }
            });
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cashList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    static NSString *identifier = @"ZXCashDetailCell";
    ZXCashDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXCashList *cashList = (ZXCashList *)[_cashList objectAtIndex:indexPath.row];
    [cell setCashList:cashList];
    __weak typeof(self) weakSelf = self;
    cell.zxCashDetailCellCancelClick = ^(NSInteger btnTag) {
        NSArray *actionList = @[@"确认"];
        [weakSelf.navigationController presentViewController:[UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"是否确认撤销当前提现？" style:UIAlertControllerStyleAlert andAction:actionList alertActionClicked:^(NSInteger actionTag) {
            switch (actionTag) {
                case 0:
                {
                    [weakSelf revocationCashWitCashList:cashList];
                }
                    break;

                default:
                    break;
            }
        }] animated:YES completion:nil];
    };
    return cell;
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

@end
