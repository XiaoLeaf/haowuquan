
//
//  ZXHomeVC.m
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeVC.h"
#import "ZXHomeMenuCell.h"
#import "ZXHomeMenuSkeleCell.h"
#import "ZXHomeHeadLineCell.h"
#import "ZXHeadLineSkeleCell.h"
#import "ZXFineCell.h"
#import "ZXFineSkeleCell.h"
#import "ZXLoginViewController.h"
#import "ZXDoubleCell.h"
#import "ZXNewHomeHeader.h"
#import "ZXGoodsDetailVC.h"
#import <Masonry/Masonry.h>
#import "ZXNewHomeHeadLineCell.h"

#define AGREEMENT @"AGREEMENT"

@interface ZXHomeVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) ZXRefreshFooter *refreshFooter;

@property (strong, nonatomic) NSMutableArray *redEnvelopList;

@property (strong, nonatomic) NSMutableArray *showedIdList;

@property (strong, nonatomic) ZXRedEnvelop *currentRedEnvelop;

@property (strong, nonatomic) ZXGoods *goods;

@property (strong, nonatomic) NSMutableArray *dayRecList;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSMutableArray *slidesImgList;

@property (strong, nonatomic) ZXHomeIndex *firstHomeIndex;

@property (strong, nonatomic) NSArray *giftList;

@property (strong, nonatomic) NSMutableDictionary *cellInfo;

@property (strong, nonatomic) ZXDealPopView *dealPopView;

@property (strong, nonatomic) NSDictionary *resultData;

@property (assign, nonatomic) BOOL isShowDeal;

@end

@implementation ZXHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.topBtn setHidden:YES];
    _showedIdList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.57510 57865
    
    [_homeTable setEstimatedRowHeight:0];
    [_homeTable setEstimatedSectionHeaderHeight:0];
    [_homeTable setEstimatedSectionFooterHeight:0];
    TABTableAnimated *tableAnimate = [TABTableAnimated animatedWithCellClassArray:@[[ZXHomeBannerCell class], [ZXHomeMenuSkeleCell class], [ZXHeadLineSkeleCell class], [ZXFineSkeleCell class]] cellHeightArray:@[[NSNumber numberWithFloat:190.0], [NSNumber numberWithFloat:95.0], [NSNumber numberWithFloat:300.0], [NSNumber numberWithFloat:240.0]] animatedCountArray:@[[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1]]];
    tableAnimate.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
        if (manager.tabTargetClass == [ZXHomeBannerCell class]) {
            manager.animation(0).y(5.0).height(175.0).radius(5.0).color([UIColor whiteColor]);
            manager.tabLayer.backgroundColor = [UIColor clearColor].CGColor;
        }
        if (manager.tabTargetClass == [ZXHomeMenuSkeleCell class]) {
            manager.animatedColor = [UIColor whiteColor];
            manager.animatedBackgroundColor = BG_COLOR;
            manager.tabLayer.cornerRadius = 5.0;
            manager.animationsWithIndexs(0, 1, 3, 5, 7).radius(23.0);
            manager.animationsWithIndexs(2, 4, 6, 8, 9).height(12.0);
        }
        if (manager.tabTargetClass == [ZXHeadLineSkeleCell class]) {
            manager.animatedColor = [UIColor whiteColor];
            manager.animatedBackgroundColor = BG_COLOR;
            manager.animation(0).height(300.0).radius(5.0);
        }
        if (manager.tabTargetClass == [ZXFineSkeleCell class]) {
            manager.animatedColor = [UIColor whiteColor];
            manager.animatedBackgroundColor = BG_COLOR;
            manager.animation(0).height(240.0).y(0).radius(5.0);
        }
    };
    _homeTable.tabAnimated = tableAnimate;
    [_homeTable tab_startAnimation];
    
    _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchIndexStart)];
    [_refreshHeader setTimeKey:@"ZXHomeVC"];
    [_refreshHeader setLight:YES];
