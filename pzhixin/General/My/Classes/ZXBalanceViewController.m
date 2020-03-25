//
//  ZXBalanceViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXBalanceViewController.h"
#import "ZXBalanceCell.h"
#import "ZXBalanceHeaderView.h"
#import "ZXBalanceSecHeaderView.h"
#import "ZXWithDrawViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXUdMoney.h"

@interface ZXBalanceViewController () <UITableViewDelegate, UITableViewDataSource, ZXBalanceHeaderViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SGAdvertScrollViewDelegate> {
    ZXBalanceHeaderView *headerView;
}

@property (strong, nonatomic) ZXPickerManager *pickManager;

@property (strong, nonatomic) ZXBalanceSecHeaderView *secHeaderView;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSString *typeId;

@property (strong, nonatomic) NSString *month;

@property (strong, nonatomic) NSString *s_time;

@property (strong, nonatomic) NSString *typeStr;

@property (strong, nonatomic) NSMutableArray *udMoneyList;

@property (strong, nonatomic) NSMutableArray *titlesList;

@property (strong, nonatomic) NSMutableArray *signImgList;

@property (strong, nonatomic) NSMutableArray *noticeList;

@property (strong, nonatomic) NSMutableArray *typeStrList;

@property (strong, nonatomic) NSMutableArray *typeIdList;

@property (strong, nonatomic) NSMutableArray *timeList;

@property (assign, nonatomic) BOOL isLoaded;

@end

