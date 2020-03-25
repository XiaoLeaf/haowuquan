//
//  ZXUniversalUtil.m
//  pzhixin
//
//  Created by zhixin on 2019/10/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUniversalUtil.h"
#import "ZXNewHomeViewController.h"
#import "ZXSearchResultViewController.h"
#import "ZXSearchViewController.h"
#import "ZXSortViewController.h"
#import "ZXGoodsDetailVC.h"
#import "ZXLoginViewController.h"
#import "ZXInviteCodeViewController.h"
#import "ZXPersonalViewController.h"
#import "ZXAccountViewController.h"
#import "ZXScoreViewController.h"
#import "ZXCouponViewController.h"
#import "ZXOrderViewController.h"
#import "ZXNewFansVC.h"
#import "ZXInviteVC.h"
#import "ZXFavoriteVC.h"
#import "ZXFootPrintVC.h"
#import "ZXRechargeVC.h"
#import "ZXClassify.h"
#import "ZXBalanceViewController.h"
#import <GTMBase64/GTMBase64.h>

static ZXUniversalUtil *universalUtil = nil;

@interface ZXUniversalUtil ()

@property (strong, nonatomic) ZXTBAuthView *tbAuthView;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger second;

@property (assign, nonatomic) BOOL isLoading;

@property (strong, nonatomic) NSArray *saveImgList;

@property (assign, nonatomic) NSInteger currentSave;

@end

@implementation ZXUniversalUtil

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

+ (ZXUniversalUtil *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (universalUtil == nil) {
            universalUtil = [[ZXUniversalUtil alloc] init];
        }
    });
    return universalUtil;
}

#pragma mark - 获取APP参数

- (id)get_params:(id)data {
    return @{@"authorization":[UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] authorization]] ? @"" : [[[ZXMyHelper sharedInstance] userInfo] authorization], @"imei":[UtilsMacro fetchUUID], @"platform":@"1", @"version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]};
}

#pragma mark - 参数加签

- (id)get_token:(id)data {
    NSLog(@"data====>%@",data);
    return @{@"token":[UtilsMacro sha1WithString:[NSString stringWithFormat:@"%@%@",[UtilsMacro MD5ForLower32Bate:[UtilsMacro sortedDictionary:data]],[UtilsMacro MD5ForLower32Bate:@"PZhiXin"]]]};
}

#pragma mark - webview按钮事件

