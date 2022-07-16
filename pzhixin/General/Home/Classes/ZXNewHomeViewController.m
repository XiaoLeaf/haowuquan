//
//  ZXNewHomeViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewHomeViewController.h"
#import "ZXSpendViewController.h"
#import "ZXScanViewController.h"
#import "ZXSearchViewController.h"
#import "ZXSortViewController.h"
#import "ZXGoodsDetailVC.h"
#import "ZXClassify.h"
#import "ZXGuessLikeVC.h"
#import "ZXMenu.h"
#import "ZXHomeVC.h"
#import "ZXPagerMenuCell.h"
#import <Masonry/Masonry.h>
#import "ZXCatSpecialVC.h"
#import <CoreTelephony/CTCellularData.h>

@interface ZXNewHomeViewController () <TYTabPagerBarDelegate, TYTabPagerBarDataSource, TYTabPagerControllerDelegate,TYTabPagerControllerDataSource>

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (nonatomic, strong) NSArray *colorList;

@property (assign, nonatomic) NSInteger currentImgIndex;

@property (assign, nonatomic) NSInteger currentPageIndex;

@property (strong, nonatomic) UIButton *sortBtn;

@property (strong, nonatomic) ZXHomeVC *homeVC;

@property (strong, nonatomic) ZXRedEnvelopView *redEnvelopView;

@property (strong, nonatomic) UIImageView *bgView;

@property (assign, nonatomic) CGPoint lastPoint;

@end

@implementation ZXNewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册AppBadge通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBadgeDotState) name:APP_BADGE_CHANGE object:nil];
    
    [self.view setBackgroundColor:BG_COLOR];
    [self.tabBar registerClass:[ZXPagerMenuCell class] forCellWithReuseIdentifier:@"ZXPagerMenuCell"];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    [self createBgView];
    [self configurationTYTabBar];
//    [self initAppConfiguration];
    
    _customNav = [[ZXCustomNavView alloc] initHomeNaviBarWithRight:@[[UIImage imageNamed:@"icon_spend_sweep"], [UIImage imageNamed:@"icon_spend_news"]]];
    [_customNav setBackgroundColor:[UIColor clearColor]];
    
    __weak typeof(self) weakSelf = self;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        weakSelf.redEnvelopView = [[ZXRedEnvelopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        weakSelf.redEnvelopView.zxRedEnvelopViewBtnClick = ^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    [weakSelf.redEnvelopView setBackgroundColor:[UIColor clearColor]];
                    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.redEnvelopView.containerView endRemove:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.redEnvelopView removeFromSuperview];
                        weakSelf.redEnvelopView = nil;
                    });
                }
                    break;

                default:
                    break;
            }
        };
        [[[UIApplication sharedApplication] keyWindow] addSubview:weakSelf.redEnvelopView];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:weakSelf.redEnvelopView.containerView endRemove:NO];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        switch (btn.tag) {
            case 0:
            {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SCAN_VC] andUserInfo:nil viewController:weakSelf];
            }
                break;
            case 1:
            {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] message] url_schema]] andUserInfo:nil viewController:weakSelf];
            }
                break;
                
            default:
                break;
        }
    };
    _customNav.searchButtonClick = ^{
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SEARCH_VC] andUserInfo:nil viewController:weakSelf];
    };
    [self.view addSubview:_customNav];
    
    //首次安装APP时，监测网络状态
    if (![[ZXAppConfigHelper sharedInstance] appConfig]) {
        [self getTheCurrentNetWorkState];
    } else {
        [self initHomeDatas];
        [self reloadData];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tabBar.frame = CGRectMake(10.0, NAVIGATION_HEIGHT + STATUS_HEIGHT, SCREENWIDTH - 50.0, 50.0);
    if (self.tabBar.frame.origin.y == NAVIGATION_HEIGHT) {
        self.tabBar.frame = CGRectMake(10.0, NAVIGATION_HEIGHT + (isIPhoneXSeries() ? 44.0 : 20.0), SCREENWIDTH - 50.0, 50.0);
    }
    self.pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(self.tabBar.frame));
    [_sortBtn setFrame:CGRectMake(SCREENWIDTH - 40.0, NAVIGATION_HEIGHT + STATUS_HEIGHT, 40.0, 50.0)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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

#pragma mark - 获取当前网络状态

- (void)getTheCurrentNetWorkState {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
            {
//                NSLog(@"网络状态====>kCTCellularDataRestricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initAppConfiguration];
                });
            }
                break;
            case kCTCellularDataNotRestricted:
            {
//                NSLog(@"网络状态====>kCTCellularDataNotRestricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initAppConfiguration];
                });
            }
                break;
            case kCTCellularDataRestrictedStateUnknown:
            {
//                NSLog(@"网络状态====>kCTCellularDataRestrictedStateUnknown");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initAppConfiguration];
                });
            }
                break;
                
            default:
                break;
        }
    };
}

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

