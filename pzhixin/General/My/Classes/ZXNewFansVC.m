//
//  ZXNewFansVC.m
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewFansVC.h"
#import "ZXFansWakeView.h"
#import "ZXFansTabView.h"
#import <Masonry/Masonry.h>
#import "ZXFansView.h"
#import "ZXFansPopView.h"
#import "ZXInviteVC.h"
#import "ZXNotice.h"
#import "ZXInviteCodeViewController.h"

@interface ZXFansRow : NSObject

@property (strong, nonatomic) NSString *nickname;

@property (strong, nonatomic) NSString *wx;

@end

@implementation ZXFansRow

@end

@interface ZXNewFansVC () <TYTabPagerViewDelegate, TYTabPagerViewDataSource, ZXFansTabViewDelegate>

@property (strong, nonatomic) ZXFansTabView *fansTabView;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) UIView *pagerContainer;

@property (strong, nonatomic) TYTabPagerView *pagerView;

@property (strong, nonatomic) ZXFansWakeView *fansWakeView;

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) NSMutableArray *titleIdList;

@property (strong, nonatomic) ZXCommonNotice *notice;

@property (strong, nonatomic) ZXFansRow *fansRow;

@property (strong, nonatomic) NSString *totalNotice;

@property (strong, nonatomic) ZXFansPopView *fansPopView;

@property (strong, nonatomic) ZXFirstFansView *firstFansView;

@property (assign, nonatomic) BOOL newBind;

@property (strong, nonatomic) NSArray *defaultResult;

@property (assign, nonatomic) NSInteger defaultIndex;

@end

@implementation ZXNewFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self fetchFansConfig];
    [self createSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_pagerContainer setNeedsLayout];
    [_pagerContainer layoutIfNeeded];
    [UtilsMacro addCornerRadiusForView:_pagerContainer andRadius:15.0 andCornes:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_titleList && _newBind) {
        _newBind = NO;
        [self fetchFansConfig];
    }
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

