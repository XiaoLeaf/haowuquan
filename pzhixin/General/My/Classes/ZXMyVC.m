//
//  ZXMyVC.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyVC.h"
#import <Masonry/Masonry.h>
#import "ZXMyTopCell.h"
#import "ZXMyTopSkele.h"
#import "ZXMyInterestCell.h"
#import "ZXMyInterestSkele.h"
#import "ZXMyEarnCell.h"
#import "ZXMyEarnSkele.h"
#import "ZXMyMenuCell.h"
#import "ZXMyMeunNewSkele.h"
#import "ZXMyToolsCell.h"
#import "ZXMyToolsSkele.h"
#import "ZXOrderViewController.h"
#import "ZXRankListVC.h"
#import "ZXNewFansVC.h"
#import "ZXInviteVC.h"
#import "ZXRechargeVC.h"
#import "ZXFavoriteVC.h"
#import "ZXFootPrintVC.h"
#import "ZXCheckOrderVC.h"
#import "ZXInviteCodeViewController.h"
#import "ZXPersonalViewController.h"
#import "ZXBalanceViewController.h"
#import "ZXScanViewController.h"
#import "ZXCouponViewController.h"
#import "ZXScoreViewController.h"
#import "ZXSetupViewController.h"

@interface ZXMyVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *myTable;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (assign, nonatomic) NSInteger cellCount;

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonnull) CAGradientLayer *gradinentLayer;

@property (assign, nonatomic) CGPoint lastPoint;

@end

@implementation ZXMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    self.fd_prefersNavigationBarHidden = YES;

    //注册AppBadge通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadgeDotState) name:APP_BADGE_CHANGE object:nil];
    
    //“我的”页面，做数据的请求初始化
    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
    [userInfo setIsLoaded:NO];
    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
    
    [self createSubviews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.refreshHeader.isRefreshing) {
        [self refreshMyInfo];
    }
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

#pragma mark - NSNotificationCenter

//改变消息按钮badge的显隐
- (void)changeBadgeDotState {
    if ([[ZXAppConfigHelper sharedInstance] appBadge] > 0) {
        [_customNav.badgeDot setHidden:NO];
    } else {
        [_customNav.badgeDot setHidden:YES];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    __weak typeof(self) weakSelf = self;
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
//        [_bgView setBackgroundColor:THEME_COLOR];
        [self.view addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT);
        }];
    }
    //设置渐变色背景
    _gradinentLayer = [CAGradientLayer layer];
    [_gradinentLayer setColors:@[(__bridge id)[UtilsMacro colorWithHexString:@"FF8B00"].CGColor, (__bridge id)[UtilsMacro colorWithHexString:@"FF5100"].CGColor]];
    [_gradinentLayer setLocations:@[@0.0, @1.0]];
    [_gradinentLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [_gradinentLayer setEndPoint:CGPointMake(1.0, 0.0)];
    [_gradinentLayer setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT)];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREENWIDTH, 121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT), _bgView.opaque, 0.0);
    [_gradinentLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _bgView.backgroundColor = [UIColor colorWithPatternImage:resultImg];
    
    if (!_customNav) {
        _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_my_news"] title:@"我的" titleColor:[UIColor whiteColor] rightContent:@[[UIImage imageNamed:@"ic_my_setup"], [UIImage imageNamed:@"icon_spend_sweep"]] leftDot:YES];
        [_customNav setBackgroundColor:[UIColor clearColor]];
        _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] message] url_schema]] andUserInfo:nil viewController:weakSelf];
