//
//  ZXSpecialHomeVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSpecialHomeVC.h"
#import "ZXSpecialVC.h"
#import <Masonry/Masonry.h>
#import "ZXGoodsDetailVC.h"

#define TABBAR_HEIGHT 30.0

@interface ZXSpecialHomeVC () <TYTabPagerBarDelegate, TYTabPagerControllerDelegate, TYTabPagerControllerDataSource>

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) ZXSubjectResult *subjectResult;

@property (assign, nonatomic) BOOL single;

@end

@implementation ZXSpecialHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    [self configurationTYTabBar];
    [self createCustomNav];
    [self fetchSubjectInfo];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([self.titleList count] <= 1) {
        [self.tabBar setFrame:CGRectMake(0.0, NAVIGATION_HEIGHT + STATUS_HEIGHT, SCREENWIDTH, 0.0)];
    } else {
        self.tabBar.frame = CGRectMake(0.0, NAVIGATION_HEIGHT + STATUS_HEIGHT, SCREENWIDTH, TABBAR_HEIGHT);
    }
    self.pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(self.tabBar.frame));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.navigationController.topViewController isKindOfClass:[ZXGoodsDetailVC class]]) {
        [ZXProgressHUD hideAllHUD];
    }
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

- (void)configurationTYTabBar {
    [self.pagerController.view setBackgroundColor:[UIColor clearColor]];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:13.0];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:13.0];
    self.tabBar.layout.normalTextColor = COLOR_999999;
    self.tabBar.layout.cellWidth = 0.0;
    self.tabBar.layout.selectedTextColor = THEME_COLOR;
    [self.tabBar.layout setProgressColor:THEME_COLOR];
    [self.tabBar.layout setProgressHeight:1.0];
    [self.tabBar.layout setProgressHorEdging:15.0];
//    [self.tabBar.layout setProgressVerEdging:5.0];
    [self.tabBar.layout setCellEdging:15.0];
    self.tabBar.delegate = self;
    self.tabBar.clipsToBounds = YES;
    self.tabBar.collectionView.clipsToBounds = NO;
    self.tabBar.layout.adjustContentCellsCenter = YES;
    self.tabBar.layout.sectionInset = UIEdgeInsetsMake(-5.0, 0.0, 0.0, 0.0);
    self.dataSource = self;
    self.delegate = self;
//    self.layout.prefetchItemCount = 1;
    self.layout.prefetchItemWillAddToSuperView = YES;
    [self tz_addPopGestureToView:self.pagerController.view];
    [self.layout.scrollView setBounces:NO];
}

- (void)createCustomNav {
    __weak typeof(self) weakSelf = self;
    if (!_customNav) {
        _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:@"" titleColor:HOME_TITLE_COLOR rightContent:[UIImage imageNamed:@"ic_spend_single"] leftDot:NO];
        [_customNav setBackgroundColor:[UIColor whiteColor]];
        [_customNav.rightBtn setHidden:YES];
        _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
            [weakSelf reloadCellType];
        };
        [self.view addSubview:_customNav];
        [_customNav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT);
        }];
    }
}

- (void)reloadCellType {
    NSInteger currentPage = self.pagerController.curIndex;
    _single = !_single;
    if (_single) {
        [_customNav.rightBtn setImage:[UIImage imageNamed:@"ic_spend_single"] forState:UIControlStateNormal];
    } else {
        [_customNav.rightBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
    }
    ZXSpecialVC *subSpecialVC = (ZXSpecialVC *)[self.pagerController.layout viewControllerForItem:[self.pagerController.layout itemForIndex:currentPage] atIndex:currentPage];
    [subSpecialVC setSingle:_single];
}

- (void)fetchSubjectInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXSubjectHelper sharedInstance] fetchSubjectWithSid:_sid andCid:@"" andPage:@"1" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            self.subjectResult = [ZXSubjectResult yy_modelWithJSON:response.data];
            if ([UtilsMacro whetherIsEmptyWithObject:self.subjectResult.category]) {
                self.titleList = [[NSMutableArray alloc] initWithObjects:@"", nil];
            } else {
                if ([self.subjectResult.category count] > 1) {
                    self.titleList = [[NSMutableArray alloc] init];
                    for (int i = 0; i < self.subjectResult.category.count; i++) {
                        ZXSubjectCat *subjectCat = (ZXSubjectCat *)[self.subjectResult.category objectAtIndex:i];
                        [self.titleList addObject:subjectCat.name];
                    }
                } else {
                    self.titleList = [[NSMutableArray alloc] initWithObjects:@"", nil];
                }
            }
            if (self.subjectResult.display == 1) {
                self.single = NO;
                [self.customNav.rightBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
            } else {
                self.single = YES;
                [self.customNav.rightBtn setImage:[UIImage imageNamed:@"ic_spend_single"] forState:UIControlStateNormal];
            }
            if (![UtilsMacro whetherIsEmptyWithObject:self.subjectResult.title]) {
                [self.customNav.titleLab setText:self.subjectResult.title];
            }
            if (self.subjectResult.display_btn == 1) {
                [self.customNav.rightBtn setHidden:NO];
            } else {
                [self.customNav.rightBtn setHidden:YES];
            }
            if ([self.titleList count] <= 1) {
                [self.tabBar setFrame:CGRectMake(0.0, NAVIGATION_HEIGHT + STATUS_HEIGHT, SCREENWIDTH, 0.0)];
            } else {
                self.tabBar.frame = CGRectMake(0.0, NAVIGATION_HEIGHT + STATUS_HEIGHT, SCREENWIDTH, TABBAR_HEIGHT);
            }
            self.pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(self.tabBar.frame));
            [self reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - TYTabPagerBarDelegate && TYTabPagerBarDataSource

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self scrollToControllerAtIndex:index animate:YES];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return [_titleList count];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return [_titleList count];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ZXSpecialVC *special = [[ZXSpecialVC alloc] init];
    [special setSingle:_single];
    [special setSid:_sid];
    if ([_subjectResult.category count] > index && [[_subjectResult.category objectAtIndex:index] isKindOfClass:[ZXSubjectCat class]]) {
        ZXSubjectCat *subjectCat = (ZXSubjectCat *)[_subjectResult.category objectAtIndex:index];
        [special setSubjectCat:subjectCat];
    }
    if (index == 0) {
        [special setSubjectResult:_subjectResult];
    }
    return special;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    return [_titleList objectAtIndex:index];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    NSInteger currentPage = self.pagerController.curIndex;
    ZXSpecialVC *subSpecialVC = (ZXSpecialVC *)[self.pagerController.layout viewControllerForItem:[self.pagerController.layout itemForIndex:currentPage] atIndex:currentPage];
    if (subSpecialVC) {
        if (subSpecialVC.single) {
            [_customNav.rightBtn setImage:[UIImage imageNamed:@"ic_spend_single"] forState:UIControlStateNormal];
        } else {
            [_customNav.rightBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
        }
    }
}

@end