//    [_refreshHeader setLight:YES];
    self.homeTable.mj_header = _refreshHeader;
    if (self.zxHomeTableFirstLoading) {
        self.zxHomeTableFirstLoading();
    }
    [_refreshHeader beginRefreshing];

    _refreshFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDayRecList)];
    self.homeTable.mj_footer = _refreshFooter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_bgView];
    if (_bannerCell) {
        if (_homeTable.contentOffset.y >= 190.0) {
            [_bannerCell.bannerView setAutoScroll:NO];
        } else {
            [_bannerCell.bannerView setAutoScroll:YES];
        }
        [_bannerCell.bannerView adjustWhenControllerViewWillAppera];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_bgView removeFromSuperview];
    _bgView = nil;
    if (!_isShowDeal) {
        [self showDealPopView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_bgView removeFromSuperview];
    _bgView = nil;
    [_bannerCell.bannerView setAutoScroll:NO];
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

- (void)fetchIndexStart {
    if ([UtilsMacro isCanReachableNetWork]) {
        __weak typeof(self) weakSelf = self;
        _page = 1;
        [[ZXHomeIndexHelper sharedInstance] fetchHomeIndexWithPage:[NSString stringWithFormat:@"%ld", (long)_page] completion:^(ZXResponse * _Nonnull response) {
            self.resultData = response.data;
            [self.homeTable tab_endAnimation];
            [ZXProgressHUD hideAllHUD];
            if (weakSelf.refreshHeader.isRefreshing) {
                [weakSelf.refreshHeader endRefreshing];
            }
            self.cellInfo = [[NSMutableDictionary alloc] init];
//            NSLog(@"response:%@",response.data);
            self.firstHomeIndex = [ZXHomeIndex yy_modelWithJSON:response.data];
            if (![self whetherShowDealPopView]) {
                [self showGiftListWithGiftArr:[response.data valueForKey:@"gift_arr"]];
            }
            self.slidesImgList = [[NSMutableArray alloc] init];
            self.colorList = [[NSMutableArray alloc] init];
            if (self.firstHomeIndex.slides.count > 0) {
                for (int i = 0; i < [self.firstHomeIndex.slides count]; i++) {
                    ZXHomeSlides *homeSlides = (ZXHomeSlides *)[self.firstHomeIndex.slides objectAtIndex:i];
                    [self.slidesImgList addObject:homeSlides.img];
                    if ([UtilsMacro whetherIsEmptyWithObject:homeSlides.bg_color]) {
                        [self.colorList addObject:@"D5181E"];
                    } else {
                        [self.colorList addObject:homeSlides.bg_color];
                    }
                }
                if (self.zxHomeVCColorListBlock) {
                    self.zxHomeVCColorListBlock(self.colorList);
                }
            }
            self.dayRecList = [[NSMutableArray alloc] init];
            [self.dayRecList addObjectsFromArray:weakSelf.firstHomeIndex.day_rec.list];
            if ([self.firstHomeIndex.day_rec.list count] < 20) {
                [self.homeTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.homeTable.mj_footer resetNoMoreData];
            }
            [self.homeTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            [self.homeTable tab_endAnimation];
            if (self.refreshHeader.isRefreshing) {
                [self.refreshHeader endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [self.homeTable tab_endAnimation];
        if (_refreshHeader.isRefreshing) {
            [_refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreDayRecList {
    _page++;
    if ([UtilsMacro isCanReachableNetWork]) {
        __weak typeof(self) weakSelf = self;
        [[ZXHomeIndexHelper sharedInstance] fetchHomeIndexWithPage:[NSString stringWithFormat:@"%ld", (long)_page] completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            if (weakSelf.refreshFooter.isRefreshing) {
                [weakSelf.refreshFooter endRefreshing];
            }
            
            ZXHomeIndex *homeIndex = [ZXHomeIndex yy_modelWithJSON:response.data];
            [weakSelf.dayRecList addObjectsFromArray:homeIndex.day_rec.list];
            if ([homeIndex.day_rec.list count] < 20) {
                [weakSelf.homeTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.homeTable.mj_footer resetNoMoreData];
            }
            [weakSelf.homeTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            if (weakSelf.refreshFooter.isRefreshing) {
                [weakSelf.refreshFooter endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if (_refreshFooter.isRefreshing) {
            [_refreshFooter endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)showGiftListWithGiftArr:(NSArray *)giftArr {
    self.giftList = [[NSArray alloc] initWithArray:giftArr];
    self.redEnvelopList = [[NSMutableArray alloc] initWithArray:self.firstHomeIndex.gift_arr];
    for (int i = 0; i < [self.redEnvelopList count]; i++) {
        ZXRedEnvelop *redEnvelop = (ZXRedEnvelop *)[self.redEnvelopList objectAtIndex:i];
        [redEnvelop setShowed:[self refreshEnvelopShowedStatusWithRedEnvelop:redEnvelop]];
        [self.redEnvelopList replaceObjectAtIndex:i withObject:redEnvelop];
    }
    self.currentRedEnvelop = [self fetchCurrentRedEnvelop];
    if (![UtilsMacro whetherIsEmptyWithObject:self.currentRedEnvelop]) {
        [self.showedIdList addObject:self.currentRedEnvelop.cache_key];
        NSDictionary *adObj = @{@"url_schema":HOME_ENVELOP_POP, @"params":[self fetchCurrentGift]};
        ZXPushObj *pushObj = [ZXPushObj yy_modelWithJSON:adObj];
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, pushObj.url_schema] andUserInfo:pushObj viewController:self.realHome];
    }
}

- (BOOL)refreshEnvelopShowedStatusWithRedEnvelop:(ZXRedEnvelop *)redEnvelop {
    BOOL result = NO;
    for (NSString *showedId in _showedIdList) {
        if ([redEnvelop.cache_key isEqualToString:showedId]) {
            result = YES;
            break;
        }
    }
    return result;
}

- (ZXRedEnvelop *)fetchCurrentRedEnvelop {
    ZXRedEnvelop *result = nil;
    for (int i = 0 ; i < [_redEnvelopList count]; i++) {
        ZXRedEnvelop *redEnvelop = (ZXRedEnvelop *)[_redEnvelopList objectAtIndex:i];
        if (!redEnvelop.showed) {
//            NSLog(@"当前查找到的index====>%d",i);
            result = redEnvelop;
            break;
        }
    }
    return result;
}

- (NSDictionary *)fetchCurrentGift {
    NSDictionary *resultDict;
    for (int i = 0; i < [_giftList count]; i++) {
        NSDictionary *giftDict = [[NSDictionary alloc] initWithDictionary:[_giftList objectAtIndex:i]];
        if ([[giftDict valueForKey:@"id"] integerValue] == _currentRedEnvelop.red_id.integerValue) {
            resultDict = [[NSDictionary alloc] initWithDictionary:giftDict];
            break;
        }
    }
    return resultDict;
}

//红包弹窗的点击事件
- (void)executeRedEnvelopViewActionWitRedEnvelop:(ZXRedEnvelop *)redEnvelop {
    switch ([redEnvelop.need integerValue]) {
        case 1:
        {
            if ([[ZXLoginHelper sharedInstance] loginState]) {
                [self executeMethodWithRedEnvelop:redEnvelop];
            } else {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
            }
        }
            break;
        case 2:
        {
            if (![[ZXLoginHelper sharedInstance] loginState]) {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
                return;
            }
            if (![[ZXTBAuthHelper sharedInstance] tbAuthState]) {
                [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
                return;
            }
            [self executeMethodWithRedEnvelop:redEnvelop];
        }
            break;
        case 0:
        {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, redEnvelop.url_schema] andUserInfo:nil viewController:self];
        }
            
        default:
            break;
    }
}

- (void)executeMethodWithRedEnvelop:(ZXRedEnvelop *)redEnvelop {
    switch ([redEnvelop.type integerValue]) {
        case 1:
        {
            [self fetchGetGiftWithRedEnvelop:redEnvelop];
        }
            break;
        case 2:
        case 3:
        {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, redEnvelop.url_schema] andUserInfo:nil viewController:self];
        }
            break;
            
        default:
            break;
    }
}

- (void)fetchGetGiftWithRedEnvelop:(ZXRedEnvelop *)redEnvelop {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        __weak typeof(self) weakSelf = self;
        [[ZXGetGiftHelper sharedInstance] fetchGetGiftWithId:redEnvelop.red_id
                                                  Completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            ZXRedEnvelop *tempRedEnvelop = [ZXRedEnvelop yy_modelWithJSON:response.data];
            __block ZXRedEnvelopView *redEnvelopView = [[ZXRedEnvelopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [redEnvelopView setRedEnvelop:tempRedEnvelop];
            redEnvelopView.zxRedEnvelopViewBtnClick = ^(NSInteger btnTag) {
                [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:redEnvelopView.containerView endRemove:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [redEnvelopView removeFromSuperview];
                    redEnvelopView = nil;
                });
                switch (btnTag) {
                    case 0:
                    case 999:
                    {
//                        [[ZXUniversalUtil sharedInstance] openNewPageWithVC:weakSelf openPage:tempRedEnvelop.params];
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, tempRedEnvelop.url_schema] andUserInfo:nil viewController:weakSelf];
                    }
                        break;
                        
                    default:
                        break;
                }
            };
            redEnvelopView.zxRedEnvelopViewBgImgComplete = ^{
                [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:redEnvelopView.containerView endRemove:NO];
                [[[UIApplication sharedApplication] keyWindow] addSubview:redEnvelopView];
            };
        } error:^(ZXResponse * _Nonnull response) {
            if (response.status == 201) {
                ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
                UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
                [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                [self presentViewController:loginNavi animated:YES completion:nil];
                return;
            }
            if (response.status == 202) {
                [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
                return;
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (BOOL)whetherShowDealPopView {
    BOOL result = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([UtilsMacro whetherIsEmptyWithObject:[userDefaults valueForKey:AGREEMENT]]) {
        result = YES;
    } else {
        result = ![userDefaults boolForKey:AGREEMENT];
    }
    return result;
}

//展示协议弹窗
- (void)showDealPopView {
    if ([self whetherShowDealPopView]) {
        _isShowDeal = YES;
        __weak typeof(self) weakSelf = self;
        self.dealPopView = [[ZXDealPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.dealPopView.zxDealPopViewBtnClick = ^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {
                    exit(0);
                }
                    break;
                case 1:
                {
                    [weakSelf.dealPopView setBackgroundColor:[UIColor clearColor]];
                    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.dealPopView.mainView endRemove:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakSelf.isShowDeal = NO;
                        [weakSelf.dealPopView removeFromSuperview];
                        weakSelf.dealPopView = nil;
                    });
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setBool:YES forKey:AGREEMENT];
                    [userDefaults synchronize];
                    if (weakSelf.resultData) {
                        [weakSelf showGiftListWithGiftArr:[weakSelf.resultData valueForKey:@"gift_arr"]];
                    }
                }
                    break;
                case 2:
                {
                    [weakSelf.dealPopView setBackgroundColor:[UIColor clearColor]];
                    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.dealPopView.mainView endRemove:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakSelf.isShowDeal = NO;
                        [weakSelf.dealPopView removeFromSuperview];
                        weakSelf.dealPopView = nil;
                    });
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ZXAppConfigHelper.sharedInstance.appConfig.h5.agreement.url_schema] andUserInfo:nil viewController:[UtilsMacro topViewController]];
                }
                    break;
                    
                default:
                    break;
            }
        };
        [self.dealPopView setPolicy:ZXAppConfigHelper.sharedInstance.appConfig.policy];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.dealPopView];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:self.dealPopView.mainView endRemove:NO];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return 1;
    }
    return [_dayRecList count]/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return (SCREENWIDTH - 10.0)/2.0;
        }
            break;
        case 1:
            return 95.0 * ceil(_firstHomeIndex.cbtns.count/5.0);
            break;
        case 2:
            return 40.0 + (SCREENWIDTH - 10.0)/3.0 * 2.0;
            break;
        case 3:
            return (SCREENWIDTH - 10.0)/3.0 + 130.0;
            break;
            
        default:
            return (SCREENWIDTH - 15.0)/2.0 + 110.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        return 40.0;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        __weak typeof(self) weakSelf = self;
        ZXNewHomeHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXNewHomeHeader class]) owner:nil options:nil] lastObject];
        [headerView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 40.0)];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_firstHomeIndex.day_rec.banner] imageView:headerView.titleImg placeholderImage:nil options:0 progress:nil completed:nil];
        headerView.zxNewHomeHeaderImgClick = ^{
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.firstHomeIndex.day_rec.url_schema] andUserInfo:nil viewController:weakSelf];
        };
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (_firstHomeIndex.cbtns.count > 0) {
            return 10.0;
        } else {
            return 0.0001;
        }
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (_firstHomeIndex.cbtns.count > 0) {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
            [footerView setBackgroundColor:BG_COLOR];
            return footerView;
        } else {
            return nil;
        }
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
    [footerView setBackgroundColor:BG_COLOR];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"ZXHomeBannerCell";
            _bannerCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (_bannerCell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXHomeBannerCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                _bannerCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [_bannerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [_bannerCell.bannerView setImageURLStringsGroup:_slidesImgList];
            _bannerCell.bannerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
                ZXHomeSlides *homeSlides = (ZXHomeSlides *)[self.firstHomeIndex.slides objectAtIndex:currentIndex];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, homeSlides.url_schema] andUserInfo:nil viewController:self];
            };
            _bannerCell.bannerView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.zxHomeVCCycleScrollViewDidScrollToIndex) {
                        self.zxHomeVCCycleScrollViewDidScrollToIndex(currentIndex);
                    }
                });
            };
            _bannerCell.bannerView.cycleScrollViewBlock = ^(NSInteger offset) {
                if (self.zxHomeVCCycleViewScrolling) {
                    self.zxHomeVCCycleViewScrolling(offset);
                }
            };
            _bannerCell.bannerView.itemResumeBlock = ^(NSInteger targetIndex) {
                if (self.zxHomeVCCycleViewResumeBlock) {
                    self.zxHomeVCCycleViewResumeBlock(targetIndex);
                }
            };
            [_bannerCell.bannerView setAutoScrollTimeInterval:3.0];
            [_bannerCell.bannerView setBackgroundColor:BG_COLOR];
            [_bannerCell.bannerView setPageControlDotSize:CGSizeMake(8.0, 8.0)];
            [_bannerCell.bannerView setPageDotColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
            [_bannerCell.bannerView setCurrentPageDotColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
            [_bannerCell.bannerView setPlaceholderImage:[UtilsMacro small_placeHolder]];
            return _bannerCell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"ZXHomeMenuCell";
            ZXHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXHomeMenuCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setMenuList:_firstHomeIndex.cbtns];
            cell.zxHomeMenuCellMenuDidSelected = ^(NSInteger cellTag, NSInteger menuTag) {
                ZXHomeSlides *homeBtn = (ZXHomeSlides *)[weakSelf.firstHomeIndex.cbtns objectAtIndex:cellTag * 5 + menuTag];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, homeBtn.url_schema] andUserInfo:nil viewController:weakSelf.realHome];
            };
            return cell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"ZXNewHomeHeadLineCell";
            ZXNewHomeHeadLineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ZXNewHomeHeadLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setNotices:_firstHomeIndex.notices];
            [cell setMain_ads:_firstHomeIndex.main_ads];
            cell.zxNewHomeHeadLineCellImgClick = ^(NSInteger imgTag) {
                ZXHomeSlides *homeAds = (ZXHomeSlides *)[weakSelf.firstHomeIndex.main_ads objectAtIndex:imgTag];
                if ([UtilsMacro whetherIsEmptyWithObject:homeAds.url_schema]) {
                    return;
                }
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, homeAds.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            cell.zxNewHomeHeadLineCellAdvertDidSelected = ^(NSInteger index) {
                ZXHomeNotice *homeNotice = (ZXHomeNotice *)[weakSelf.firstHomeIndex.notices objectAtIndex:index];
                if ([UtilsMacro whetherIsEmptyWithObject:homeNotice.url_schema]) {
                    return;
                }
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, homeNotice.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            return cell;
        }
            break;
        case 3:
        {
            static NSString *identifier = @"ZXFineCell";
            ZXFineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXFineCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setDayRec:_firstHomeIndex.ranking_goods];
            cell.zxFineCellTitleImgClick = ^{
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.firstHomeIndex.ranking_goods.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            cell.zxFineCellCollectionCellDidSelected = ^(NSInteger index) {
                ZXGoods *goods = (ZXGoods *)[weakSelf.firstHomeIndex.ranking_goods.list objectAtIndex:index];
                ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
                [goodsDetail setHidesBottomBarWhenPushed:YES];
                [goodsDetail setGoods:goods];
                [weakSelf.navigationController pushViewController:goodsDetail animated:YES];
            };
            return cell;
        }
            break;
            
        default:
        {
            __weak typeof(self) weakSelf = self;
            static NSString *identifier = @"ZXDoubleCell";
            ZXDoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXDoubleCell class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            ZXGoods *leftGoods = (ZXGoods *)[_dayRecList objectAtIndex:(indexPath.row) * 2];
            [cell setLeftGoods:leftGoods];
            [cell.leftGoodsView setTag:indexPath.row * 2];
            cell.zxDoubleCellLeftGoodsClick = ^(NSInteger viewTag) {
                if (![UtilsMacro whetherIsEmptyWithObject:leftGoods.pre_slide]) {
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:leftGoods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        
                    }];
                }
                ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
                [goodsDetail setHidesBottomBarWhenPushed:YES];
                [goodsDetail setGoods:leftGoods];
                [weakSelf.navigationController pushViewController:goodsDetail animated:YES];
            };
            if ([_dayRecList count] > indexPath.row * 2 + 1) {
                ZXGoods *rightGoods = (ZXGoods *)[_dayRecList objectAtIndex:indexPath.row * 2 + 1];
                [cell setRightGoods:rightGoods];
                [cell.rightGoodsView setTag:indexPath.row * 2 + 1];
                cell.zxDoubleCellRightGoodsClick = ^(NSInteger viewTag) {
                    if (![UtilsMacro whetherIsEmptyWithObject:rightGoods.pre_slide]) {
                        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:rightGoods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            
                        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                            
                        }];
                    }
                    ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
                    [goodsDetail setHidesBottomBarWhenPushed:YES];
                    [goodsDetail setGoods:rightGoods];
                    [weakSelf.navigationController pushViewController:goodsDetail animated:YES];
                };
            }
            return cell;
        }
            break;
    }
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _homeTable) {
//        if (scrollView.contentOffset.y >= 190.0) {
//            [_bannerCell.bannerView setAutoScroll:NO];
//        } else {
//            if (scrollView.isDragging) {
//                [_bannerCell.bannerView setAutoScroll:NO];
//            } else {
//                [_bannerCell.bannerView setAutoScroll:YES];
//            }
//        }
//        if (self.zxHomeTableDidScroll) {
//            self.zxHomeTableDidScroll(scrollView);
//        }
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.zxHomeTableWillBeginDragging) {
        self.zxHomeTableWillBeginDragging(scrollView);
    }
    if (scrollView == _homeTable) {
        [_bannerCell.bannerView setAutoScroll:NO];
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView == _homeTable) {
//        if (scrollView.contentOffset.y >= 190.0) {
//            [_bannerCell.bannerView setAutoScroll:NO];
//        } else {
//            [_bannerCell.bannerView setAutoScroll:YES];
//        }
//    }
//}

#pragma mark - Button Method

- (IBAction)handleTapTopBtnAction:(id)sender {
    [self.topBtn setHidden:YES];
    [self.homeTable setContentOffset:CGPointZero animated:YES];
}

@end