//初始化数据
- (void)initHomeDatas {
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] index_header_bg]]];
    self.classifyList = [[NSMutableArray alloc] init];
    NSArray *resultList = [[NSArray alloc] initWithArray:[[[ZXAppConfigHelper sharedInstance] appConfig] cats]];
    for (int i = 0; i < [resultList count]; i++) {
        ZXClassify *classify = (ZXClassify *)[resultList objectAtIndex:i];
        [self.classifyList addObject:classify];
    }
    [[ZXAppConfigHelper sharedInstance] setClassifyList:self.classifyList];
    self.menuList = [[NSMutableArray alloc] init];
    self.titleList = [[NSMutableArray alloc] init];
    self.typeList = [[NSMutableArray alloc] init];
    
    NSArray *menuResult = [[NSArray alloc] initWithArray:[[[ZXAppConfigHelper sharedInstance] appConfig] menus]];
    for (int i = 0; i < [menuResult count]; i++) {
        ZXMenu *menu = (ZXMenu *)[menuResult objectAtIndex:i];
        [self.titleList addObject:menu.name];
        [self.typeList addObject:menu.type];
        [self.menuList addObject:menu];
    }
    [self reloadData];
}

//App初始化配置信息
- (void)initAppConfiguration {
    if ([UtilsMacro isCanReachableNetWork]) {
//        [ZXProgressHUD loadingNoMask];
        [[ZXAppConfigHelper sharedInstance] fetchAPPConfigCompletion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            ZXAppConfig *appConfig = [ZXAppConfig yy_modelWithJSON:response.data];
            [[ZXAppConfigHelper sharedInstance] setAppConfig:appConfig];

            //保存loading资源图片及预加载
            [UtilsMacro preloadLoadingAssetsWithLoadingAsset:[[[ZXAppConfigHelper sharedInstance] appConfig] img_res]];
            [self initHomeDatas];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)configurationTYTabBar {
    [self.pagerController.view setBackgroundColor:[UIColor clearColor]];
    self.tabBarHeight = 40.0;
    [self.tabBar setBackgroundColor:[UIColor clearColor]];
    self.tabBar.layout.barStyle = TYPagerBarStyleNoneView;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15.0];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:18.0];
    self.tabBar.layout.normalTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.tabBar.layout.cellWidth = 0.0;
    self.tabBar.layout.selectedTextColor = [UIColor whiteColor];
    self.tabBar.delegate = self;
    self.tabBar.clipsToBounds = YES;
    self.tabBar.collectionView.clipsToBounds = NO;
    self.tabBar.layout.sectionInset = UIEdgeInsetsMake(-5.0, 0.0, 0.0, 0.0);
    self.dataSource = self;
    self.delegate = self;
    self.layout.prefetchItemCount = 1;
    self.layout.prefetchItemWillAddToSuperView = YES;
    [self.layout.scrollView setBounces:NO];
    
    if (!_sortBtn) {
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn setBackgroundColor:[UIColor clearColor]];
        [_sortBtn setTitle:@"" forState:UIControlStateNormal];
        [_sortBtn setImageEdgeInsets:UIEdgeInsetsMake(-5.0, 0.0, 0.0, 7.0)];
        [_sortBtn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
        [[_sortBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SORT_VC] andUserInfo:nil viewController:self];
        }];
        [self.view addSubview:_sortBtn];
    }
    [self reloadData];
}

