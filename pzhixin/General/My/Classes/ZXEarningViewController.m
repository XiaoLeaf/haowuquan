//
//  ZXEarningViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningViewController.h"
#import "ZXEarningDetailVC.h"
#import "ZXEarningCell.h"
#import "ZXEarningHeaderView.h"
#import <Masonry/Masonry.h>
#import "ZXWithDrawViewController.h"
#import "ZXEarningFooterView.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXProfitHome.h"
#import "ZXNewEarningCell.h"
#import "ZXEarnHeaderView.h"

@interface ZXEarningViewController () <UITableViewDelegate, UITableViewDataSource, ZXEarningHeaderViewDelegate, UIScrollViewDelegate> {
    NSArray *titleList;
    UITableView *earningTableView;
    ZXEarningHeaderView *headerView;
    CGFloat alpha;
}

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) ZXEarningFooterView *footerView;

@property (strong, nonatomic) ZXProfitHome *profitHome;

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) UIImageView *bgImg;

@property (assign, nonatomic) BOOL isFirst;

@property (assign, nonatomic) CGPoint lastPoint;

@end

@implementation ZXEarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    alpha = 0.0;
//    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:BG_COLOR];
//
    titleList = @[@"今日", @"昨日", @"本月", @"上月"];
    [self createSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [headerView.balanceLab setText:[NSString stringWithFormat:@"账户余额(元):%@",[[[[ZXMyHelper sharedInstance] userInfo] stat] money]]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [earningTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNav.mas_bottom);
        make.left.right.mas_equalTo(0.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.mas_equalTo(0.0);
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (void)refreshProfit {
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXProfitHelper sharedInstance] fetchProfitWithCompletion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            if ([self->earningTableView.mj_header isRefreshing]) {
                [self->earningTableView.mj_header endRefreshing];;
            }
//            NSLog(@"response:%@",response.data);
            self.profitHome = [ZXProfitHome yy_modelWithDictionary:response.data];
            ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
            if ([UtilsMacro whetherIsEmptyWithObject:self.profitHome.money]) {
                [[userInfo stat] setMoney:@"0.00"];
            } else {
                [[userInfo stat] setMoney:self.profitHome.money];
            }
            [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
            [self->earningTableView reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self->earningTableView.mj_header isRefreshing]) {
                [self->earningTableView.mj_header endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if ([self->earningTableView.mj_header isRefreshing]) {
            [self->earningTableView.mj_header endRefreshing];;
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)createSubviews {
    _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_earning_bg"]];
    [_bgImg setContentMode:UIViewContentModeScaleAspectFill];
    [_bgImg setClipsToBounds:YES];
    [self.view addSubview:_bgImg];
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0);
    }];
    
    _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_back_white"] title:@"我的收益" titleColor:[UIColor whiteColor] rightContent:@"收益明细" leftDot:NO];
    [_customNav setBackgroundColor:[UIColor clearColor]];
    __weak typeof(self) weakSelf = self;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        ZXEarningDetailVC *earningDetail = [[ZXEarningDetailVC alloc] init];
        [weakSelf.navigationController pushViewController:earningDetail animated:YES];
    };
    [self.view addSubview:_customNav];
    
    if (!earningTableView) {
        earningTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [earningTableView setDelegate:self];
        [earningTableView setDataSource:self];
        [earningTableView setShowsVerticalScrollIndicator:NO];
        [earningTableView setShowsHorizontalScrollIndicator:NO];
        [earningTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [earningTableView setBackgroundColor:[UIColor clearColor]];
        [earningTableView setEstimatedRowHeight:0.0];
        [earningTableView setEstimatedSectionHeaderHeight:0.0];
        [earningTableView setEstimatedSectionFooterHeight:0.0];
        [self.view addSubview:earningTableView];
        
        _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshProfit)];
        [_refreshHeader setLight:YES];
        [_refreshHeader setTimeKey:@"ZXEarningViewController"];
        [earningTableView setMj_header:_refreshHeader];
        
        _isFirst = YES;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0 + 65.0 + 10.0);
            }];
        }];
        [_refreshHeader beginRefreshing];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + _profitHome.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        ZXProfitItem *profitItem = (ZXProfitItem *)[_profitHome.list objectAtIndex:section - 1];
        return (NSInteger)ceil(profitItem.items.count/3.0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 130.0;
    } else {
        ZXProfitItem *profitItem = (ZXProfitItem *)[_profitHome.list objectAtIndex:section - 1];
        if ([UtilsMacro whetherIsEmptyWithObject:profitItem.title]) {
            return 0.0001;
        } else {
            return 42.0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
//        if (!_profitHome) {
//            return nil;
//        }
        if (!headerView) {
            headerView = [[ZXEarningHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 130.0)];
            [headerView setDelegate:self];
            [headerView setBackgroundColor:[UIColor clearColor]];
        }
        if ([UtilsMacro whetherIsEmptyWithObject:_profitHome.profit_total]) {
            [headerView.countLab setText:@"0.00"];
        } else {
            [headerView.countLab countFromCurrentValueTo:[_profitHome.profit_total floatValue]];
        }
        ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
        [headerView.balanceLab setText:[NSString stringWithFormat:@"账户余额(元):%@",[[userInfo stat] money]]];
        return headerView;
    } else {
        ZXProfitItem *profitItem = (ZXProfitItem *)[_profitHome.list objectAtIndex:section - 1];
        if ([UtilsMacro whetherIsEmptyWithObject:profitItem.title]) {
            return nil;
        } else {
            ZXEarnHeaderView *subHeader = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXEarnHeaderView class]) owner:nil options:nil] lastObject];
            [subHeader setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 42.0)];
            [subHeader.nameLab setText:profitItem.title];
            return subHeader;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    } else if (section == _profitHome.list.count) {
        if ([UtilsMacro whetherIsEmptyWithObject:_profitHome.notice.txt]) {
            return 0.0001;
        }
        return 60.0;
    } else {
        return 10.0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == _profitHome.list.count) {
        if ([UtilsMacro whetherIsEmptyWithObject:_profitHome.notice.txt]) {
            return nil;
        }
        if (!_footerView) {
            _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXEarningFooterView class]) owner:nil options:nil] lastObject];
        }
        if (![UtilsMacro whetherIsEmptyWithObject:self.profitHome.notice.txt]) {
            [_footerView.issueBtn setTitle:_profitHome.notice.txt forState:UIControlStateNormal];
            [_footerView.issueBtn setImage:[UIImage imageNamed:@"ic_earn_issue"] forState:UIControlStateNormal];
        } else {
            [_footerView.issueBtn setTitle:@"" forState:UIControlStateNormal];
            [_footerView.issueBtn setImage:[UIImage new] forState:UIControlStateNormal];
        }
        [_footerView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 60.0)];
        __weak typeof(self) weakSelf = self;
        _footerView.zxEarningFooterBtnClick = ^{
            if ([UtilsMacro whetherIsEmptyWithObject:weakSelf.profitHome.notice.url_schema]) {
                return;
            }
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.profitHome.notice.url_schema] andUserInfo:nil viewController:weakSelf];
        };
        return _footerView;
    } else {
        UIView *subFooter = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
        [subFooter setBackgroundColor:BG_COLOR];
        return subFooter;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXNewEarningCell";
    ZXNewEarningCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXNewEarningCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXProfitItem *profitItem = (ZXProfitItem *)[_profitHome.list objectAtIndex:indexPath.section - 1];
    if (profitItem.items.count >= (indexPath.row + 1) * 3) {
        [cell setItemList:[profitItem.items subarrayWithRange:NSMakeRange(indexPath.row * 3, 3)]];
    } else {
        [cell setItemList:[profitItem.items subarrayWithRange:NSMakeRange(indexPath.row * 3, profitItem.items.count - indexPath.row * 3)]];
    }
    cell.zxNewEarningCellItemClick = ^(ZXProfitSubItem * _Nonnull subItem) {
        if (![UtilsMacro whetherIsEmptyWithObject:subItem.url_schema]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, subItem.url_schema] andUserInfo:nil viewController:self];
        }
    };
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        return;
    }
    if (scrollView.contentOffset.y < _lastPoint.y) {
        if (scrollView.contentOffset.y == 0) {
            [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0);
            }];
        } else {
            if (scrollView.contentOffset.y == -65.0) {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0 + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                    }];
                    [self.view layoutIfNeeded];
                }];
            } else {
                [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0 + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                }];
            }
        }
    } else {
        NSTimeInterval timeInterval;
        if (_isFirst) {
            _isFirst = NO;
            timeInterval = MJRefreshFastAnimationDuration;
        } else {
            timeInterval = MJRefreshSlowAnimationDuration;
        }
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            if (scrollView.contentOffset.y == 0) {
                [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0);
                }];
            } else {
                [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 130.0 + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                }];
            }
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastPoint = scrollView.contentOffset;
}

#pragma mark - ZXEarningHeaderViewDelegate

- (void)earningHeaderViewHandleTapWithdrawBtnAction {
    __weak typeof(self) weakSelf = self;
    ZXWithDrawViewController *withdraw = [[ZXWithDrawViewController alloc] init];
    withdraw.zxBalanceChangeBlock = ^{
        [weakSelf refreshProfit];
    };
    [self.navigationController pushViewController:withdraw animated:YES];
}

@end
