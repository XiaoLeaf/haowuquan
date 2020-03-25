//
//  ZXScoreViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreViewController.h"
#import <LTNavigationBar/UINavigationBar+Awesome.h>
#import "ZXScoreHeaderView.h"
#import "ZXWithDrawViewController.h"
#import "ZXScoreCell.h"
#import "ZXScoreSecHeaderView.h"
#import "ZXScoreDetailViewController.h"
#import <Masonry/Masonry.h>
#import "ZXScorePopView.h"
#import "ZXScoreIndex.h"

@interface ZXScoreViewController () <UITableViewDelegate, UITableViewDataSource, ZXScoreHeaderViewDelegate, UIScrollViewDelegate> {
    ZXScoreHeaderView *headerView;
    UITableView *scoreTableView;
}

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) ZXScorePopView *scoreToast;

@property (strong, nonatomic) ZXScoreIndex *scoreIndex;

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) UIImageView *bgImg;

@property (assign, nonatomic) CGPoint lastPoint;

@end

@implementation ZXScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:BG_COLOR];
    [self createSubviews];
    
    //推送时进入积分页面的碳层处理。
    if (_scorePop) {
        [UtilsMacro phoneShake];
        __weak typeof(self) weakSelf = self;
        self.scoreToast = [[ZXScorePopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.scoreToast setScorePop:_scorePop];
        self.scoreToast.zxScorePopViewClick = ^{
            [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.scoreToast.containerView endRemove:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.scoreToast setBackgroundColor:[UIColor clearColor]];
                [weakSelf.scoreToast removeFromSuperview];
                weakSelf.scoreToast = nil;
            });
        };
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.scoreToast];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:self.scoreToast.containerView endRemove:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ZXProgressHUD hideAllHUD];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [scoreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNav.mas_bottom);
        make.right.left.mas_equalTo(0.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(0.0);
        }
    }];
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

- (void)createSubviews {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_score_bg"]];
        [_bgImg setContentMode:UIViewContentModeScaleAspectFill];
        [_bgImg setClipsToBounds:YES];
        [self.view addSubview:_bgImg];
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(163.0 + STATUS_HEIGHT + NAVIGATION_HEIGHT);
        }];
    }
    
    _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_back_white"] title:@"积分" titleColor:[UIColor whiteColor] rightContent:nil leftDot:NO];
    [_customNav setBackgroundColor:[UIColor clearColor]];
    __weak typeof(self) weakSelf = self;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        if (![UtilsMacro whetherIsEmptyWithObject:weakSelf.scoreIndex.record.txt] && ![UtilsMacro whetherIsEmptyWithObject:weakSelf.scoreIndex.record.url_schema]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.scoreIndex.record.url_schema] andUserInfo:nil viewController:weakSelf];
        }
//        ZXScoreDetailViewController *scoreDetail = [[ZXScoreDetailViewController alloc] init];
//        [weakSelf.navigationController pushViewController:scoreDetail animated:YES];
    };
    [self.view addSubview:_customNav];
    
    scoreTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [scoreTableView setBackgroundColor:[UIColor clearColor]];
    [scoreTableView setDelegate:self];
    [scoreTableView setDataSource:self];
    [scoreTableView setShowsVerticalScrollIndicator:NO];
    [scoreTableView setShowsHorizontalScrollIndicator:NO];
    [scoreTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [scoreTableView setEstimatedRowHeight:64.0];
    [scoreTableView setRowHeight:UITableViewAutomaticDimension];
    [self.view addSubview:scoreTableView];
    
    _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshIndexStart)];
    [_refreshHeader setLight:YES];
    scoreTableView.mj_header = _refreshHeader;
    
    [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
        [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 163.0 + 65.0 + 10.0);
        }];
    }];
    
    [scoreTableView.mj_header beginRefreshing];
}

- (void)refreshIndexStart {
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXScoreIndexHelper sharedInstance] fetchScoreIndexCompletion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            if ([self->scoreTableView.mj_header isRefreshing]) {
                [self->scoreTableView.mj_header endRefreshing];
            }
