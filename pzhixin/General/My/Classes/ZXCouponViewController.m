//
//  ZXCouponViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCouponViewController.h"
#import "ZXCouponView.h"
#import <MJRefresh/MJRefresh.h>

#define TITLE_HEIGHT 30.0

@interface ZXCouponViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, ZXCouponViewDelegate> {
    
}

@end

@implementation ZXCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self setTitle:@"我的优惠券" font:TITLE_FONT color:HOME_TITLE_COLOR];
    self.titleList = @[@"未使用(2)", @"助力领券(10)", @"已使用(1)", @"已失效(5)"];
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 30.0)];
    [self.categoryView setBackgroundColor:[UIColor whiteColor]];
    [self.categoryView setDelegate:self];
    
    //设置菜单信息
    [self.categoryView setTitles:self.titleList];
    [self.categoryView setTitleColorGradientEnabled:YES];
    [self.categoryView setTitleFont:[UIFont systemFontOfSize:12.0]];
    [self.categoryView setTitleSelectedFont:[UIFont systemFontOfSize:14.0]];
    [self.categoryView setTitleColor:COLOR_999999];
    [self.categoryView setTitleSelectedColor:THEME_COLOR];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    [self tz_addPopGestureToView:self.categoryView.contentScrollView];
    
    //指示器
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    [lineView setIndicatorWidth:75.0];
    [lineView setIndicatorHeight:1.0];
    [lineView setIndicatorColor:THEME_COLOR];
    [lineView setIndicatorCornerRadius:0.5];
    [lineView setLineStyle:JXCategoryIndicatorLineStyle_LengthenOffset];
    self.categoryView.indicators = @[lineView];
    
    [self.view addSubview:self.categoryView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.listContainerView.frame = CGRectMake(0.0, TITLE_HEIGHT, SCREENWIDTH, self.view.frame.size.height - NAVIGATION_HEIGHT - STATUS_HEIGHT);
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

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    ZXCouponView *couponView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXCouponView class]) owner:nil options:nil] lastObject];
    [couponView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENHEIGHT)];
    [couponView setDelegate:self];
    return couponView;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleList.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - ZXCouponViewDelegate

- (void)couponViewTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)couponViewCellHandleTapDetailBtnAction:(ZXCouponCell *)cell {
    
}

- (void)couponViewRefreshCouponInfo:(ZXCouponView *)couponView {
    [couponView.couponTable.mj_header endRefreshing];
}

@end
