//
//  ZXRankListVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRankListVC.h"
#import <Masonry/Masonry.h>
#import "ZXRankListView.h"
#import "ZXRankHeaderView.h"
#import "ZXRankListCell.h"
#import "SGAdvertScrollView.h"

#define HEADER_HEIGHT SCREENHEIGHT * 240.0 / 667.0
#define DISTANCE 70.0

@interface ZXRankListVC () <UIScrollViewDelegate, TYTabPagerViewDelegate, TYTabPagerViewDataSource, SGAdvertScrollViewDelegate>

@property (strong, nonatomic) CAGradientLayer *gradinentLayer;

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) NSMutableArray *titleIdList;

@property (strong, nonatomic) NSMutableArray *rankingList;

@property (strong, nonatomic) ZXRankHeaderView *rankHeader;

@property (strong, nonatomic) ZXRankNotice *rankNotice;

@property (strong, nonatomic) TYTabPagerView *pagerView;

@property (strong, nonatomic) ZXRankingRes *rankingRes;

@end

@implementation ZXRankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"排行榜" font:TITLE_FONT color:[UIColor whiteColor]];
    [self.leftBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [self createSubviewsAndLayer];
    [self fetchRankingConfig];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UtilsMacro colorWithHexString:@"F86B24"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ZXProgressHUD hideAllHUD];
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

- (void)createSubviewsAndLayer {
    //设置渐变色背景
    if (!_gradinentLayer) {
        _gradinentLayer = [CAGradientLayer layer];
        [_gradinentLayer setColors:@[(__bridge id)[UtilsMacro colorWithHexString:@"F86B24"].CGColor, (__bridge id)[UIColor whiteColor].CGColor]];
        [_gradinentLayer setLocations:@[@0.0, @1.0]];
        [_gradinentLayer setStartPoint:CGPointMake(0.0, 0.0)];
        [_gradinentLayer setEndPoint:CGPointMake(0.0, 1.0)];
        [_gradinentLayer setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENHEIGHT)];
        [self.view.layer addSublayer:_gradinentLayer];
    }
    
    if (!_rankHeader) {
        _rankHeader = [[ZXRankHeaderView alloc] init];
        [_rankHeader.rankScroll setDelegate:self];
        [self.view addSubview:_rankHeader];
        [_rankHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(HEADER_HEIGHT);
        }];
    }
    
    if (!_pagerView) {
        _pagerView = [[TYTabPagerView alloc] init];
        [_pagerView setBackgroundColor:[UIColor whiteColor]];
        [_pagerView setDataSource:self];
        [_pagerView setDelegate:self];
        [_pagerView.layer setCornerRadius:5.0];
        [_pagerView.tabBar.layout setBarStyle:TYPagerBarStyleProgressView];
        [_pagerView.tabBar.layout setNormalTextFont:[UIFont systemFontOfSize:15.0]];
        [_pagerView.tabBar.layout setSelectedTextFont:[UIFont systemFontOfSize:15.0]];
        [_pagerView.tabBar.layout setNormalTextColor:COLOR_999999];
        [_pagerView.tabBar.layout setSelectedTextColor:THEME_COLOR];
        [_pagerView.tabBar.layout setProgressColor:THEME_COLOR];
        [_pagerView.tabBar.layout setProgressHeight:1.0];
        [_pagerView.tabBar.layout setProgressWidth:60.0];
        [_pagerView.tabBar.layout setCellWidth:(SCREENWIDTH - 24.0)/3.0];
        [_pagerView.tabBar.layout setCellSpacing:0.0];
        [_pagerView.tabBar.layout setCellEdging:0.0];
        [self.view addSubview:_pagerView];
        [_pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.0);
            make.right.mas_equalTo(-12.0);
            make.bottom.mas_equalTo(0.0);
            make.top.mas_equalTo(self.rankHeader.mas_bottom).mas_offset(-DISTANCE);
        }];
    }
}

- (void)fetchRankingConfig {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXRankingHelper sharedInstance] fetchRankingWithPage:@"1" andType:@"1" completion:^(ZXResponse * _Nonnull response) {
//            NSLog(@"response:%@",response.data);
            self.rankingRes = [ZXRankingRes yy_modelWithJSON:response.data];
            [ZXProgressHUD hideAllHUD];
            self.titleList = [[NSMutableArray alloc] init];
            self.titleIdList = [[NSMutableArray alloc] init];
            self.rankingList = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [self.rankingRes.type_arr count]; i++) {
                ZXRankingType *rankingType = (ZXRankingType *)[self.rankingRes.type_arr objectAtIndex:i];
                [self.titleList addObject:rankingType.val];
                [self.titleIdList addObject:rankingType.key];
            }
            if ([self.rankingRes.notice count] <= 0) {
                [self.rankHeader.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0.0);
                }];
            } else {
                [self.rankHeader.topView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(35.0);
                }];
                NSMutableArray *titleList = [[NSMutableArray alloc] init];
                NSMutableArray *signImgList = [[NSMutableArray alloc] init];
                for (int i = 0; i < self.rankingRes.notice.count; i++) {
                    ZXRankNotice *subNotice = (ZXRankNotice *)[self.rankingRes.notice objectAtIndex:i];
                    [titleList addObject:subNotice.txt];
                    [signImgList addObject:@"ic_balance_horn"];
                }
                [self.rankHeader.rankScroll setTitles:titleList];
                [self.rankHeader.rankScroll setSignImages:signImgList];
            }
            [self.pagerView reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
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
    ZXRankListView *rankListView = [[ZXRankListView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index]];
    [rankListView setType:[_titleIdList objectAtIndex:index]];
    if (index == 0) {
        [rankListView setDefaultResult:self.rankingRes.list];
        [rankListView setIsDefault:YES];
    } else {
        [rankListView setIsDefault:NO];
    }
    rankListView.zxRankListViewDidScroll = ^(UIScrollView * _Nonnull scrollView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0 && offsetY <= HEADER_HEIGHT - DISTANCE) {
            [weakSelf.rankHeader mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-offsetY);
            }];
        } else if (offsetY > HEADER_HEIGHT - DISTANCE) {
            if (weakSelf.rankHeader.frame.origin.y == HEADER_HEIGHT - DISTANCE) {
                return;
            }
            [weakSelf.rankHeader mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-HEADER_HEIGHT + DISTANCE);
            }];
        } else if (offsetY < 0) {
            [weakSelf.rankHeader mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0.0);
            }];
        }
    };
    return rankListView;
}

#pragma mark - SGAdvertScrollViewDelegate

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, _rankNotice.url_schema] andUserInfo:nil viewController:self];
}

@end