//            NSLog(@"resonse.data:%@",response.data);
            self.scoreIndex = [ZXScoreIndex yy_modelWithJSON:response.data];
            [self->scoreTableView reloadData];
            if (![UtilsMacro whetherIsEmptyWithObject:self.scoreIndex.record.txt]) {
                [self.customNav setRightContent:self.scoreIndex.record.txt];
            }
        } error:^(ZXResponse * _Nonnull response) {
            if ([self->scoreTableView.mj_header isRefreshing]) {
                [self->scoreTableView.mj_header endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if ([self->scoreTableView.mj_header isRefreshing]) {
            [self->scoreTableView.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)showScorePopViewWithResponse:(ZXResponse *)response {
    [UtilsMacro phoneShake];
    ZXScorePop *subScorePop = [ZXScorePop yy_modelWithJSON:response.data];
    __weak typeof(self) weakSelf = self;
    self.scoreToast = [[ZXScorePopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.scoreToast setScorePop:subScorePop];
    self.scoreToast.zxScorePopViewClick = ^{
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.scoreToast.containerView endRemove:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.scoreToast setBackgroundColor:[UIColor clearColor]];
            [weakSelf.scoreToast removeFromSuperview];
            weakSelf.scoreToast = nil;
        });
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.scoreToast];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:self.scoreToast.containerView endRemove:NO];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + _scoreIndex.rules.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
            
        default:
        {
            ZXScoreRule *scoreRule = [_scoreIndex.rules objectAtIndex:section - 1];
            return [scoreRule.list count];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 267.0;
            break;
            
        default:
            return 40.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (!headerView) {
                headerView = [[ZXScoreHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 267.0)];
                [headerView setBackgroundColor:[UIColor clearColor]];
            }
            __weak typeof(self) weakSelf = self;
            headerView.zxScoreHeaderViewRuleClick = ^{
                if (![UtilsMacro whetherIsEmptyWithObject:weakSelf.scoreIndex.notice.url_schema]) {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.scoreIndex.notice.url_schema] andUserInfo:nil viewController:weakSelf];
                }
            };
            headerView.zxScoreHeaderViewNumBtnClick = ^{
                if (![UtilsMacro whetherIsEmptyWithObject:weakSelf.scoreIndex.adp.url_schema]) {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.scoreIndex.adp.url_schema] andUserInfo:nil viewController:weakSelf];
                }
            };
            [headerView setDelegate:self];
            [headerView setScoreIndex:_scoreIndex];
            scoreTableView.mj_header = _refreshHeader;
            return headerView;
        }
            break;
            
        default:
        {
            ZXScoreRule *scoreRule = [_scoreIndex.rules objectAtIndex:section - 1];
            ZXScoreSecHeaderView *secHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXScoreSecHeaderView class]) owner:nil options:nil] lastObject];
            [secHeaderView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 40.0)];
            [secHeaderView.nameLabel setText:scoreRule.name];
            [secHeaderView setBackgroundColor:BG_COLOR];
            return secHeaderView;
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(16.0, 0.0, SCREENWIDTH - 32.0, 10.0)];
    [footerView setBackgroundColor:BG_COLOR];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXScoreRule *scoreRule = [_scoreIndex.rules objectAtIndex:indexPath.section - 1];
    ZXScoreRuleItem *scoreRuleItem = [scoreRule.list objectAtIndex:indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"ZXScoreCell_%@", scoreRuleItem.item_id];
    ZXScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXScoreCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setScoreRuleItem:scoreRuleItem];
    cell.zxScoreCellBtnClick = ^{
        switch ([scoreRuleItem.status integerValue]) {
            case 1:
            {
                
            }
                break;
            case 2:
            {
                if ([UtilsMacro isCanReachableNetWork]) {
                    [ZXProgressHUD loadingNoMask];
                    [[ZXScoreReceiveHelper sharedInstance] fetchScoreReceiveWithId:scoreRuleItem.item_id completion:^(ZXResponse * _Nonnull response) {
                        [ZXProgressHUD hideAllHUD];
                        [self showScorePopViewWithResponse:response];
                        [self refreshIndexStart];
                    } error:^(ZXResponse * _Nonnull response) {
                        [ZXProgressHUD loadFailedWithMsg:response.info];
                        return;
                    }];
                } else {
                    [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                    return;
                }
            }
                break;
            case 3:
            {
                if (![UtilsMacro whetherIsEmptyWithObject:scoreRuleItem.url_schema]) {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, scoreRuleItem.url_schema] andUserInfo:nil viewController:self];
                }
            }
                break;
            case 4:
            {
                
            }
                break;
                
            default:
                break;
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXScoreRule *scoreRule = [_scoreIndex.rules objectAtIndex:indexPath.section - 1];
    if (indexPath.row == scoreRule.list.count - 1) {
        ZXScoreCell *scoreCell = (ZXScoreCell *)cell;
        CGFloat cornerRadius = 5.0f;
        scoreCell.mainView.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGRect bounds = CGRectInset(scoreCell.mainView.bounds, 0.0, 2.5);
        CGRect newBounds = CGRectMake(0.0, 0.0, SCREENWIDTH - 32.0, bounds.size.height);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:newBounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        layer.path = bezierPath.CGPath;
        layer.fillColor = UIColor.whiteColor.CGColor;
        [scoreCell.mainView.layer insertSublayer:layer atIndex:0];

    }
}

#pragma mark - ZXScoreHeaderViewDelegate

- (void)scoreHeaderViewHandleTapSignBtnAction {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXScoreSignHelper sharedInstance] fetchScoreSignCompletion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            [self showScorePopViewWithResponse:response];
            [self refreshIndexStart];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        return;
    }
    if (scrollView.contentOffset.y < _lastPoint.y) {
        if (scrollView.contentOffset.y == 0) {
            [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 163.0);
            }];
        } else {
            if (scrollView.contentOffset.y == -65.0) {
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 163.0 + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                    }];
                    [self.view layoutIfNeeded];
                }];
            } else {
                [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 163.0 + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                }];
            }
        }
    } else {
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            if (scrollView.contentOffset.y == 0) {
                [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 163.0);
                }];
            } else {
                [self.bgImg mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 163.0 + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                }];
            }
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastPoint = scrollView.contentOffset;
}

@end