- (id)do_btn:(id)data {
    switch ([[data valueForKey:@"type"] integerValue]) {
        case 1:
        {
            if ([_wkWebView canGoBack]) {
                [_wkWebView goBack];
            } else {
                [_topVC.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 2:
        {
            [_topVC.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            [_wkWebView reload];
        }
            
        default:
            break;
    }
    return @1;
}

#pragma mark - 打开APP具体页面

- (id)open_page:(id)data {
//    NSLog(@"data=======>%@",data);
    ZXOpenPage *openPage = [ZXOpenPage yy_modelWithJSON:data];
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, openPage.url_schame] andUserInfo:openPage.params viewController:_topVC];
    return @1;
}

- (void)openNewPageWithVC:(UIViewController *)vc openPage:(ZXOpenPage *)openPage completionBlock:(void (^)(void))completionBlock {
    if ([[openPage type] integerValue] == 2) {
        ZXNotice *notice = [ZXNotice yy_modelWithJSON:[openPage.params valueForKey:@"query"]];
        [self openWkWithVC:vc notice:notice];
        return;
    } else {
        NSInteger page_id = [[openPage.params valueForKey:@"pageid"] integerValue];
        switch (page_id) {
            case HOME_PAGE:
            {
                [vc.navigationController popToRootViewControllerAnimated:NO];
                [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:0];
                UINavigationController *naviVC = (UINavigationController *)[[[AppDelegate sharedInstance] homeTabBarController] selectedViewController];
                if ([naviVC.topViewController isKindOfClass:[ZXNewHomeViewController class]]) {
                    ZXNewHomeViewController *homeVC = (ZXNewHomeViewController *)naviVC.topViewController;
                    [homeVC setPagerViewSelectIndexWithId:[[[openPage.params valueForKey:@"query"] valueForKey:@"id"] integerValue]];
                }
            }
                break;
            case SECOND_PAGE:
            {
                NSInteger fid = [[[openPage.params valueForKey:@"query"] valueForKey:@"fid"] integerValue];
                NSInteger cid = [[[openPage.params valueForKey:@"query"] valueForKey:@"id"] integerValue];
                NSArray *classifyList = [[NSArray alloc] initWithArray:[[ZXAppConfigHelper sharedInstance] classifyList]];
                ZXClassify *classify;
                for (ZXClassify *subClassify in classifyList) {
                    if ([subClassify.classifyId integerValue] == fid) {
                        for (ZXClassify *subCats in subClassify.subcats) {
                            if ([subCats.classifyId integerValue] == cid) {
                                classify = subCats;
                                break;
                            }
                        }
                    }
                }
                ZXSearchResultViewController *searchResult = [[ZXSearchResultViewController alloc] init];
                [searchResult setHidesBottomBarWhenPushed:YES];
                [searchResult setFromType:2];
                [searchResult setClassify:classify];
                [searchResult setTitleStr:classify.name];
                [vc.navigationController pushViewController:searchResult animated:YES];
            }
                break;
            case SORT_PAGE:
            {
                [self pushNewPageWithPageid:SORT_PAGE viewController:vc];
            }
                break;
            case SEARCH_PAGE:
            {
//                [self pushNewPageWithPageid:SEARCH_PAGE viewController:vc];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, SEARCH_VC] andUserInfo:nil viewController:vc];
            }
                break;
            case BINDTB_POPPAGE:
            {
                _tbAuthView = [[ZXTBAuthView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                __weak typeof(self) weakSelf = self;
                _tbAuthView.zxTBAuthViewBtnClick = ^(NSInteger btnTag) {
                    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.tbAuthView.containerView endRemove:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.tbAuthView removeFromSuperview];
                        weakSelf.tbAuthView = nil;
                    });
                    switch (btnTag) {
                        case 0:
                        {
                            
                        }
                            break;
                        case 1:
                        {
//                            [ZXProgressHUD loadingNoMask];
                            [UtilsMacro taobaoLogout];
                            [UtilsMacro taobaoAuthWithAuthCodeBlock:^(NSString *codeStr) {
                                [ZXProgressHUD loadingNoMask];
                                [[ZXTBAuthHelper sharedInstance] fetchTBAuthWithCode:codeStr completion:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                                    [[ZXTBAuthHelper sharedInstance] setTBAuthState:YES];
                                    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                                    [userInfo setBind_tb:@"1"];
                                    [userInfo setTb_nickname:[response.data valueForKey:@"tb_nickname"]];
                                    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                                    if (completionBlock) {
                                        completionBlock();
                                    }
                                } error:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadFailedWithMsg:response.info];
                                    return;
                                }];
                            }];
                        }
                            break;
                            
                        default:
                            break;
                    }
                };
                [[[UIApplication sharedApplication] keyWindow] addSubview:_tbAuthView];
                [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:_tbAuthView.contentView endRemove:NO];
            }
                break;
            case GOODS_DETAIL_PAGE:
            {
                ZXGoods *goods = [ZXGoods yy_modelWithJSON:[openPage.params valueForKey:@"query"]];
                ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
                [goodsDetail setGoods:goods];
                [goodsDetail setHidesBottomBarWhenPushed:YES];
                [vc.navigationController pushViewController:goodsDetail animated:YES];
            }
                break;
            case COMMUNITY_PAGE:
            {
                [vc.navigationController popToRootViewControllerAnimated:NO];
                [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:1];
            }
                break;
                break;
            case MEMBER_PAGE:
            {
                [vc.navigationController popToRootViewControllerAnimated:NO];
                [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:2];
            }
                break;
            case MY_PAGE:
            {
                [vc.navigationController popToRootViewControllerAnimated:NO];
                [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:3];
            }
                break;
            case LOGIN_PAGE:
            {
                [self presentNewPageWithPageid:LOGIN_PAGE viewController:vc];
            }
                break;
            case INVITECODE_PAGE:
            {
                [self presentNewPageWithPageid:INVITECODE_PAGE viewController:vc];
            }
                break;
            case PERSONAL_PAGE:
            {
                [self pushNewPageWithPageid:PERSONAL_PAGE viewController:vc];
            }
                break;
            case ACCOUNT_PAGE:
            {
                [self pushNewPageWithPageid:ACCOUNT_PAGE viewController:vc];
            }
                break;
            case SCORE_PAGE:
            {
                [self pushNewPageWithPageid:SCORE_PAGE viewController:vc];
            }
                break;
            case COUPON_PAGE:
            {
                [self pushNewPageWithPageid:COUPON_PAGE viewController:vc];
            }
                break;
            case ORDER_PAGE:
            {
                [self pushNewPageWithPageid:ORDER_PAGE viewController:vc];
            }
                break;
            case EARNING_PAGE:
            {
                [self pushNewPageWithPageid:EARNING_PAGE viewController:vc];
            }
                break;
            case FANS_PAGE:
            {
                [self pushNewPageWithPageid:FANS_PAGE viewController:vc];
            }
                break;
            case INVITE_PAGE:
            {
                [self pushNewPageWithPageid:INVITE_PAGE viewController:vc];
            }
                break;
            case FAVORITE_PAGE:
            {
                [self pushNewPageWithPageid:FAVORITE_PAGE viewController:vc];
            }
                break;
            case FOOTPRINT_PAGE:
            {
                [self pushNewPageWithPageid:FOOTPRINT_PAGE viewController:vc];
            }
                break;
            case RECHARGE_PAGE:
            {
                [self pushNewPageWithPageid:RECHARGE_PAGE viewController:vc];
            }
                break;
            case BALANCE_PAGE:
            {
                [self pushNewPageWithPageid:BALANCE_PAGE viewController:vc];
            }
                break;
            case MESSAGE_PAGE:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}