//            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, COMMON_SHARE_VC] andUserInfo:nil viewController:weakSelf];
        };
        
        _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
            switch (btn.tag) {
                case 0:
                {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SETTING_VC] andUserInfo:nil viewController:weakSelf];
                }
                    break;
                case 1:
                {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SCAN_VC] andUserInfo:nil viewController:weakSelf];
                }
                    
                default:
                    break;
            }
        };
        
        [self.view addSubview:_customNav];
    }
    
    if (!_myTable) {
        _myTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_myTable setShowsVerticalScrollIndicator:NO];
        [_myTable setShowsHorizontalScrollIndicator:NO];
        [_myTable setDelegate:self];
        [_myTable setDataSource:self];
        [_myTable setBackgroundColor:[UIColor clearColor]];
        [_myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_myTable setEstimatedRowHeight:0.0];
        [_myTable setEstimatedSectionHeaderHeight:0];
        [_myTable setEstimatedSectionFooterHeight:0];
        [self.view addSubview:_myTable];
        [_myTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.customNav.mas_bottom);
            make.left.right.mas_equalTo(0.0);
            make.bottom.mas_equalTo(0.0);
        }];
        
        TABTableAnimated *tableAnimate = [TABTableAnimated animatedWithCellClassArray:@[[ZXMyTopSkele class], [ZXMyEarnSkele class], [ZXMyMeunNewSkele class], [ZXMyInterestSkele class], [ZXMyToolsSkele class], [ZXMyToolsSkele class]] cellHeightArray:@[[NSNumber numberWithFloat:121.0], [NSNumber numberWithFloat:104.0], [NSNumber numberWithFloat:86.0], [NSNumber numberWithFloat:130.0], [NSNumber numberWithFloat:135.0], [NSNumber numberWithFloat:135.0]] animatedCountArray:@[[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1]]];
        tableAnimate.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            if (manager.tabTargetClass == [ZXMyTopSkele class]) {
                manager.tabLayer.backgroundColor = [UIColor clearColor].CGColor;
                manager.animatedColor = BG_COLOR;
                manager.animation(0).radius(22.0);
                manager.animationsWithIndexs(5).color([UIColor whiteColor]);
                manager.animationsWithIndexs(6).color([UIColor whiteColor]);
                manager.animationsWithIndexs(7).color([UIColor whiteColor]);
                manager.animationsWithIndexs(8).color([UIColor whiteColor]);
                manager.animationsWithIndexs(9).color([UIColor whiteColor]);
                manager.animationsWithIndexs(10).color([UIColor whiteColor]);
                manager.animationsWithIndexs(11).color([UIColor whiteColor]);
                manager.animationsWithIndexs(12).color([UIColor whiteColor]);
            }
            if (manager.tabTargetClass == [ZXMyEarnSkele class]) {
                manager.animatedBackgroundColor = BG_COLOR;
                manager.animatedColor = [UIColor whiteColor];
                manager.animation(6).radius(5.0).height(104.0).y(0.0);
            }
            if (manager.tabTargetClass == [ZXMyMeunNewSkele class]) {
                manager.animatedBackgroundColor = BG_COLOR;
                manager.animation(0).height(86.0).y(0.0).color([UIColor whiteColor]).radius(5.0);
                manager.animation(1).height(30.0).width(30.0).radius(15.0);
                manager.animation(3).height(30.0).width(30.0).radius(15.0);
                manager.animation(5).height(30.0).width(30.0).radius(15.0);
                manager.animation(7).height(30.0).width(30.0).radius(15.0);
                manager.animation(9).height(30.0).width(30.0).radius(15.0);
                manager.animationsWithIndexs(2).height(12.0);
                manager.animationsWithIndexs(4).height(12.0);
                manager.animationsWithIndexs(6).height(12.0);
                manager.animationsWithIndexs(8).height(12.0);
                manager.animationsWithIndexs(10).height(12.0);
            }
            if (manager.tabTargetClass == [ZXMyInterestSkele class]) {
                manager.animatedColor = [UIColor whiteColor];
                manager.animatedBackgroundColor = BG_COLOR;
                manager.animation(7).radius(5.0).height(130.0).y(0.0);
            }
            if (manager.tabTargetClass == [ZXMyToolsSkele class]) {
                manager.animatedColor = [UIColor whiteColor];
                manager.animatedBackgroundColor = BG_COLOR;
                manager.animation(9).radius(5.0).height(135.0).y(0.0);
            }
        };
        _myTable.tabAnimated = tableAnimate;
        [_myTable tab_startAnimation];
        
        _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(myInfoMJRefresh)];
        [_refreshHeader setLight:YES];
        [_myTable setMj_header:_refreshHeader];
        [_refreshHeader beginRefreshing];
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 121.0 + 65.0 + 10.0);
            }];
        }];
    }
}

