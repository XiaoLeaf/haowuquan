//
//  ZXEarningDetailVC.m
//  pzhixin
//
//  Created by zhixin on 2019/8/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningDetailVC.h"
#import "ZXEarningDetailCell.h"
#import "ZXEarningDetailView.h"
#import <Masonry/Masonry.h>

#define TITLE_HEIGHT 30.0

#define MINE @"mine"
#define S_TIME @"s_time"
#define E_TIME @"e_time"
#define TYPE @"type"
#define INDEX @"index"

@interface ZXEarningDetailVC () <TYTabPagerViewDelegate, TYTabPagerViewDataSource>

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UIButton *titleBtn;

@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSMutableDictionary *parameters;

@property (strong, nonatomic) ZXPickerManager *pickManager;

@property (assign, nonatomic) BOOL isLoaded;

@property (strong, nonatomic) TYTabPagerView *pagerView;

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) NSMutableArray *titleIdList;

@property (strong, nonatomic) NSMutableArray *minTitleList;

@property (strong, nonatomic) NSMutableArray *mineKeyList;

@property (strong, nonatomic) NSDictionary *defaultResult;

@property (strong, nonatomic) UIButton *issueBtn;

@property (strong, nonatomic) ZXProfitListRes *profitListRes;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@end

@implementation ZXEarningDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createDatePickManager];
    // Do any additional setup after loading the view from its nib.
    
    //参数初始化
    _parameters = [[NSMutableDictionary alloc] init];
    [_parameters setValue:@"" forKey:TYPE];
    [_parameters setValue:@"" forKey:MINE];
    [_parameters setValue:@"" forKey:S_TIME];
    [_parameters setValue:@"" forKey:E_TIME];
    _titleList = [[NSMutableArray alloc] init];
    _titleIdList = [[NSMutableArray alloc] init];
    _minTitleList = [[NSMutableArray alloc] init];
    _mineKeyList = [[NSMutableArray alloc] init];
    [self configurationProfitListInfo];
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

- (void)configurationProfitListInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXProfitListHelper sharedInstance] fetchProfitListWithPage:@"" andMine:@"" andType:@"" andS_time:@"" andE_time:@"" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            self.profitListRes = [ZXProfitListRes yy_modelWithJSON:response.data];
            NSDictionary *configResult = [[NSDictionary alloc] initWithDictionary:response.data];
            for (int i = 0; i < [self.profitListRes.type_arr count]; i++) {
                ZXProfitTypeItem *item = (ZXProfitTypeItem *)[self.profitListRes.type_arr objectAtIndex:i];
                [self.titleList addObject:item.val];
                [self.titleIdList addObject:item.key];
            }
            for (int i = 0; i < [self.profitListRes.mine_arr count]; i++) {
                ZXProfitTypeItem *item = (ZXProfitTypeItem *)[self.profitListRes.mine_arr objectAtIndex:i];
                [self.minTitleList addObject:item.val];
                [self.mineKeyList addObject:item.key];
            }
            [self createCustomNav];
            [self createPagerView];
            
            self.defaultResult = [[NSDictionary alloc] initWithDictionary:configResult];
            [self.parameters setValue:self.profitListRes.type_def forKey:TYPE];
            [self.parameters setValue:self.profitListRes.mine_def forKey:MINE];
            [self.parameters setValue:@"" forKey:S_TIME];
            NSInteger position = [self positionForPagerWithStatusDef:self.profitListRes.mine_def];
            [self.parameters setValue:[NSString stringWithFormat:@"%d", (int)position] forKey:INDEX];
            [self.pagerView reloadData];
            [self.pagerView scrollToViewAtIndex:position animate:YES];
            
            NSDictionary *dateDict = self.profitListRes.date_arr;
            NSMutableArray *yearList = [[NSMutableArray alloc] initWithArray:[dateDict allKeys]];
            yearList = [NSMutableArray arrayWithArray:[yearList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }]];
            NSMutableArray *resultList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [yearList count]; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:[yearList objectAtIndex:i] forKey:@"year"];
                [dict setValue:[dateDict valueForKey:[yearList objectAtIndex:i]] forKey:@"month"];
                [resultList addObject:dict];
            }
            [self.pickManager setDataSource:resultList];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (NSInteger)positionForPagerWithStatusDef:(NSString *)statusDef {
    NSInteger resultIndex = 0;
    for (int i = 0; i < [_titleIdList count]; i++) {
        if ([statusDef integerValue] == [[_titleIdList objectAtIndex:i] integerValue]) {
            resultIndex = i;
            break;
        }
    }
    return resultIndex;
}