@implementation ZXBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.topView setAlpha:0.0];
    _typeId = @"0";
    _s_time = @"";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.topView setBackgroundColor:BG_COLOR];
    [self.balanceTableView setBackgroundColor:BG_COLOR];
    [self.balanceTableView setEstimatedRowHeight:100.0];
    [self.balanceTableView setRowHeight:UITableViewAutomaticDimension];
    [self.balanceTableView registerClass:[ZXBalanceCell class] forCellReuseIdentifier:@"ZXBalanceCell"];
    [self setTitle:@"余额" font:TITLE_FONT color:HOME_TITLE_COLOR];
    
    [self.balanceScroll setTitleColor:THEME_COLOR];
    [self.balanceScroll setDelegate:self];
    [self createPickManager];
    
    [self.balanceTableView setEmptyDataSetSource:self];
    [self.balanceTableView setEmptyDataSetDelegate:self];
    
    ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshUdMoney)];
    [refreshHeader.stateLab setTextColor:COLOR_999999];
    [self.balanceTableView setMj_header:refreshHeader];
    [self.balanceTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    if (![self.balanceTableView.mj_header isRefreshing]) {
//        [self refreshUdMoney];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)createPickManager {
    if (!_pickManager) {
        _pickManager = [[ZXPickerManager alloc] init];
        [_pickManager setProvidesPresentationContextTransitionStyle:YES];
        [_pickManager setDefinesPresentationContext:YES];
        [_pickManager setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
}

- (void)refreshUdMoney {
    if ([UtilsMacro isCanReachableNetWork]) {
//        [ZXProgressHUD loading];
        _page = 1;
        [[ZXUdMoneyHelper sharedInstance] fetchMoneyWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andType:_typeId andS_time:_s_time andE_time:nil completion:^(ZXResponse * _Nonnull response) {
//            NSLog(@"response:%@",response.data);
            [ZXProgressHUD hideAllHUD];
            if ([self.balanceTableView.mj_header isRefreshing]) {
                [self.balanceTableView.mj_header endRefreshing];
            }
            self.udMoneyList = [[NSMutableArray alloc] init];
            NSDictionary *resuleDict = [[NSDictionary alloc] initWithDictionary:response.data];
            if ([[resuleDict valueForKey:@"list"] count] < 20) {
                [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if (!self.balanceTableView.mj_footer) {
                    self.balanceTableView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUdMoneyList)];
                } else {
                    [self.balanceTableView.mj_footer resetNoMoreData];
                }
            }
            
            //同步本地的用户余额信息
            ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
            if ([UtilsMacro whetherIsEmptyWithObject:[resuleDict valueForKey:@"money"]]) {
                [[userInfo stat] setMoney:@"0.00"];
            } else {
                [[userInfo stat] setMoney:[NSString stringWithFormat:@"%@",[resuleDict valueForKey:@"money"]]];
            }
            [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
            
            //赋值
            [self->headerView.balanceLabel setText:[[[[ZXMyHelper sharedInstance] userInfo] stat] money]];
            [self->headerView.balanceLabel countFromCurrentValueTo:[[[[[ZXMyHelper sharedInstance] userInfo] stat] money] floatValue]];
            
            if ([UtilsMacro whetherIsEmptyWithObject:[resuleDict valueForKey:@"cash_ed"]]) {
                [self->headerView.totalLabel setText:@"0.00"];
            } else {
                [self->headerView.totalLabel setText:[NSString stringWithFormat:@"%@",[resuleDict valueForKey:@"cash_ed"]]];
            }
            if ([UtilsMacro whetherIsEmptyWithObject:[resuleDict valueForKey:@"cash_ing"]]) {
                [self->headerView.alreadyLabel setText:@"0.00"];
            } else {
                [self->headerView.alreadyLabel setText:[NSString stringWithFormat:@"%@",[resuleDict valueForKey:@"cash_ing"]]];
            }
            if ([UtilsMacro whetherIsEmptyWithObject:[resuleDict valueForKey:@"profit_total"]]) {
                [self->headerView.notLabel setText:@"0.00"];
            } else {
                [self->headerView.notLabel setText:[NSString stringWithFormat:@"%@",[resuleDict valueForKey:@"profit_total"]]];
            }
            
            self.timeList = [[NSMutableArray alloc] init];
            if (![UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"date_arr"]]) {
                NSDictionary *dateDict = [response.data valueForKey:@"date_arr"];
                NSMutableArray *yearList = [[NSMutableArray alloc] initWithArray:[dateDict allKeys]];
                for (int i = 0; i < [yearList count]; i++) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setValue:[yearList objectAtIndex:i] forKey:@"year"];
                    [dict setValue:[dateDict valueForKey:[yearList objectAtIndex:i]] forKey:@"month"];
                    [self.timeList addObject:dict];
                }
            }
            if (!self.isLoaded) {
                [self.pickManager setDataSource:self.timeList];
            }
            self.isLoaded = YES;
            
            self.titlesList = [[NSMutableArray alloc] init];
            self.signImgList = [[NSMutableArray alloc] init];
            self.noticeList = [[NSMutableArray alloc] init];
            NSArray *noticeResult = [[NSArray alloc] initWithArray:[resuleDict valueForKey:@"notice"]];
            if ([noticeResult count] <= 0) {
                self.topHeight.constant = 0.0;
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.topView setAlpha:1.0];
                    self.topHeight.constant = 35.0;
                }];
                for (int i = 0 ; i < [noticeResult count]; i++) {
                    ZXCommonNotice *notice = [ZXCommonNotice yy_modelWithJSON:[noticeResult objectAtIndex:i]];
                    [self.titlesList addObject:notice.txt];
                    [self.signImgList addObject:@"ic_balance_horn"];
                    [self.noticeList addObject:notice];
                }
                [self.balanceScroll setTitles:self.titlesList];
                [self.balanceScroll setSignImages:self.signImgList];
            }
            
            self.typeStrList = [[NSMutableArray alloc] init];
            self.typeIdList = [[NSMutableArray alloc] init];
            NSArray *typeResult = [[NSArray alloc] initWithArray:[resuleDict valueForKey:@"type_arr"]];
            for (int i = 0; i < [typeResult count]; i ++) {
                NSDictionary *typeDict = [typeResult objectAtIndex:i];
                [self.typeStrList addObject:[typeDict valueForKey:@"name"]];
                [self.typeIdList addObject:[typeDict valueForKey:@"id"]];
            }
            if (!self.typeId) {
                self.typeId = [self.typeStrList objectAtIndex:0];
            }
            if (!self.typeStr) {
                self.typeStr = [self.typeStrList objectAtIndex:0];
            }
            
            NSArray *resultList;
            if (![[resuleDict valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
                resultList = [[NSArray alloc] init];
            } else {
                resultList = [[NSArray alloc] initWithArray:[resuleDict valueForKey:@"list"]];
            }
            for (int i = 0; i < [resultList count]; i++) {
                ZXUdMoney *udMoney = [ZXUdMoney yy_modelWithDictionary:[resultList objectAtIndex:i]];
                [self.udMoneyList addObject:udMoney];
            }
            
            [self.balanceTableView reloadData];
            [self.balanceTableView reloadEmptyDataSet];
            if ([self.udMoneyList count] <= 0) {
                [self.balanceTableView setMj_footer:nil];
            }
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.balanceTableView.mj_header isRefreshing]) {
                [self.balanceTableView.mj_header endRefreshing];
            }
            self.udMoneyList = [[NSMutableArray alloc] init];
            if (response.status != 0) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
            }
            if ([[response.data allKeys] count] <= 0) {
                [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.balanceTableView reloadData];
            return;
        }];
    } else {
        if ([self.balanceTableView.mj_header isRefreshing]) {
            [self.balanceTableView.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreUdMoneyList {
    _page ++;
    [[ZXUdMoneyHelper sharedInstance] fetchMoneyWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andType:_typeId andS_time:_s_time andE_time:nil completion:^(ZXResponse * _Nonnull response) {
        if ([self.balanceTableView.mj_footer isRefreshing]) {
            [self.balanceTableView.mj_footer endRefreshing];
        }
        NSDictionary *resuleDict = [[NSDictionary alloc] initWithDictionary:response.data];
        NSArray *resultList;
        if (![[resuleDict valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
            resultList = [[NSArray alloc] init];
            [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            if ([UtilsMacro whetherIsEmptyWithObject:[resuleDict valueForKey:@"list"]]) {
                resultList = [[NSArray alloc] init];
                [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                resultList = [[NSArray alloc] initWithArray:[resuleDict valueForKey:@"list"]];
            }
        }
        
        if ([resultList count] <= 0) {
            [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        for (int i = 0; i < [resultList count]; i++) {
            ZXUdMoney *udMoney = [ZXUdMoney yy_modelWithDictionary:[resultList objectAtIndex:i]];
            [self.udMoneyList addObject:udMoney];
        }
        [self.balanceTableView reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.balanceTableView.mj_footer isRefreshing]) {
            [self.balanceTableView.mj_footer endRefreshing];
        }
        if (response.status != 0) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
        }
        if ([[response.data allKeys] count] <= 0) {
            [self.balanceTableView.mj_footer endRefreshingWithNoMoreData];
        }
        return;
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return [_udMoneyList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 180.0;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.001;
    }
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!headerView) {
            headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXBalanceHeaderView class]) owner:nil options:nil] lastObject];
            [headerView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 180.0)];
        }
        [headerView setDelegate:self];
        return headerView;
    }
    if (!_secHeaderView) {
        _secHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXBalanceSecHeaderView class]) owner:nil options:nil] lastObject];
        [_secHeaderView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 40.0)];
    }
    [_secHeaderView.timeBtn setTitle:_s_time forState:UIControlStateNormal];
    [_secHeaderView.typeBtn setTitle:_typeStr forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    _secHeaderView.zxBalanceSecHeaderBtnClick = ^(NSInteger btnTag) {
        switch (btnTag) {
            case 0:
            {
                [weakSelf.navigationController presentViewController:[UtilsMacro zxAlertControllerWithTitle:nil andMessage:nil style:UIAlertControllerStyleActionSheet andAction:weakSelf.typeStrList alertActionClicked:^(NSInteger actionTag) {
                    weakSelf.typeStr = [weakSelf.typeStrList objectAtIndex:actionTag];
                    weakSelf.typeId = [weakSelf.typeIdList objectAtIndex:actionTag];
//                    [weakSelf refreshUdMoney];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.balanceTableView.contentOffset.y > 0) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            [weakSelf.balanceTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        }
                    });
                    [weakSelf.balanceTableView.mj_header beginRefreshing];
                }] animated:YES completion:^{
                    
                }];
            }
                break;
            case 1:
            {
                weakSelf.pickManager.zxPickManagerBlock = ^(NSString * _Nonnull yearStr, NSString * _Nonnull monthStr) {
                    weakSelf.s_time = [NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
//                    [weakSelf refreshUdMoney];
                    if (weakSelf.balanceTableView.contentOffset.y > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            [weakSelf.balanceTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        });
                    }
                    [weakSelf.balanceTableView.mj_header beginRefreshing];
                };
                [weakSelf.navigationController presentViewController:weakSelf.pickManager animated:YES completion:^{
                }];
            }
                break;
                
            default:
                break;
        }
    };
    return _secHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 5.0)];
    [footerView setBackgroundColor:BG_COLOR];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXBalanceCell";
    ZXBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXUdMoney *udMoney = (ZXUdMoney *)[_udMoneyList objectAtIndex:indexPath.row];
    [cell setUdMoney:udMoney];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_general_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"还有没有任何记录呢~";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 80.0;
}

#pragma mark - ZXBalanceHeaderViewDelegate

- (void)balanceHeaderViewHandleTapWithDrawBtnAction {
    __weak typeof(self) weakSelf = self;
    ZXWithDrawViewController *withDraw = [[ZXWithDrawViewController alloc] init];
    withDraw.zxBalanceChangeBlock = ^{
        [weakSelf refreshUdMoney];
    };
    [self.navigationController pushViewController:withDraw animated:YES];
}

#pragma mark - SGAdvertScrollViewDelegate

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    ZXCommonNotice *notice = (ZXCommonNotice *)[_noticeList objectAtIndex:index];
    if ([UtilsMacro whetherIsEmptyWithObject:notice.url_schema]) {
        return;
    }
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, notice.url_schema] andUserInfo:nil viewController:self];
}

@end