- (void)changeBgColorAndAutoScroll {
    [UIView animateWithDuration:0.8 animations:^{
        if (self.currentPageIndex != 0) {
            [self.homeVC.bannerCell.bannerView setAutoScroll:NO];
            [self.bgView setBackgroundColor:THEME_COLOR];
        } else {
            if (self.homeVC.homeTable.contentOffset.y >= 190.0) {
                [self.homeVC.bannerCell.bannerView setAutoScroll:NO];
            } else {
                [self.homeVC.bannerCell.bannerView setAutoScroll:YES];
            }
            if (self.colorList) {
                self.currentImgIndex = self.homeVC.bannerCell.bannerView.currentIndex % self.colorList.count;
                UIColor *currentColor = [UtilsMacro colorWithHexString:[self.colorList objectAtIndex:self.currentImgIndex]];
                [self.bgView setBackgroundColor:currentColor];
            }
        }
    }];
}

//用于JS-OC交互时，回到首页并默认选中某一个index
- (void)setPagerViewSelectIndexWithId:(NSInteger)cid {
    if (_homeVC.bgView) {
        [_homeVC.bgView removeFromSuperview];
        _homeVC.bgView = nil;
    }
    NSInteger index = 0;
    for (int i = 0; i < [_menuList count]; i++) {
        ZXMenu *menu = (ZXMenu *)[_menuList objectAtIndex:i];
        if ([menu.menu_id integerValue] == cid) {
            index = i;
            break;
        }
    }
    [self.pagerController scrollToControllerAtIndex:index animate:YES];
}

- (void)createBgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        [_bgView setContentMode:UIViewContentModeScaleAspectFill];
        [_bgView setClipsToBounds:YES];
//        [_bgView setImage:[UIImage imageNamed:@"home_decorate"]];
        [_bgView setBackgroundColor:THEME_COLOR];
        [self.view addSubview:_bgView];
        [self.view sendSubviewToBack:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0);
        }];
    }
}

//根据偏移量计算设置banner背景颜色
- (void)handleBannerBgColorWithOffset:(NSInteger )offset {
    if (1 == _colorList.count) return;
    NSInteger offsetCurrent = offset % (int)_homeVC.bannerCell.bannerView.bounds.size.width ;
    float rate = offsetCurrent / _homeVC.bannerCell.bannerView.bounds.size.width ;
    NSInteger currentPage = offset / (int)_homeVC.bannerCell.bannerView.bounds.size.width;
//    NSLog(@"currentPage:%ld",(long)currentPage);
//    if (currentPage >= [_colorList count]) {
//        currentPage = 0;
//    }
    NSString *startPageColor;
    NSString *endPageColor;
    if (currentPage == _colorList.count - 1) {
        startPageColor = _colorList[currentPage];
        endPageColor = _colorList[0];
    } else {
        if (currentPage  == _colorList.count) {
            return;
        }
        startPageColor = _colorList[currentPage];
        endPageColor = _colorList[currentPage + 1];
    }
    UIColor *currentToLastColor = [UtilsMacro getColorWithColor:[UtilsMacro colorWithHexString:startPageColor] andCoe:rate andEndColor:[UtilsMacro colorWithHexString:endPageColor]];
    _bgView.backgroundColor = currentToLastColor;
}

#pragma mark - TYTabPagerBarDelegate && TYTabPagerBarDataSource

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self scrollToControllerAtIndex:index animate:YES];
    _currentPageIndex = index;
    if (_colorList) {
        [self changeBgColorAndAutoScroll];
    }
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return [_menuList count];
}