- (NSInteger)positionForMineWithMineDef:(NSString *)mineDef {
    NSInteger result = 0;
    for (int i = 0; i < self.profitListRes.mine_arr.count; i++) {
        ZXProfitTypeItem *item = (ZXProfitTypeItem *)[self.profitListRes.mine_arr objectAtIndex:i];
        if ([mineDef integerValue] == [item.key integerValue]) {
            result = i;
            break;
        }
    }
    return result;
}

- (void)createDatePickManager {
    if (!_pickManager) {
        _pickManager = [[ZXPickerManager alloc] init];
        [_pickManager setProvidesPresentationContextTransitionStyle:YES];
        [_pickManager setDefinesPresentationContext:YES];
        [_pickManager setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
}

- (void)createCustomNav {
    __weak typeof(self) weakSelf = self;
    if (!_customNav) {
        if (![UtilsMacro whetherIsEmptyWithObject:_profitListRes.notice.txt]) {
            _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:[self titleView] titleColor:HOME_TITLE_COLOR rightContent:_profitListRes.notice.txt leftDot:NO];
            [_customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
        } else {
            _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:[self titleView] titleColor:HOME_TITLE_COLOR rightContent:nil leftDot:NO];
        }
        [self.view addSubview:_customNav];
    }
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        if (![UtilsMacro whetherIsEmptyWithObject:weakSelf.profitListRes.notice.url_schema]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.profitListRes.notice.url_schema] andUserInfo:nil viewController:weakSelf];
        }
    };
    [_customNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(STATUS_HEIGHT + NAVIGATION_HEIGHT);
    }];
}

- (void)createPagerView {
    if (!_pagerView) {
        _pagerView = [[TYTabPagerView alloc] init];
        [_pagerView setDataSource:self];
        [_pagerView setDelegate:self];
        [_pagerView.tabBar.layout setBarStyle:TYPagerBarStyleProgressView];
        [_pagerView.tabBar.layout setNormalTextFont:[UIFont systemFontOfSize:12.0]];
        [_pagerView.tabBar.layout setSelectedTextFont:[UIFont systemFontOfSize:12.0]];
        [_pagerView.tabBar.layout setNormalTextColor:COLOR_999999];
        [_pagerView.tabBar.layout setSelectedTextColor:THEME_COLOR];
        [_pagerView.tabBar.layout setProgressColor:THEME_COLOR];
        [_pagerView.tabBar.layout setProgressHeight:1.0];
        [_pagerView.tabBar.layout setProgressHorEdging:25.0];
        [_pagerView.tabBar.layout setCellEdging:25.0];
        [_pagerView.tabBar.layout setAdjustContentCellsCenter:YES];
        [_pagerView.pageView.scrollView setBounces:NO];
        [self tz_addPopGestureToView:_pagerView.pageView.scrollView];
        [self.view addSubview:_pagerView];
    }
    [_pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNav.mas_bottom);
        make.bottom.right.left.mas_equalTo(0.0);
    }];
}