- (void)refreshMyInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXMyHelper sharedInstance] fetchMyInfoWithCompletion:^(ZXResponse * _Nonnull response) {
            [self.myTable tab_endAnimation];
            if ([self.refreshHeader isRefreshing]) {
                [self.refreshHeader endRefreshing];
            }
//            NSLog(@"response:%@",response.data);
            ZXUser *user = [ZXUser yy_modelWithDictionary:response.data];
            [user setAuthorization:[[ZXLoginHelper sharedInstance] authorization]];
            [user setIsLoaded:YES];
            [[ZXMyHelper sharedInstance] setUserInfo:user];
            if ([[ZXDatabaseUtil sharedDataBase] userExistWithAuth:[[ZXLoginHelper sharedInstance] authorization]]) {
                [[ZXDatabaseUtil sharedDataBase] updateUserWithUser:user];
            } else {
                [[ZXDatabaseUtil sharedDataBase] insertUser:user];
            }
            if ([[[[ZXMyHelper sharedInstance] userInfo] bind_tb] integerValue] == 1) {
                [[ZXTBAuthHelper sharedInstance] setTBAuthState:YES];
            } else {
                [[ZXTBAuthHelper sharedInstance] setTBAuthState:NO];
            }
            self.cellCount = 4 + [[[[ZXMyHelper sharedInstance] userInfo] public_menus] count];
            [self.myTable reloadData];
            
        } error:^(ZXResponse * _Nonnull response) {
            [self.myTable tab_endAnimation];
            if ([self.refreshHeader isRefreshing]) {
                [self.refreshHeader endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [self.myTable tab_endAnimation];
        if ([self.refreshHeader isRefreshing]) {
            [self.refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - MJRefresh

- (void)myInfoMJRefresh {
    [self refreshMyInfo];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        if ([[ZXMyHelper sharedInstance] userInfo].games_menus.list.count <= 0) {
            return 0;
        } else {
            return 1;
        }
    }
    if (section == 1) {
        if ([[ZXMyHelper sharedInstance] userInfo].sbtns.count <= 0) {
            return 0;
        } else {
            return 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 121.0;
            break;
        case 1:
            if ([[ZXMyHelper sharedInstance] userInfo].sbtns.count <= 0) {
                return 0.0;
            } else {
                return 104.0;
            }
            break;
        case 2:
            return 86.0;
            break;
        case 3:
        {
            if ([[ZXMyHelper sharedInstance] userInfo].games_menus.list.count <= 0) {
                return 0.0;
            } else {
                return 130.0;
            }
        }
            break;
            
        default:
        {
            NSArray *tools = [[NSArray alloc] initWithArray:[[[ZXMyHelper sharedInstance] userInfo] public_menus]];
            ZXMyMenu *myMenu = (ZXMyMenu *)[tools objectAtIndex:indexPath.section - 4];
            int lineNum = ceil([myMenu.list count]/4.0);
            return 45.0 + 90.0 * lineNum;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        if ([[ZXMyHelper sharedInstance] userInfo].games_menus.list.count <= 0) {
            return 0.0001;
        } else {
            return 10.0;
        }
    }
    if (section == 1) {
        if ([[ZXMyHelper sharedInstance] userInfo].sbtns.count <= 0) {
            return 0.0001;
        } else {
            return 10.0;
        }
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        if ([[ZXMyHelper sharedInstance] userInfo].games_menus.list.count <= 0) {
            return nil;
        } else {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
            [footerView setBackgroundColor:BG_COLOR];
            return footerView;
        }
    }
    if (section == 1) {
        if ([[ZXMyHelper sharedInstance] userInfo].sbtns.count <= 0) {
            return nil;
        } else {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
            [footerView setBackgroundColor:BG_COLOR];
            return footerView;
        }
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
    [footerView setBackgroundColor:BG_COLOR];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXUser *userInfo = (ZXUser *)[[ZXMyHelper sharedInstance] userInfo];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"ZXMyTopCell";
            __weak __block ZXMyTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXMyTopCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.zxMyTopCellCpBtnClick = ^(NSInteger index) {
                switch (index) {
                    case 0:
                    {
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, PERSONAL_VC] andUserInfo:nil viewController:self];
                    }
                        break;
                    case 5:
                    {
                        if ([[cell.cpCodeBtn.titleLabel text] isEqualToString:@" 复制 "]) {
                            [UtilsMacro generalPasteboardCopy:[[[ZXMyHelper sharedInstance] userInfo] icode]];
                            [ZXProgressHUD loadSucceedWithMsg:@"复制成功"];
                        } else {
                            ZXInviteCodeViewController *inviteCode = [[ZXInviteCodeViewController alloc] init];
                            [inviteCode setHidesBottomBarWhenPushed:YES];
                            [inviteCode setFromType:1];
                            UINavigationController *inviteCodeNavi = [[UINavigationController alloc] initWithRootViewController:inviteCode];
                            [inviteCodeNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                            [self.navigationController presentViewController:inviteCodeNavi animated:YES completion:nil];
                        }
                    }
                        break;
                }
            };
            cell.zxMyTopItemCellDidSelected = ^(ZXUserBtn * _Nonnull userBtn) {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, userBtn.url_schema] andUserInfo:nil viewController:self];
            };
            [cell setUserInfo:userInfo];
            return cell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"ZXMyEarnCell";
            ZXMyEarnCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXMyEarnCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setUserInfo:userInfo];
            cell.zxMyEarnCellSubViewClick = ^(NSInteger index) {
                ZXUserBtn *userBtn = (ZXUserBtn *)[[userInfo sbtns] objectAtIndex:index];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, userBtn.url_schema] andUserInfo:nil viewController:self];
            };
            return cell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"ZXMyMenuCell";
            ZXMyMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXMyMenuCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setMyMenu:[[[ZXMyHelper sharedInstance] userInfo] main_menus]];
            cell.zxMyMenuCellDidSelectedBlock = ^(NSInteger index) {
                ZXMyMenuItem *myMenuItem = (ZXMyMenuItem *)[[[[[ZXMyHelper sharedInstance] userInfo] main_menus] list] objectAtIndex:index];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, myMenuItem.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            return cell;
        }
            break;
        case 3:
        {
            static NSString *identifier = @"ZXMyInterestCell";
            ZXMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXMyInterestCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setMyMenu:[[[ZXMyHelper sharedInstance] userInfo] games_menus]];
            cell.zxMyInterestCellDidSelectedBlock = ^(NSInteger index) {
                ZXMyMenuItem *myMenuItem = (ZXMyMenuItem *)[[[[[ZXMyHelper sharedInstance] userInfo] games_menus] list] objectAtIndex:index];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, myMenuItem.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            return cell;
        }
            break;
            
        default:
        {
            static NSString *identifier = @"ZXMyToolsCell";
            ZXMyToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXMyToolsCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            ZXMyMenu *myMenu = (ZXMyMenu *)[[[[ZXMyHelper sharedInstance] userInfo] public_menus] objectAtIndex:indexPath.section - 4];
            [cell setMyMenu:myMenu];
            cell.zxMyToolsCellDidSelectedBlock = ^(NSInteger index) {
                ZXMyMenuItem *myMenuItem = (ZXMyMenuItem *)[[myMenu list] objectAtIndex:index];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, myMenuItem.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            return cell;
        }
            break;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        return;
    }
    if (scrollView.contentOffset.y < _lastPoint.y) {
        if (scrollView.contentOffset.y == 0) {
            [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT);
            }];
        } else {
            if (scrollView.contentOffset.y == -65.0) {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                    }];
                    [self.view layoutIfNeeded];
                }];
            } else {
                [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
                }];
            }
        }
    } else {
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            if (scrollView.contentOffset.y == 0) {
                [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT);
                }];
            } else {
                [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(121.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT + fabs(ceil(scrollView.contentOffset.y)) + 10.0);
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