- (void)fetchFansConfig {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXFansHelper sharedInstance] fetchFansWithPage:@"1" andType:@"" andOrder:@"" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            NSDictionary *resultDict = [NSDictionary dictionaryWithDictionary:response.data];
            if ([UtilsMacro whetherIsEmptyWithObject:[resultDict valueForKey:@"list"]] || ![[resultDict valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
                self.defaultResult = [[NSArray alloc] init];
            } else {
                self.defaultResult = [[NSArray alloc] initWithArray:[resultDict valueForKey:@"list"]];
            }
            self.notice = [ZXCommonNotice yy_modelWithJSON:[resultDict valueForKey:@"notice"]];
            if ([UtilsMacro whetherIsEmptyWithObject:self.notice.txt] || [UtilsMacro whetherIsEmptyWithObject:self.notice.url_schema]) {
                self.customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_back_white"] title:@"粉丝" titleColor:[UIColor whiteColor] rightContent:@"" leftDot:NO];
            } else {
                self.customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_back_white"] title:@"粉丝" titleColor:[UIColor whiteColor] rightContent:self.notice.txt leftDot:NO];
            }
            [self.customNav setBackgroundColor:[UIColor clearColor]];
            __weak typeof(self) weakSelf = self;
            self.customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            self.customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, weakSelf.notice.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            [self.view addSubview:self.customNav];
            
            self.titleList = [[NSMutableArray alloc] init];
            self.titleIdList = [[NSMutableArray alloc] init];
            NSArray *typeList;
            if ([[resultDict valueForKey:@"type_arr"] isKindOfClass:[NSArray class]]) {
                typeList = [NSArray arrayWithArray:[resultDict valueForKey:@"type_arr"]];
            } else {
                typeList = [[NSArray alloc] init];
            }
            for (int i = 0; i < [typeList count]; i++) {
                NSDictionary *typeDict = [NSDictionary dictionaryWithDictionary:[typeList objectAtIndex:i]];
                [self.titleList addObject:[typeDict valueForKey:@"val"]];
                [self.titleIdList addObject:[NSString stringWithFormat:@"%@",[typeDict valueForKey:@"key"]]];
            }
            self.defaultIndex = [self positionForPagerWithStatusDef:[resultDict valueForKey:@"type_def"]];
            [self.pagerView reloadData];
            [self.pagerView scrollToViewAtIndex:self.defaultIndex animate:YES];
            
            [self.fansTabView.countLab countFromCurrentValueTo:[[resultDict valueForKey:@"total"] floatValue]];
            self.totalNotice = [NSString stringWithFormat:@"%@",[resultDict valueForKey:@"total_notice"]];
            self.fansRow = [ZXFansRow yy_modelWithJSON:[resultDict valueForKey:@"f_row"]];
            switch ([[resultDict valueForKey:@"is_bind"] integerValue]) {
                case 1:
                {
                    [self.fansTabView.inviteView setHidden:NO];
                    [self.fansTabView.fetchInviteView setHidden:YES];
                    [self.fansTabView.inviteLab setText:[NSString stringWithFormat:@"邀请人:%@",self.fansRow.nickname]];
                    if ([UtilsMacro whetherIsEmptyWithObject:self.fansRow.wx]) {
                        [self.fansTabView.wxLab setText:@"微信号:未填写"];
                        [self.fansTabView.cpBtn setHidden:YES];
                    } else {
                        [self.fansTabView.wxLab setText:[NSString stringWithFormat:@"微信号:%@",self.fansRow.wx]];
                        [self.fansTabView.cpBtn setHidden:NO];
                    }
                }
                    break;
                case 2:
                {
                    [self.fansTabView.inviteView setHidden:YES];
                    [self.fansTabView.fetchInviteView setHidden:NO];
                    [self.fansTabView.inviteLab setText:@""];
                    [self.fansTabView.wxLab setText:@""];
                }
                    break;
                    
                default:
                    break;
            }
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

- (NSInteger)positionForPagerWithStatusDef:(NSString *)statusDef {
    for (int i = 0; i < [_titleIdList count]; i++) {
        if ([statusDef integerValue] == [[_titleIdList objectAtIndex:i] integerValue]) {
            _defaultIndex = i;
            break;
        }
    }
    return _defaultIndex;
}

- (void)createSubviews {
    if (!_fansTabView) {
        _fansTabView = [[ZXFansTabView alloc] init];
        [_fansTabView setDelegate:self];
        [self.view addSubview:_fansTabView];
        [_fansTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(163.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT);
        }];
    }
    
    if (!_pagerContainer) {
        _pagerContainer = [[UIView alloc] init];
        [_pagerContainer setBackgroundColor:[UIColor whiteColor]];
        [_pagerContainer setClipsToBounds:YES];
        [self.view addSubview:_pagerContainer];
        [_pagerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(123.0 + NAVIGATION_HEIGHT + STATUS_HEIGHT);
            make.left.right.mas_equalTo(0.0);
            make.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_pagerView) {
        _pagerView = [[TYTabPagerView alloc] init];
        [_pagerView setDataSource:self];
        [_pagerView setDelegate:self];
        _pagerView.tabBarHeight = 40.0;
        [_pagerView.tabBar.layout setBarStyle:TYPagerBarStyleNoneView];
        [_pagerView.tabBar.layout setNormalTextFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_pagerView.tabBar.layout setSelectedTextFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_pagerView.tabBar.layout setNormalTextColor:COLOR_999999];
        [_pagerView.tabBar.layout setSelectedTextColor:THEME_COLOR];
        [_pagerView.tabBar.layout setCellEdging:25.0];
        [_pagerView.tabBar.layout setAdjustContentCellsCenter:YES];
        [_pagerView.pageView.scrollView setBounces:NO];
        [self tz_addPopGestureToView:_pagerView.pageView.scrollView];
        [_pagerContainer addSubview:_pagerView];
        [_pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.bottom.right.left.mas_equalTo(0.0);
        }];
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
    ZXFansView *fansView = [[ZXFansView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index]];
    if (index == _defaultIndex) {
        [fansView setDefaultResult:_defaultResult];
        [fansView setIsDefault:YES];
    } else {
        [fansView setIsDefault:NO];
    }
    [fansView setFansType:[[_titleIdList objectAtIndex:index] integerValue]];
    fansView.zxFansViewNoFansCellBtnClick = ^{
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, INVITE_VC] andUserInfo:nil viewController:weakSelf];
    };
    fansView.zxFansViewNCellSelected = ^(ZXFans * _Nonnull fans) {
        NSMutableDictionary *fansInfo = [[NSMutableDictionary alloc] init];
        [fansInfo setValue:fans.nickname forKey:@"nickname"];
        [fansInfo setValue:fans.wx forKey:@"wx"];
        [fansInfo setValue:fans.icon forKey:@"icon"];
        [fansInfo setValue:fans.tel forKey:@"tel"];
        [fansInfo setValue:fans.c_time forKey:@"c_time"];
        weakSelf.firstFansView = [[ZXFirstFansView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [weakSelf.firstFansView setUserInfo:fansInfo];
        weakSelf.firstFansView.zxFirstFansViewBtnClick = ^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {
                    if ([UtilsMacro whetherIsEmptyWithObject:fans.wx]) {
                        [ZXProgressHUD loadFailedWithMsg:@"暂未填写微信号"];
                    } else {
                        [UtilsMacro generalPasteboardCopy:fans.wx];
                        [ZXProgressHUD loadSucceedWithMsg:@"复制成功"];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.firstFansView.containerView endRemove:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.firstFansView removeFromSuperview];
                weakSelf.firstFansView = nil;
            });
        };
        [[[UIApplication sharedApplication] keyWindow] addSubview:weakSelf.firstFansView];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:weakSelf.firstFansView.containerView endRemove:NO];
    };
    return fansView;
}

- (void)tabPagerViewDidEndScrolling:(TYTabPagerView *)tabPagerView animate:(BOOL)animate {
}

#pragma mark - ZXFansTabViewDelegate

- (void)fansTabViewHandleTapButtonActionWithTag:(NSInteger)btnTag {
    switch (btnTag) {
        case 0:
        {
            __weak typeof(self) weakSelf = self;
            _fansPopView = [[ZXFansPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _fansPopView.zxFansPopViewClick = ^{
                [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.fansPopView.containerView endRemove:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.fansPopView removeFromSuperview];
                    weakSelf.fansPopView = nil;
                });
            };
            [_fansPopView setTipStr:_totalNotice];
            [[UIApplication sharedApplication].keyWindow addSubview:_fansPopView];
            [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:_fansPopView.containerView endRemove:NO];
        }
            break;
        case 1:
        {
            [UtilsMacro generalPasteboardCopy:_fansRow.wx];
            [ZXProgressHUD loadSucceedWithMsg:@"复制成功"];
        }
            break;
        case 2:
        {
            _newBind = YES;
            ZXInviteCodeViewController *inviteCode = [[ZXInviteCodeViewController alloc] init];
            [inviteCode setFromType:1];
            UINavigationController *inviteCodeNavi = [[UINavigationController alloc] initWithRootViewController:inviteCode];
            [inviteCodeNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [self.navigationController presentViewController:inviteCodeNavi animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
