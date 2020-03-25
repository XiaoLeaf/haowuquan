//
//  ZXGuideViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGuideViewController.h"
#import "UtilsMacro.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import <CoreTelephony/CTCellularData.h>

@interface ZXGuideViewController () <SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *guideCycleView;

@property (strong, nonatomic) NSArray *guideImgList;

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@property (strong, nonatomic) TYCyclePagerView *cyclePagerView;

@end

@implementation ZXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_skipBtn setHidden:YES];
    [_skipBtn.layer setCornerRadius:self.skipBtn.frame.size.width/2.0];
    [self createGuideSubViews];
    [self getTheCurrentNetWorkState];
    // Do any additional setup after loading the view from its nib.
    _guideImgList = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562145461&di=1aabe72771880638f9ef0d6ab0c7e050&imgtype=jpg&er=1&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0188db57d750c60000012e7e354a01.png%402o.png",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1337914446,4045813758&fm=15&gp=0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561550828227&di=12be20815c4e607b079760e6552ea919&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F016d0f5c67f337a801203d22615783.jpg%402o.jpg"];
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

- (void)createGuideSubViews {
    if (!_guideCycleView) {
        _guideCycleView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENHEIGHT)];
        [_guideCycleView setAutoScroll:NO];
        [_guideCycleView setInfiniteLoop:NO];
        [_guideCycleView setDelegate:self];
        [_guideCycleView setImageURLStringsGroup:_guideImgList];
        [self.view addSubview:_guideCycleView];
        [self.view bringSubviewToFront:_skipBtn];
    }
}

- (void)reloadGuideInfo {
    [_guideCycleView setImageURLStringsGroup:_guideImgList];
}

/**
 获取当前网络状态
 */
- (void)getTheCurrentNetWorkState {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
            {
//                NSLog(@"网络状态====>kCTCellularDataRestricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadGuideInfo];
                });
            }
                break;
            case kCTCellularDataNotRestricted:
            {
//                NSLog(@"网络状态====>kCTCellularDataNotRestricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadGuideInfo];
                });
            }
                break;
            case kCTCellularDataRestrictedStateUnknown:
            {
//                NSLog(@"网络状态====>kCTCellularDataRestrictedStateUnknown");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadGuideInfo];
                });
            }
                break;
                
            default:
                break;
        }
    };
}

#pragma mark - ZXGuideViewDelegate

- (void)guideViewHandleTapSkipBtnAction {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@Logined",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [userDefaults setObject:@YES forKey:key];
    [userDefaults synchronize];
    [[AppDelegate sharedInstance] loginSucceed];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (index == [_guideImgList count] - 1) {
        [_skipBtn setHidden:NO];
    } else {
        [_skipBtn setHidden:YES];
    }
}

#pragma mark - Button Methods

- (IBAction)handleTapSkipBtnAction:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@Logined",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [userDefaults setObject:@YES forKey:key];
    [userDefaults synchronize];
    [[AppDelegate sharedInstance] loginSucceed];
}

@end