- (UICollectionViewCell <TYTabPagerBarCellProtocol>*)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    ZXMenu *menu = (ZXMenu *)[_menuList objectAtIndex:index];
    if ([UtilsMacro whetherIsEmptyWithObject:menu.img]) {
        UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
        cell.titleLabel.text = menu.name;
        return cell;
    } else {
        ZXPagerMenuCell *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:@"ZXPagerMenuCell" forIndex:index];
        [cell.menuImg setImage:[UIImage imageNamed:@"ic_spend_title"]];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:menu.img] imageView:cell.menuImg placeholderImage:nil options:0 progress:nil completed:nil];
        return cell;
    }
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return [_menuList count];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    __weak typeof(self) weakSelf = self;
    switch ([[_typeList objectAtIndex:index] integerValue]) {
        case 0:
        {
            _homeVC = [[ZXHomeVC alloc] init];
            _homeVC.zxHomeVCCycleScrollViewDidScrollToIndex = ^(NSInteger index) {
                weakSelf.currentImgIndex = index;
                UIColor *currentColor = [UtilsMacro colorWithHexString:[weakSelf.colorList objectAtIndex:weakSelf.currentImgIndex]];
                [UIView animateWithDuration:0.8 animations:^{
                    [weakSelf.bgView setBackgroundColor:currentColor];
                }];
            };
            _homeVC.zxHomeVCColorListBlock = ^(NSArray * _Nonnull colorList) {
                [weakSelf.homeVC.bannerCell.bannerView setAutoScroll:NO];
                weakSelf.colorList = [[NSArray alloc] initWithArray:colorList];
                UIColor *currentColor = [UtilsMacro colorWithHexString:[weakSelf.colorList objectAtIndex:weakSelf.currentImgIndex]];
                [UIView animateWithDuration:0.8 animations:^{
                    [weakSelf.bgView setBackgroundColor:currentColor];
                }];
            };
            _homeVC.zxHomeVCCycleViewScrolling = ^(NSInteger offset) {
                [weakSelf handleBannerBgColorWithOffset:offset];
            };
            _homeVC.zxHomeVCCycleViewResumeBlock = ^(NSInteger targetIndex) {
                NSInteger target = targetIndex%[weakSelf.colorList count];
                [weakSelf.bgView setBackgroundColor:[UtilsMacro colorWithHexString:[weakSelf.colorList objectAtIndex:target]]];
            };
            _homeVC.zxHomeTableDidScroll = ^(UIScrollView * _Nonnull scrollView) {
//                if (scrollView.contentOffset.y > 0) {
//                    return;
//                }
//                if (scrollView.contentOffset.y < weakSelf.lastPoint.y) {
//                    if (scrollView.contentOffset.y == 0) {
//                        [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0);
//                        }];
//                    } else {
//                        if (scrollView.contentOffset.y == -65.0) {
//                            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
//                                [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                    make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0 + fabs(ceil(scrollView.contentOffset.y)));
//                                }];
//                                [weakSelf.view layoutIfNeeded];
//                            }];
//                        } else {
//                            [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0 + fabs(ceil(scrollView.contentOffset.y)));
//                            }];
//                        }
//                    }
//                } else {
//                    [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
//                        if (scrollView.contentOffset.y == 0) {
//                            [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0);
//                            }];
//                        } else {
//                            [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0 + fabs(ceil(scrollView.contentOffset.y)));
//                            }];
//                        }
//                        [weakSelf.view layoutIfNeeded];
//                    }];
//                }
            };
            _homeVC.zxHomeTableWillBeginDragging = ^(UIScrollView * _Nonnull scrollView) {
                weakSelf.lastPoint = scrollView.contentOffset;
            };
//            _homeVC.zxHomeTableFirstLoading = ^{
//                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                    [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                        make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 152.0 + 65.0);
//                    }];
//                }];
//            };
            [_homeVC setRealHome:self];
            if (prefetching) {
                return nil;
            } else {
                return _homeVC;
            }
        }
            break;
        case 1:
        {
            ZXGuessLikeVC *guessLike = [[ZXGuessLikeVC alloc] init];
            if (prefetching) {
                return nil;
            } else {
                return guessLike;
            }
        }
            break;
        case 2:
        {
            ZXMenu *menu = (ZXMenu *)[_menuList objectAtIndex:index];
            ZXSpendViewController *spendVC = [[ZXSpendViewController alloc] init];
            [spendVC setSortId:[menu.menu_id integerValue]];
            if (prefetching) {
                return nil;
            } else {
                return spendVC;
            }
        }
            break;
        case 3:
        {
            ZXMenu *menu = (ZXMenu *)[_menuList objectAtIndex:index];
            ZXCatSpecialVC *catSpecial = [[ZXCatSpecialVC alloc] init];
            [catSpecial setMenu:menu];
            if (prefetching) {
                return nil;
            } else {
                return catSpecial;
            }
        }
            break;
            
        default:
        {
            ZXMenu *menu = (ZXMenu *)[_menuList objectAtIndex:index];
            ZXSpendViewController *spendVC = [[ZXSpendViewController alloc] init];
            [spendVC setSortId:[menu.menu_id integerValue]];
            if (prefetching) {
                return nil;
            } else {
                return spendVC;
            }
        }
            break;
    }
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    return [_titleList objectAtIndex:index];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    _currentPageIndex = toIndex;
    [self changeBgColorAndAutoScroll];
}

@end