//present一个VC
- (void)presentNewPageWithPageid:(JSOpenPageId)pageid viewController:(UIViewController *)vc {
    NSDictionary *pageDict = @{
        [NSString stringWithFormat:@"%d", LOGIN_PAGE]: @"ZXLoginViewController",
        [NSString stringWithFormat:@"%d", INVITECODE_PAGE]: @"ZXInviteCodeViewController",
    };
    if (pageid == INVITECODE_PAGE) {
        ZXInviteCodeViewController *inviteCode = [[ZXInviteCodeViewController alloc] init];
        [inviteCode setFromType:1];
        UINavigationController *tempNavi = [[UINavigationController alloc] initWithRootViewController:inviteCode];
        [tempNavi setModalPresentationStyle:UIModalPresentationFullScreen];
        [vc presentViewController:tempNavi animated:YES completion:nil];
    } else {
        Class TempVC = NSClassFromString([pageDict valueForKey:[NSString stringWithFormat:@"%u", pageid]]);
        UIViewController *tempVC = (UIViewController *)[[TempVC alloc] init];
        UINavigationController *tempNavi = [[UINavigationController alloc] initWithRootViewController:tempVC];
        [tempNavi setModalPresentationStyle:UIModalPresentationFullScreen];
        [vc presentViewController:tempNavi animated:YES completion:nil];
    }
}

//push一个VC
- (void)pushNewPageWithPageid:(JSOpenPageId)pageid viewController:(UIViewController *)vc {
    NSDictionary *pageDict = @{
        [NSString stringWithFormat:@"%d", SORT_PAGE]: @"ZXSortViewController",
        [NSString stringWithFormat:@"%d", SEARCH_PAGE]: @"ZXSearchViewController",
        [NSString stringWithFormat:@"%d", PERSONAL_PAGE]: @"ZXPersonalViewController",
        [NSString stringWithFormat:@"%d", ACCOUNT_PAGE]: @"ZXAccountViewController",
        [NSString stringWithFormat:@"%d", SCORE_PAGE]: @"ZXScoreViewController",
        [NSString stringWithFormat:@"%d", COUPON_PAGE]: @"ZXCouponViewController",
        [NSString stringWithFormat:@"%d", ORDER_PAGE]: @"ZXOrderViewController",
        [NSString stringWithFormat:@"%d", FANS_PAGE]: @"ZXNewFansVC",
        [NSString stringWithFormat:@"%d", INVITE_PAGE]: @"ZXInviteVC",
        [NSString stringWithFormat:@"%d", FAVORITE_PAGE]: @"ZXFavoriteVC",
        [NSString stringWithFormat:@"%d", FOOTPRINT_PAGE]: @"ZXFootPrintVC",
        [NSString stringWithFormat:@"%d", RECHARGE_PAGE]: @"ZXRechargeVC",
        [NSString stringWithFormat:@"%d", BALANCE_PAGE]: @"ZXBalanceViewController",
        [NSString stringWithFormat:@"%d", MESSAGE_PAGE]: @""
    };
    Class TempVC = NSClassFromString([pageDict valueForKey:[NSString stringWithFormat:@"%u", pageid]]);
    UIViewController *tempVC = (UIViewController *)[[TempVC alloc] init];
    [tempVC setHidesBottomBarWhenPushed:YES];
    [vc.navigationController pushViewController:tempVC animated:YES];
}

#pragma mark - 打开WKWebView

- (void)openWkWithVC:(UIViewController *)vc notice:(ZXNotice *)notice {
    ZXPublicWKWebView *publicWK = [[ZXPublicWKWebView alloc] init];
    [publicWK setHidesBottomBarWhenPushed:YES];
    [publicWK setNotice:notice];
    [vc.navigationController pushViewController:publicWK animated:YES];
}

#pragma mark - 清除WKWebView缓存

