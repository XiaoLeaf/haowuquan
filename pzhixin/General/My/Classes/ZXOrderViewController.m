//
//  ZXOrderViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOrderViewController.h"
#import "ZXOrderView.h"
#import <Masonry/Masonry.h>
#import "ZXNotice.h"

#define TITLE_HEIGHT 30.0

#define MINE @"mine"
#define S_TIME @"s_time"
#define E_TIME @"e_time"
#define STATUS @"status"
#define INDEX @"index"

@interface ZXOrderViewController () <TYTabPagerViewDelegate, TYTabPagerViewDataSource> {
    ZXDateView *dateView;
    UIView *titleView;
    UIButton *myBtn;
    UIButton *fansBtn;
}

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) NSMutableArray *titleIdList;

@property (strong, nonatomic) NSMutableArray *minTitleList;

@property (strong, nonatomic) NSMutableArray *mineKeyList;

@property (strong, nonatomic) NSArray *defaultResult;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSMutableDictionary *parameters;

@property (strong, nonatomic) ZXPickerManager *pickManager;

@property (strong, nonatomic) TYTabPagerView *pagerView;

@property (assign, nonatomic) BOOL isLoaded;

@property (strong, nonatomic) ZXCommonNotice *notice;

@property (strong, nonatomic) ZXOrderList *orderList;

@end

@implementation ZXOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createSkeleView];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = NO;
    [self createDatePickerManager];
    // Do any additional setup after loading the view from its nib.
    
    //参数初始化
    _parameters = [[NSMutableDictionary alloc] init];
    [_parameters setValue:@"" forKey:STATUS];
    [_parameters setValue:@"" forKey:MINE];
    [_parameters setValue:@"" forKey:S_TIME];
    [_parameters setValue:@"" forKey:E_TIME];
    _titleList = [[NSMutableArray alloc] init];
    _titleIdList = [[NSMutableArray alloc] init];
    _minTitleList = [[NSMutableArray alloc] init];
    _mineKeyList = [[NSMutableArray alloc] init];
    [self createPagerView];
    [self configurationOrderInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ZXProgressHUD hideAllHUD];
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

- (void)configurationOrderInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXOrderListHelper sharedInstance] fetchOrderListWithPage:@"1" andMine:@"" andStatus:@"" andS_time:@"" andE_time:@"" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            ZXOrderList *orderList = [ZXOrderList yy_modelWithJSON:response.data];
            for (int i = 0; i < [orderList.status_arr count]; i++) {
                ZXOrderStatus *orderStatus = (ZXOrderStatus *)[orderList.status_arr objectAtIndex:i];
                [self.titleList addObject:orderStatus.val];
                [self.titleIdList addObject:orderStatus.key];
            }
            for (int i = 0; i < [orderList.mine_arr count]; i++) {
                ZXOrderStatus *orderStatus = (ZXOrderStatus *)[orderList.mine_arr objectAtIndex:i];
                [self.minTitleList addObject:orderStatus.val];
                [self.mineKeyList addObject:orderStatus.key];
            }
            self.notice = orderList.notice;
            self.defaultResult = [[NSArray alloc] initWithArray:orderList.list];
            [self.parameters setValue:[NSString stringWithFormat:@"%ld", (long)orderList.status_def] forKey:STATUS];
            [self.parameters setValue:[NSString stringWithFormat:@"%ld", (long)orderList.mine_def] forKey:MINE];
            [self.parameters setValue:@"" forKey:S_TIME];
            [self.pagerView reloadData];
            NSInteger position = [self positionForPagerWithStatusDef:orderList.status_def];
            [self.pagerView scrollToViewAtIndex:position animate:YES];
            [self.parameters setValue:[NSString stringWithFormat:@"%d", (int)position] forKey:INDEX];
            
            if ([UtilsMacro whetherIsEmptyWithObject:self.notice.txt]) {
                self.customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:[self titleView] titleColor:HOME_TITLE_COLOR rightContent:@"" leftDot:NO];
            } else {
                self.customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:[self titleView] titleColor:HOME_TITLE_COLOR rightContent:self.notice.txt leftDot:NO];
                [self.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
            }
            [self.customNav setBackgroundColor:BG_COLOR];
            
            __weak typeof(self) weakSelf = self;
            self.customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            self.customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
                if (![UtilsMacro whetherIsEmptyWithObject:weakSelf.notice.url_schema]) {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.notice.url_schema] andUserInfo:nil viewController:weakSelf];
                }
            };
            [self.view addSubview:self.customNav];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)orderSelectTime {
    if (!dateView) {
        dateView = [[ZXDateView alloc] init];
        [dateView setFrame:CGRectMake(0.0, self.view.frame.size.height - 240.0, SCREENWIDTH, 240.0)];
        [self.view addSubview:dateView];
    }
}