- (UIView *)titleView {
    UIView *subTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 25.0)];
    [subTitleView setBackgroundColor:[UIColor clearColor]];
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.profitListRes.mine_arr.count > [self positionForMineWithMineDef:self.profitListRes.mine_def]) {
        ZXProfitTypeItem *item = (ZXProfitTypeItem *)[self.profitListRes.mine_arr objectAtIndex:[self positionForMineWithMineDef:self.profitListRes.mine_def]];
        [_titleBtn setTitle:item.val forState:UIControlStateNormal];
    } else {
        [_titleBtn setTitle:@"收益明细" forState:UIControlStateNormal];
    }
    if (self.profitListRes.mine_arr.count > 1) {
        [_titleBtn setImage:[UIImage imageNamed:@"ic_down_arrow"] forState:UIControlStateNormal];
    }
    [_titleBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [_titleBtn.titleLabel setFont:TITLE_FONT];
    [_titleBtn setFrame:subTitleView.bounds];
    _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_titleBtn.imageView.frame.size.width - 2.5, 0, _titleBtn.imageView.frame.size.width);
    _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _titleBtn.titleLabel.frame.size.width + 2.5, 0, -_titleBtn.titleLabel.frame.size.width);
    [_titleBtn addTarget:self action:@selector(handleTapTitleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [subTitleView addSubview:_titleBtn];
    _titleView = subTitleView;
    return _titleView;
}

- (void)handleTapTitleBtnAction {
    if (self.profitListRes.mine_arr.count <= 1) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIAlertController *titleAlert = [UtilsMacro zxAlertControllerWithTitle:nil andMessage:nil style:UIAlertControllerStyleActionSheet andAction:_minTitleList alertActionClicked:^(NSInteger actionTag) {
        NSInteger curIndex = weakSelf.pagerView.tabBar.curIndex;
        ZXEarningDetailView *detailView = (ZXEarningDetailView *)[weakSelf.pagerView.pageView viewForIndex:curIndex];
        [weakSelf.parameters setValue:[NSString stringWithFormat:@"%@", [weakSelf.mineKeyList objectAtIndex:actionTag]] forKey:MINE];
        [detailView setParameters:weakSelf.parameters];
        [weakSelf.titleBtn setTitle:[weakSelf.minTitleList objectAtIndex:actionTag] forState:UIControlStateNormal];
    }];
    [self presentViewController:titleAlert animated:YES completion:nil];
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
    ZXEarningDetailView *earningDetailView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXEarningDetailView class]) owner:nil options:nil] lastObject];
    [earningDetailView setTag:index];
    [earningDetailView setFrame:[tabPagerView.layout frameForItemAtIndex:index]];
    [_parameters setValue:[NSString stringWithFormat:@"%@", [_titleIdList objectAtIndex:index]] forKey:TYPE];
    [earningDetailView setParameters:_parameters];
    earningDetailView.zxEarningDetailViewMonthBtnClick = ^{
        weakSelf.pickManager.zxPickManagerBlock = ^(NSString * _Nonnull yearStr, NSString * _Nonnull monthStr) {
            ZXEarningDetailView *detailView = (ZXEarningDetailView *)[weakSelf.pagerView.pageView viewForIndex:weakSelf.pagerView.tabBar.curIndex];
            [weakSelf.parameters setValue:[NSString stringWithFormat:@"%@-%@",yearStr,monthStr] forKey:S_TIME];
            [detailView setParameters:weakSelf.parameters];
        };
        [self presentViewController:weakSelf.pickManager animated:YES completion:^{
        }];;
    };
    if (index == [[_parameters valueForKey:INDEX] integerValue]) {
        [earningDetailView setDefaultResult:_defaultResult];
    }
    return earningDetailView;
}

- (void)tabPagerViewDidEndScrolling:(TYTabPagerView *)tabPagerView animate:(BOOL)animate {
    NSInteger curIndex = tabPagerView.tabBar.curIndex;
    ZXEarningDetailView *detailView = (ZXEarningDetailView *)[tabPagerView.pageView viewForIndex:curIndex];
    [_parameters setValue:[NSString stringWithFormat:@"%@", [_titleIdList objectAtIndex:curIndex]] forKey:TYPE];
    [detailView setParameters:_parameters];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = curIndex == 0 ? YES : NO;
}

@end