- (void)remove_cache:(id)data :(JSCallback)completionHandler {
    [ZXProgressHUD loadingNoMask];
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        [ZXProgressHUD hideAllHUD];
        completionHandler(@"", YES);
    }];
}

#pragma mark - 打开扫一扫

- (void)open_scan:(id)data :(JSCallback)completionHandler {
    NSDictionary *userInfo = @{@"resultBlock": ^(NSString *scanResult) {
        completionHandler(scanResult, YES);
    }};
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SCAN_VC] andUserInfo:userInfo viewController:_topVC];
}

#pragma mark - 清除未读消息数

- (id)reset_badge:(id)data {
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[ZXAppConfigHelper sharedInstance] setAppBadge:0];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_BADGE_CHANGE object:nil];
    return @1;
}

#pragma mark - 显示隐藏按钮

- (id)display_btn:(id)data {
    if (self.zxUniversalUtilDisplayBtnBlock) {
        self.zxUniversalUtilDisplayBtnBlock(data);
    }
    return @1;
}

#pragma mark - 分享

- (void)open_share:(id)data :(JSCallback)completionHanleder {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data];
    [userInfo addEntriesFromDictionary:@{ @"shareSucceedBlock":^(void) {
        completionHanleder([UtilsMacro DataTOjsonString:@{@"status":@"1"}], YES);
    }}];
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, H5_SHARE_VC] andUserInfo:userInfo viewController:_topVC];
}

#pragma mark - 保存图片

- (id)save_img:(id)data {
    if (![UtilsMacro whetherIsEmptyWithObject:data] && [data isKindOfClass:[NSArray class]]) {
        _saveImgList = [[NSArray alloc] initWithArray:data];
        [ZXProgressHUD loadingNoMask];
        for (int i = 0; i < [_saveImgList count]; i++) {
            _currentSave = i;
            if ([[_saveImgList objectAtIndex:i] hasPrefix:@"http"]) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[_saveImgList objectAtIndex:i]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (!error) {
                        [self saveImgToAlbum:image];
                    }
                }];
            } else {
                NSData *imgData = [GTMBase64 decodeString:[_saveImgList objectAtIndex:i]];
                if (![UtilsMacro whetherIsEmptyWithObject:imgData]) {
                    [self saveImgToAlbum:[UIImage imageWithData:imgData]];
                } else {
                    [ZXProgressHUD loadSucceedWithMsg:@"保存成功"];
                }
            }
        }
    }
    return @1;
}

#pragma mark - 设置标题

- (id)set_title:(id)data {
    if (self.zxUniversalUtilSetTitleBlock) {
        self.zxUniversalUtilSetTitleBlock(data);
    }
    return @1;
}

#pragma mark - 设置状态栏和导航栏

- (id)set_navbar:(id)data {
    if (self.zxUniversalUtilSetBarBlcok) {
        self.zxUniversalUtilSetBarBlcok(data);
    }
    return @1;
}

#pragma mark - 调用系统震动

- (id)do_shake:(id)data {
    [UtilsMacro phoneShake];
    return @1;
}

#pragma mark - 获取webview参数
- (id)get_sys_params:(id)data {
    if (@available(iOS 11.0, *)) {
        return @{@"safe_top":@(STATUS_HEIGHT), @"navbar": @44.0, @"safe_bottom": @([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom)};
    } else {
        return @{@"safe_top":@(STATUS_HEIGHT), @"navbar": @44.0, @"safe_bottom": IPHONE_X ? @34.0: @0.0};
    }
}

#pragma mark - 复制文案
- (id)copy_str:(id)data {
    NSDictionary *copyObj = (NSDictionary *)data;
    [UtilsMacro generalPasteboardCopy:[copyObj valueForKey:@"txt"]];
    return @1;
}

#pragma mark - 打开小程序
- (id)launch_miniapp:(id)data {
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@",URL_PREFIX, MINIAPP_SCHEMA] andUserInfo:data viewController:_topVC];
    return @1;
}

#pragma mark - Private Methods

- (id)taobaoSecondAuth {
    _second--;
    if (_second > 0) {
        if (!_isLoading) {
            _isLoading = YES;
        }
    } else {
        [ZXProgressHUD hideAllHUD];
        _isLoading = NO;
        [_timer invalidate];
        [ZXProgressHUD loadFailedWithMsg:@"授权超时"];
    }
    return @1;
}

#pragma mark - 保存图片到系统相册

- (void)saveImgToAlbum:(UIImage *)img {
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [ZXProgressHUD loadFailedWithMsg:@"保存失败"];
        return;
    }
    if (_currentSave + 1 == [_saveImgList count]) {
        [ZXProgressHUD loadSucceedWithMsg:@"保存成功"];
    }
}

@end