- (void)createPagerView {
    if (!_pagerView) {
        _pagerView = [[TYTabPagerView alloc] init];
//        [_pagerView setBackgroundColor:[UIColor whiteColor]];
        [_pagerView setDataSource:self];
        [_pagerView setDelegate:self];
        [_pagerView.tabBar.layout setBarStyle:TYPagerBarStyleProgressView];
        [_pagerView.tabBar.layout setNormalTextFont:[UIFont systemFontOfSize:15.0]];
        [_pagerView.tabBar.layout setSelectedTextFont:[UIFont systemFontOfSize:15.0]];
        [_pagerView.tabBar.layout setNormalTextColor:COLOR_999999];
        [_pagerView.tabBar.layout setSelectedTextColor:THEME_COLOR];
        [_pagerView.tabBar.layout setProgressColor:THEME_COLOR];
        [_pagerView.tabBar.layout setProgressHeight:1.0];
        [_pagerView.tabBar.layout setProgressHorEdging:15.0];
        [_pagerView.tabBar.layout setCellEdging:15.0];
        [_pagerView.tabBar.layout setAdjustContentCellsCenter:YES];
        [_pagerView.pageView.scrollView setBounces:NO];
        [self tz_addPopGestureToView:_pagerView.pageView.scrollView];
        [self.view addSubview:_pagerView];
        [_pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT);
            make.bottom.right.left.mas_equalTo(0.0);
        }];
    }
}

- (NSInteger)positionForPagerWithStatusDef:(NSInteger)statusDef {
    NSInteger resultIndex = 0;
    for (int i = 0; i < [_titleIdList count]; i++) {
        if (statusDef == [[_titleIdList objectAtIndex:i] integerValue]) {
            resultIndex = i;
            break;
        }
    }
    return resultIndex;
}

- (UIView *)titleView {
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 9.5, 150.0, 25)];
    [titleView.layer setCornerRadius:5.0];
    [titleView.layer setBorderWidth:0.5];
    [titleView setClipsToBounds:YES];
    [titleView.layer setBorderColor:[UtilsMacro colorWithHexString:@"161725"].CGColor];

    if (!myBtn) {
        myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [myBtn setFrame:CGRectMake(0.0, 0.0, 75.0, 25.0)];
        [myBtn setTitle:[_minTitleList objectAtIndex:0] forState:UIControlStateNormal];
        [myBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [myBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [myBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [myBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"161725"]];
        [myBtn setTag:0];
        [myBtn setSelected:YES];
        [myBtn addTarget:self action:@selector(handleTapTitleViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:myBtn];
    }

    if (!fansBtn) {
        fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fansBtn setFrame:CGRectMake(75.0, 0.0, 75.0, 25.0)];
        [fansBtn setTitle:[_minTitleList objectAtIndex:1] forState:UIControlStateNormal];
        [fansBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [fansBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [fansBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [fansBtn setBackgroundColor:[UIColor whiteColor]];
        [fansBtn setTag:1];
        [fansBtn addTarget:self action:@selector(handleTapTitleViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:fansBtn];
    }
    switch ([[_parameters valueForKey:MINE] integerValue]) {
        case 1:
        {
            [myBtn setSelected:YES];
            [myBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"161725"]];
            [fansBtn setSelected:NO];
            [fansBtn setBackgroundColor:[UIColor whiteColor]];
        }
            break;
        case 2:
        {
            [myBtn setSelected:NO];
            [myBtn setBackgroundColor:[UIColor whiteColor]];
            [fansBtn setSelected:YES];
            [fansBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"161725"]];
        }
            break;
            
        default:
            break;
    }
    return titleView;
}

- (void)handleTapTitleViewBtnAction:(UIButton *)button {
    switch (button.tag) {
        case 0:
        {
            [myBtn setSelected:YES];
            [myBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"161725"]];
            [fansBtn setSelected:NO];
            [fansBtn setBackgroundColor:[UIColor whiteColor]];
        }
            break;
        case 1:
        {
            [myBtn setSelected:NO];
            [myBtn setBackgroundColor:[UIColor whiteColor]];
            [fansBtn setSelected:YES];
            [fansBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"161725"]];
        }
            break;
            
        default:
            break;
    }
    [_parameters setValue:[NSString stringWithFormat:@"%@",[_mineKeyList objectAtIndex:button.tag]] forKey:MINE];
    ZXOrderView *orderView = (ZXOrderView *)[_pagerView.pageView viewForIndex:self.pagerView.tabBar.curIndex];
    [orderView setParatemers:_parameters];
}

- (void)createDatePickerManager {
    if (!_pickManager) {
        _pickManager = [[ZXPickerManager alloc] init];
        [_pickManager setProvidesPresentationContextTransitionStyle:YES];
        [_pickManager setDefinesPresentationContext:YES];
        [_pickManager setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
}

#pragma mark - TYTabPagerViewDelegate && TYTabPagerViewDataSource

- (NSInteger)numberOfViewsInTabPagerView {
    return [_titleList count];
}

- (NSString *)tabPagerView:(TYTabPagerView *)tabPagerView titleForIndex:(NSInteger)index {
    return [_titleList objectAtIndex:index];
}

- (UIView *)tabPagerView:(TYTabPagerView *)tabPagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    __weak typeof(self) weakSelf = self;
    ZXOrderView *orderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXOrderView class]) owner:nil options:nil] lastObject];
    [orderView setFrame:[tabPagerView.layout frameForItemAtIndex:index]];
    [_parameters setValue:[NSString stringWithFormat:@"%@", [_titleIdList objectAtIndex:index]] forKey:STATUS];
    orderView.zxOrderViewTimeListBlock = ^(NSArray * _Nonnull timeList) {
        if (!weakSelf.isLoaded) {
            [weakSelf.pickManager setDataSource:timeList];
        }
        weakSelf.isLoaded = YES;
    };
    orderView.zxOrderViewHeaderClick = ^{
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.notice.url_schema] andUserInfo:nil viewController:weakSelf];
    };
//    [orderView setNotice:_notice];
    [orderView setTag:index];
    [orderView setParatemers:_parameters];
    if (index == [[_parameters valueForKey:INDEX] integerValue]) {
        [orderView setDefaultResult:_defaultResult];
    }
    return orderView;
}

- (void)tabPagerViewDidEndScrolling:(TYTabPagerView *)tabPagerView animate:(BOOL)animate {
    NSInteger curIndex = tabPagerView.tabBar.curIndex;
    ZXOrderView *orderView = (ZXOrderView *)[tabPagerView.pageView viewForIndex:curIndex];
    [_parameters setValue:[NSString stringWithFormat:@"%@", [_titleIdList objectAtIndex:curIndex]] forKey:STATUS];
    [orderView setParatemers:_parameters];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = curIndex == 0 ? YES : NO;
}

@end
