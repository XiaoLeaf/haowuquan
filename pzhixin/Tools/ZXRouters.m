//
//  ZXRouters.m
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRouters.h"

#import "ZXNewHomeViewController.h"
#import "ZXSearchViewController.h"
#import "ZXScanViewController.h"
#import "ZXSortViewController.h"
#import "ZXSearchResultViewController.h"
#import "ZXGoodsDetailVC.h"
#import "ZXShareVC.h"
#import "ZXSpecialHomeVC.h"
#import "ZXMessageVC.h"

#import "ZXCommunityHomeVC.h"

#import "ZXMemberViewController.h"

#import "ZXMyVC.h"
#import "ZXSetupViewController.h"
#import "ZXPersonalViewController.h"
#import "ZXAccountViewController.h"
#import "ZXAddressListViewController.h"
#import "ZXMyEditViewController.h"
#import "ZXAboutViewController.h"
#import "ZXBalanceViewController.h"
#import "ZXScoreViewController.h"
#import "ZXCouponViewController.h"
#import "ZXEarningViewController.h"
#import "ZXOrderViewController.h"
#import "ZXNewFansVC.h"
#import "ZXInviteVC.h"
#import "ZXRankListVC.h"
#import "ZXRechargeVC.h"
#import "ZXFavoriteVC.h"
#import "ZXFootPrintVC.h"
#import "ZXCheckOrderVC.h"
#import "ZXCheckOrderResultVC.h"

#import "ZXLoginViewController.h"
#import "ZXInviteCodeViewController.h"

@interface ZXRouters () <ZXWeChatUtilsDelegate>

@property (strong, nonatomic) UIViewController *currentVC;

@end

@implementation ZXPushObj

@end

@implementation ZXRouters

+ (ZXRouters *)sharedInstance {
    static ZXRouters *routers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (routers == nil) {
            routers = [[ZXRouters alloc] init];
        }
    });
    return routers;
}

+ (void)load {
    
#pragma mark - 首页
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_VC] toHandler:^(NSDictionary *routerParameters) {
        [[ZXRouters sharedInstance].currentVC.navigationController popToRootViewControllerAnimated:NO];
        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:0];
        UINavigationController *naviVC = (UINavigationController *)[[[AppDelegate sharedInstance] homeTabBarController] selectedViewController];
        if ([naviVC.topViewController isKindOfClass:[ZXNewHomeViewController class]]) {
            ZXNewHomeViewController *homeVC = (ZXNewHomeViewController *)naviVC.topViewController;
            [homeVC setPagerViewSelectIndexWithId:[[[routerParameters valueForKey:@"MGJRouterParameterUserInfo"] valueForKey:@"id"] integerValue]];
        }
    }];
    
#pragma mark - 搜索
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SEARCH_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXSearchViewController *search = [[ZXSearchViewController alloc] init];
        [search setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:search animated:YES];
    }];
    
#pragma mark - 扫一扫
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SCAN_VC] toHandler:^(NSDictionary *routerParameters) {
        void(^resultBlock)(NSString *scanResult);
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo] && [[[routerParameters valueForKey:MGJRouterParameterUserInfo] allKeys] containsObject:@"resultBlock"]) {
            resultBlock = [[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"resultBlock"];
        } else {
            resultBlock = nil;
        }
        ZXScanViewController *scan = [[ZXScanViewController alloc] init];
        [scan setHidesBottomBarWhenPushed:YES];
        if (resultBlock) {
            scan.zxScanVCResultBlock = ^(NSString * _Nonnull resultStr) {
                resultBlock(resultStr);
            };
        }
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:scan animated:YES];
    }];
    
#pragma mark - 分类
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SORT_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXSortViewController *sort = [[ZXSortViewController alloc] init];
        [sort setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:sort animated:YES];
    }];
    
#pragma mark - 搜索结果
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SEARCH_RESULT_VC] toHandler:^(NSDictionary *routerParameters) {
//        NSLog(@"routerParameters:%@",routerParameters);
        NSDictionary *params;
        if ([[routerParameters allKeys] containsObject:@"params"]) {
            NSString *jsonStr = [NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]];
            params = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        } else {
            if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
                params = [[NSDictionary alloc] initWithDictionary:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
            } else {
                params = @{@"keyword":@"好物券"};
            }
        }
        ZXSearchResultViewController *searchResult = [[ZXSearchResultViewController alloc] init];
        [searchResult setHidesBottomBarWhenPushed:YES];
        [searchResult setFromType:1];
        [searchResult setTitleStr:[params valueForKey:@"keyword"]];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:searchResult animated:YES];
        
        //存储搜索历史
        if (![UtilsMacro whetherIsEmptyWithObject:[params valueForKey:@"keyword"]]) {
            [[ZXDatabaseUtil sharedDataBase] insertHistory:[params valueForKey:@"keyword"]];
        }
    }];
    
#pragma mark - 二级分类页
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CATEGORY_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXSearchResultViewController *searchResult = [[ZXSearchResultViewController alloc] init];
        [searchResult setHidesBottomBarWhenPushed:YES];
        [searchResult setFromType:2];
        ZXClassify *classify;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            if ([[routerParameters valueForKey:MGJRouterParameterUserInfo] isKindOfClass:[ZXClassify class]]) {
                classify = (ZXClassify *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
            } else {
                classify = [ZXClassify yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
            }
        } else if ([[routerParameters allKeys] containsObject:@"params"]) {
            classify = [ZXClassify yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [searchResult setClassify:classify];
        [searchResult setTitleStr:classify.name];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:searchResult animated:YES];
    }];
    
#pragma mark - 商品详情
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, GOODS_DETAIL_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
        ZXGoods *goods;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            if ([[routerParameters valueForKey:MGJRouterParameterUserInfo] isKindOfClass:[ZXPushObj class]]) {
                ZXPushObj *pushObj = (ZXPushObj *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
                goods = [ZXGoods yy_modelWithJSON:pushObj.params];
            } else if ([[routerParameters valueForKey:MGJRouterParameterUserInfo] isKindOfClass:[ZXGoods class]]) {
                goods = (ZXGoods *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
            } else {
                goods = [ZXGoods yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
            }
        } else {
            goods = [ZXGoods yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [goodsDetail setGoods:goods];
        [goodsDetail setHidesBottomBarWhenPushed:YES];
        if (![UtilsMacro whetherIsEmptyWithObject:goods.pre_slide]) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:goods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {} completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {}];
        }
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:goodsDetail animated:YES];
    }];
    
#pragma mark - 消息
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, MESSGAE_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXMessageVC *message = [[ZXMessageVC alloc] init];
        [message setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:message animated:YES];
    }];
    
#pragma mark - 创建分享
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CREATE_SHARE_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXShareVC *shareVC = [[ZXShareVC alloc] init];
        ZXGoodsDetail *goodsDetail;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            if ([[routerParameters valueForKey:MGJRouterParameterUserInfo] isKindOfClass:[ZXGoodsDetail class]]) {
                goodsDetail = (ZXGoodsDetail *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
            } else {
                goodsDetail = [ZXGoodsDetail yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
            }
        } else if ([[routerParameters allKeys] containsObject:@"params"]) {
            goodsDetail = [ZXGoodsDetail yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [shareVC setIdStr:goodsDetail.row.itemId];
        [shareVC setItem_id:goodsDetail.row.taobaoId];
        [shareVC setHidesBottomBarWhenPushed:YES];
        [[[[ZXRouters sharedInstance] currentVC] navigationController] pushViewController:shareVC animated:YES];
    }];
    
#pragma mark - 专题页
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SUBJECT_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXSpecialHomeVC *specialHome = [[ZXSpecialHomeVC alloc] init];
        ZXSubjectParam *subjectParam ;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            ZXPushObj *pushObj = (ZXPushObj *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
            subjectParam = [ZXSubjectParam yy_modelWithJSON:pushObj.params];
        } else {
            subjectParam = [ZXSubjectParam yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [specialHome setHidesBottomBarWhenPushed:YES];
        [specialHome setSid:subjectParam.sid];
        [[[[ZXRouters sharedInstance] currentVC] navigationController] pushViewController:specialHome animated:YES];
    }];
    
#pragma mark - 社区
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, COMMUNITY_VC] toHandler:^(NSDictionary *routerParameters) {
        [[ZXRouters sharedInstance].currentVC.navigationController popToRootViewControllerAnimated:NO];
        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:1];
        UINavigationController *naviVC = (UINavigationController *)[[[AppDelegate sharedInstance] homeTabBarController] selectedViewController];
        if ([naviVC.topViewController isKindOfClass:[ZXCommunityHomeVC class]]) {
            ZXCommunityHomeVC *communityVC = (ZXCommunityHomeVC *)naviVC.topViewController;
            if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
                [communityVC setFid:[NSString stringWithFormat:@"%@",[[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"fid"]]];
                [communityVC setCid:[NSString stringWithFormat:@"%@",[[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"cid"]]];
            } else if([[routerParameters allKeys] containsObject:@"params"]) {
                NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[[routerParameters valueForKey:@"params"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [communityVC setFid:[NSString stringWithFormat:@"%@",[params valueForKey:@"fid"]]];
                [communityVC setCid:[NSString stringWithFormat:@"%@",[params valueForKey:@"cid"]]];
            }
        }
    }];
    
#pragma mark - 会员
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, MEMBER_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            [login setTabIndex:2];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        [[ZXRouters sharedInstance].currentVC.navigationController popToRootViewControllerAnimated:NO];
        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:2];
    }];
    
#pragma mark - 我的
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, MY_VC] toHandler:^(NSDictionary *routerParameters) {
        [[ZXRouters sharedInstance].currentVC.navigationController popToRootViewControllerAnimated:NO];
        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:3];
    }];
    
#pragma mark - 登录
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
        [login setTabIndex:[[AppDelegate sharedInstance] homeTabBarController].selectedIndex];
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
        [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
        [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
    }];
    
#pragma mark - 绑定邀请人
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, INVITE_CODE_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXInviteCodeViewController *inviteCode = [[ZXInviteCodeViewController alloc] init];
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            [inviteCode setFromType:[[routerParameters valueForKey:MGJRouterParameterUserInfo] integerValue]];
            [[ZXRouters sharedInstance].currentVC.navigationController pushViewController:inviteCode animated:YES];
        } else {
            [inviteCode setFromType:1];
            UINavigationController *tempNavi = [[UINavigationController alloc] initWithRootViewController:inviteCode];
            [tempNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:tempNavi animated:YES completion:nil];
        }
//        NSLog(@"inviteCode====>viewControllers:%@",[ZXRouters sharedInstance].currentVC.navigationController.viewControllers);
    }];
    
#pragma mark - 设置
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SETTING_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXSetupViewController *setup = [[ZXSetupViewController alloc] init];
        [setup setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:setup animated:YES];
    }];
    
#pragma mark - 个人资料
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, PERSONAL_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXPersonalViewController *personal = [[ZXPersonalViewController alloc] init];
        [personal setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:personal animated:YES];
    }];
    
#pragma mark - 账户与安全
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ACCOUNT_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXAccountViewController *account = [[ZXAccountViewController alloc] init];
        [account setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:account animated:YES];
    }];
    
#pragma mark - 我的地址
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ADDRESS_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXAddressListViewController *address = [[ZXAddressListViewController alloc] init];
        [address setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:address animated:YES];
    }];
    
#pragma mark - 意见反馈
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, @""] toHandler:^(NSDictionary *routerParameters) {
        
    }];
    
#pragma mark - 关于我们
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ABOUT_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXAboutViewController *about = [[ZXAboutViewController alloc] init];
        [about setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:about animated:YES];
    }];
    
#pragma mark - 余额
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, BALANCE_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXBalanceViewController *balance = [[ZXBalanceViewController alloc] init];
        [balance setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:balance animated:YES];
    }];
    
#pragma mark - 积分
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SCORE_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXScoreViewController *score = [[ZXScoreViewController alloc] init];
        [score setHidesBottomBarWhenPushed:YES];
        ZXScorePop *scorePop;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            ZXPushObj *pushObj = (ZXPushObj *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
            scorePop = [ZXScorePop yy_modelWithJSON:pushObj.params];
        } else {
//            NSLog(@"params:%@",[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]);
            scorePop = [ZXScorePop yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [score setScorePop:scorePop];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:score animated:YES];
    }];
    
#pragma mark - 优惠券
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, COUPON_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXCouponViewController *coupon = [[ZXCouponViewController alloc] init];
        [coupon setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:coupon animated:YES];
    }];
    
#pragma mark - 订单
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ORDER_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXOrderViewController *order = [[ZXOrderViewController alloc] init];
        [order setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:order animated:YES];
    }];
        
#pragma mark - 我的收益
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, PROFIT_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXEarningViewController *earning = [[ZXEarningViewController alloc] init];
        [earning setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:earning animated:YES];
    }];
    
#pragma mark - 粉丝
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, FANS_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXNewFansVC *fans = [[ZXNewFansVC alloc] init];
        [fans setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:fans animated:YES];
    }];
    
#pragma mark - 邀请
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, INVITE_VC] toHandler:^(NSDictionary *routerParameters) {
        if ([[[[ZXMyHelper sharedInstance] userInfo] is_bind] integerValue] == 2) {
            [ZXProgressHUD loadFailedWithMsg:@"请先绑定邀请人"];
            return;
        }
        ZXInviteVC *invite = [[ZXInviteVC alloc] init];
        [invite setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:invite animated:YES];
    }];
    
#pragma mark - 排行榜
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, RANKING_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXRankListVC *ranking = [[ZXRankListVC alloc] init];
        [ranking setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:ranking animated:YES];
    }];
    
#pragma mark - 话费充值
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, PHONE_RECHARGE_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXRechargeVC *recharge = [[ZXRechargeVC alloc] init];
        [recharge setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:recharge animated:YES];
    }];
    
#pragma mark - 收藏夹
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, FAV_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXFavoriteVC *favorite = [[ZXFavoriteVC alloc] init];
        [favorite setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:favorite animated:YES];
    }];
    
#pragma mark - 足迹
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, FOOTPRINT_VC] toHandler:^(NSDictionary *routerParameters) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
            return;
        }
        ZXFootPrintVC *footprint = [[ZXFootPrintVC alloc] init];
        [footprint setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:footprint animated:YES];
    }];
    
#pragma mark - 订单查询
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CHECK_ORDER_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXCheckOrderVC *checkOrder = [[ZXCheckOrderVC alloc] init];
        [checkOrder setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:checkOrder animated:YES];
    }];
    
    //订单查询结果
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CHECK_ORDER_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXCheckOrderResultVC *checkResult = [[ZXCheckOrderResultVC alloc] init];
        [checkResult setHidesBottomBarWhenPushed:YES];
        [[[ZXRouters sharedInstance].currentVC navigationController] pushViewController:checkResult animated:YES];
    }];
    
#pragma mark - ZXPublicWkWebView
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, WEBVIEW_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXNotice *notice;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            if ([[routerParameters valueForKey:MGJRouterParameterUserInfo] isKindOfClass:[ZXPushObj class]]) {
                ZXPushObj *pushObj = (ZXPushObj *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
                notice = [ZXNotice yy_modelWithJSON:pushObj.params];
            } else if ([[routerParameters valueForKey:MGJRouterParameterUserInfo] isKindOfClass:[NSDictionary class]]) {
                notice = [ZXNotice yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
            }
        } else if ([[routerParameters allKeys] containsObject:@"params"]) {
            notice = [ZXNotice yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [[ZXUniversalUtil sharedInstance] openWkWithVC:[ZXRouters sharedInstance].currentVC notice:notice];
    }];
    
#pragma mark - 弹窗类
    
#pragma mark - 首页红包弹窗
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_ENVELOP_POP] toHandler:^(NSDictionary *routerParameters) {
        [UtilsMacro phoneShake];
        ZXRedEnvelop *redEnvelop;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            ZXPushObj *pushObj = (ZXPushObj *)[routerParameters valueForKey:MGJRouterParameterUserInfo];
            redEnvelop = [ZXRedEnvelop yy_modelWithJSON:pushObj.params];
        } else {
            redEnvelop = [ZXRedEnvelop yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        ZXRedEnvelopView *redEnvelopView = [[ZXRedEnvelopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        __weak ZXRedEnvelopView *weakRed = redEnvelopView;
        [redEnvelopView setRedEnvelop:redEnvelop];
        redEnvelopView.zxRedEnvelopViewBtnClick = ^(NSInteger btnTag) {
            __strong ZXRedEnvelopView *strongRed = weakRed;
            switch (btnTag) {
                case 0:
                case 999:
                {
                    [self executeRedEnvelopViewActionWitRedEnvelop:redEnvelop andRedEnvelopView:strongRed];
                }
                    break;

                default:
                {
                    [self removeRedEnvelopView:strongRed];
                }
                    break;
            }
        };
        [[ZXRouters sharedInstance].currentVC.view addSubview:redEnvelopView];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:redEnvelopView.containerView endRemove:NO];
    }];
    
#pragma mark - 首页Toast弹窗
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_TOAST_POP] toHandler:^(NSDictionary *routerParameters) {
        [self removeHomeToastAndHomeSearch];
        [UtilsMacro phoneShake];
        ZXCommonSearch *commonSearch;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            commonSearch = (ZXCommonSearch *)[[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"commonSearch"];
        } else {
            commonSearch = [ZXCommonSearch yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        void(^closeBlock)(void);
        if ([[[routerParameters valueForKey:MGJRouterParameterUserInfo] allKeys] containsObject:@"closeBlock"]) {
            closeBlock = [[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"closeBlock"];
        } else {
            closeBlock = nil;
        }
        ZXHomeToast *homeToast = [[ZXHomeToast alloc] initWithFrame:[UIScreen mainScreen].bounds];
        __weak ZXHomeToast *weakToast = homeToast;
        homeToast.zxHomeToastBtnClick = ^(NSInteger btnTag) {
            __strong ZXHomeToast *strongToast = weakToast;
            [self removeHomeToast:strongToast];
            switch (btnTag) {
                case 0:
                {
                    ZXSearchResultViewController *searchResult = [[ZXSearchResultViewController alloc] init];
                    [searchResult setHidesBottomBarWhenPushed:YES];
                    [searchResult setFromType:1];
                    [searchResult setTitleStr:commonSearch.title];
                    [[ZXRouters sharedInstance].currentVC.navigationController pushViewController:searchResult animated:YES];
                    
                    //存储搜索历史
                    if (![UtilsMacro whetherIsEmptyWithObject:commonSearch.title]) {
                        [[ZXDatabaseUtil sharedDataBase] insertHistory:commonSearch.title];
                    }
                }
                    break;
                case 1:
                {
                    NSDictionary *goodsInfo = @{@"id":commonSearch.goods_id, @"item_id":commonSearch.item_id, @"pre_slide":commonSearch.pre_slide};
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, GOODS_DETAIL_VC] andUserInfo:goodsInfo viewController:[ZXRouters sharedInstance].currentVC];
                }
                    break;
                case 2:
                {
                    if (closeBlock) {
                        closeBlock();
                    }
                }
                    
                default:
                    break;
            }
            
        };
        [homeToast setCommonSearch:commonSearch];
        [[[UIApplication sharedApplication] keyWindow] addSubview:homeToast];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:homeToast.containerView endRemove:NO];
    }];
    
#pragma mark - 首页搜索弹窗
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_SEARCH_POP] toHandler:^(NSDictionary *routerParameters) {
        [self removeHomeToastAndHomeSearch];
        [UtilsMacro phoneShake];
        ZXCommonSearch *commonSearch;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            commonSearch = (ZXCommonSearch *)[[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"commonSearch"];
        } else {
            commonSearch = [ZXCommonSearch yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        void(^closeBlock)(void);
        if ([[[routerParameters valueForKey:MGJRouterParameterUserInfo] allKeys] containsObject:@"closeBlock"]) {
            closeBlock = [[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"closeBlock"];
        } else {
            closeBlock = nil;
        }
        ZXHomeSearch *homeSearch = [[ZXHomeSearch alloc] initWithFrame:[UIScreen mainScreen].bounds];
        __weak ZXHomeSearch *weakSearch = homeSearch;
        homeSearch.zxHomeSearchBtnClick = ^(NSInteger btnTag) {
            __strong ZXHomeSearch *strongSearch = weakSearch;
            [self removeHomeSearchView:strongSearch];
            switch (btnTag) {
                case 0:
                {
                    NSDictionary *params = @{@"keyword":commonSearch.title};
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SEARCH_RESULT_VC] andUserInfo:params viewController:[ZXRouters sharedInstance].currentVC];
                }
                    break;
                case 1:
                {
                    if (closeBlock) {
                        closeBlock();
                    }
                }
                    break;
                    
                default:
                    break;
            }
        };
        [homeSearch setCommonSearch:commonSearch];
        [[[UIApplication sharedApplication] keyWindow] addSubview:homeSearch];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:homeSearch.containerView endRemove:NO];
    }];
    
#pragma mark - 首页商品弹窗
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_GOODS_POP] toHandler:^(NSDictionary *routerParameters) {
        
    }];
    
#pragma mark - 跳转淘宝弹窗
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, JUMP_TAOBAO_POP] toHandler:^(NSDictionary *routerParameters) {
        
    }];
    
#pragma mark - 绑定淘宝弹窗
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, BIND_TBPOPVIEW] toHandler:^(NSDictionary *routerParameters) {
        [UtilsMacro openTBAuthViewWithVC:[ZXRouters sharedInstance].currentVC completion:^{}];
    }];
    
#pragma mark - 通用分享
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, COMMON_SHARE_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXCommonShare *commonShare;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            commonShare = [ZXCommonShare yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
        } else {
            commonShare = [ZXCommonShare yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        ZXCommonShareVC *shareVC = [[ZXCommonShareVC alloc] init];
        [shareVC setProvidesPresentationContextTransitionStyle:YES];
        [shareVC setDefinesPresentationContext:YES];
        [shareVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [shareVC setCommonShare:commonShare];
        [[ZXRouters sharedInstance].currentVC presentViewController:shareVC animated:YES completion:nil];
    }];
    
#pragma mark - 打开小程序
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, MINIAPP_SCHEMA] toHandler:^(NSDictionary *routerParameters) {
//        ZXMiniApp *miniApp = [ZXMiniApp yy_modelWithJSON:@{@"originalId": @"gh_924843f766f6", @"path": @"pages/launch/index?id=Leaf"}];
        ZXMiniApp *miniApp;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            NSLog(@"userInfo====>%@",[routerParameters valueForKey:MGJRouterParameterUserInfo]);
            miniApp = [ZXMiniApp yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
        } else {
            miniApp = [ZXMiniApp yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [[ZXWeChatUtils sharedInstance] openWechatMiniAppWithApp:miniApp delegate:[ZXRouters sharedInstance]];
    }];
    
#pragma mark - 打开淘宝
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, TAOBAO_SCHEMA] toHandler:^(NSDictionary *routerParameters) {
        ZXTaoBao *taobao;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            taobao = [ZXTaoBao yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
        } else {
            taobao = [ZXTaoBao yy_modelWithJSON:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
        showParam.openType = AlibcOpenTypeAuto;
        showParam.isNeedPush = YES;
        showParam.nativeFailMode = AlibcNativeFailModeJumpH5;
        showParam.degradeUrl = @"";
        showParam.isNeedCustomNativeFailMode = NO;
        [[[AlibcTradeSDK sharedInstance] tradeService] openByUrl:taobao.url identity:@"trade" webView:nil parentController:[ZXRouters sharedInstance].currentVC showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
            
        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
            
        }];
    }];
    
#pragma mark - Toast
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HUD_VC] toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *toastObj;
        if ([[routerParameters allKeys] containsObject:MGJRouterParameterUserInfo]) {
            toastObj = [[NSDictionary alloc] initWithDictionary:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
        } else {
            toastObj = [[NSDictionary alloc] initWithDictionary:[self jsonStr2Dictionary:[NSString stringWithFormat:@"%@",[routerParameters valueForKey:@"params"]]]];
        }
        [ZXProgressHUD loadSucceedWithMsg:[toastObj valueForKey:@"msg"]];
    }];
    
#pragma mark - 激励广告
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, REWARD_AD_SCHEMD] toHandler:^(NSDictionary *routerParameters) {
        switch ([UtilsMacro fetchCurrentSecondSingleDigit] % (BU_AD_PLATFORM + 1)) {
            case TENCENT_AD_PLATFORM:
            {
                [[ZXAdHelper sharedInstance] fetchTencentRewardAdWithDelegate:[ZXRouters sharedInstance].currentVC loadSucceedBlock:^{
                    [[ZXAdHelper sharedInstance] playTencentRewardAdVideo];
                }];
            }
                break;
            case BU_AD_PLATFORM:
            {
                [[ZXAdHelper sharedInstance] fetchBURewardAdWithDelegate:[ZXRouters sharedInstance].currentVC loadSucceedBlock:^{
                    [[ZXAdHelper sharedInstance] playBURewardAdVideo];
                }];
            }
                break;
                
            default:
                break;
        }
    }];
    
#pragma mark - H5分享
    [MGJRouter registerURLPattern:[NSString stringWithFormat:@"%@%@", URL_PREFIX, H5_SHARE_VC] toHandler:^(NSDictionary *routerParameters) {
        ZXH5ShareVC *shareVC = [[ZXH5ShareVC alloc] init];
        [shareVC setProvidesPresentationContextTransitionStyle:YES];
        [shareVC setDefinesPresentationContext:YES];
        [shareVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        ZXH5Share *h5Share = [ZXH5Share yy_modelWithJSON:[routerParameters valueForKey:MGJRouterParameterUserInfo]];
        void(^shareSucceedBlock)(void);
        if ([[[routerParameters valueForKey:MGJRouterParameterUserInfo] allKeys] containsObject:@"shareSucceedBlock"]) {
            shareSucceedBlock = [[routerParameters valueForKey:MGJRouterParameterUserInfo] valueForKey:@"shareSucceedBlock"];
        } else {
            shareSucceedBlock = nil;
        }
        shareVC.zxH5ShareVCShareSucceed = ^{
            if (shareSucceedBlock) {
                shareSucceedBlock();
            }
        };
        [shareVC setH5Share:h5Share];
        [[ZXRouters sharedInstance].currentVC presentViewController:shareVC animated:YES completion:nil];
    }];
    
}

#pragma mark - Public Methods

- (void)openPageWithUrl:(NSString *)pageUrl andUserInfo:(id _Nullable)userInfo viewController:(UIViewController *)vc {
    _currentVC = vc;
    [MGJRouter openURL:pageUrl withUserInfo:userInfo completion:nil];
}

#pragma mark - 红包弹窗的点击事件

//移除HomeToast
+ (void)removeHomeToast:(ZXHomeToast *)homeToast {
    __block ZXHomeToast *subHomeToast = homeToast;
    [subHomeToast setBackgroundColor:[UIColor clearColor]];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:subHomeToast.containerView endRemove:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subHomeToast removeFromSuperview];
        subHomeToast = nil;
    });
}

//移除搜索弹窗
+ (void)removeHomeSearchView:(ZXHomeSearch *)homeSearch {
    __block ZXHomeSearch *subHomeSearch = homeSearch;
    [subHomeSearch setBackgroundColor:[UIColor clearColor]];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:subHomeSearch.containerView endRemove:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subHomeSearch removeFromSuperview];
        subHomeSearch = nil;
    });
}

//移除红包弹窗
+ (void)removeRedEnvelopView:(ZXRedEnvelopView *)redEnvelopView {
    __block ZXRedEnvelopView *subRedEnvelopView = redEnvelopView;
    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:subRedEnvelopView.containerView endRemove:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subRedEnvelopView removeFromSuperview];
        subRedEnvelopView = nil;
    });
}

+ (void)executeRedEnvelopViewActionWitRedEnvelop:(ZXRedEnvelop *)redEnvelop andRedEnvelopView:(ZXRedEnvelopView *)redEnvelopView {
    switch ([redEnvelop.need integerValue]) {
        case 1:
        {
            if ([[ZXLoginHelper sharedInstance] loginState]) {
                [self executeMethodWithRedEnvelop:redEnvelop andRedEnvelopView:redEnvelopView];
            } else {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:[ZXRouters sharedInstance].currentVC];
            }
        }
            break;
        case 2:
        {
            if (![[ZXLoginHelper sharedInstance] loginState]) {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:[ZXRouters sharedInstance].currentVC];
                return;
            }
            if (![[ZXTBAuthHelper sharedInstance] tbAuthState]) {
                [UtilsMacro openTBAuthViewWithVC:[ZXRouters sharedInstance].currentVC completion:^{}];
                return;
            }
            [self executeMethodWithRedEnvelop:redEnvelop andRedEnvelopView:redEnvelopView];
        }
            break;
        case 0:
        {
            [self removeRedEnvelopView:redEnvelopView];
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, redEnvelop.url_schema] andUserInfo:nil viewController:[ZXRouters sharedInstance].currentVC];
        }
            
        default:
            break;
    }
}

+ (void)executeMethodWithRedEnvelop:(ZXRedEnvelop *)redEnvelop andRedEnvelopView:(ZXRedEnvelopView *)redEnvelopView {
    switch ([redEnvelop.type integerValue]) {
        case 1:
        {
            [self removeRedEnvelopView:redEnvelopView];
            [self fetchGetGiftWithRedEnvelop:redEnvelop];
        }
            break;
        case 2:
        case 3:
        {
            [self removeRedEnvelopView:redEnvelopView];
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, redEnvelop.url_schema] andUserInfo:nil viewController:[ZXRouters sharedInstance].currentVC];
        }
            break;
            
        default:
            break;
    }
}

+ (void)fetchGetGiftWithRedEnvelop:(ZXRedEnvelop *)redEnvelop {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXGetGiftHelper sharedInstance] fetchGetGiftWithId:redEnvelop.red_id
                                                  Completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            ZXRedEnvelop *tempRedEnvelop = [ZXRedEnvelop yy_modelWithJSON:response.data];
            ZXRedEnvelopView *redEnvelopView = [[ZXRedEnvelopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            __weak ZXRedEnvelopView *weakRed = redEnvelopView;
            [redEnvelopView setRedEnvelop:tempRedEnvelop];
            redEnvelopView.zxRedEnvelopViewBtnClick = ^(NSInteger btnTag) {
                __strong ZXRedEnvelopView *strongRed = weakRed;
                [self removeRedEnvelopView:strongRed];
                switch (btnTag) {
                    case 0:
                    case 999:
                    {
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, tempRedEnvelop.url_schema] andUserInfo:nil viewController:[ZXRouters sharedInstance].currentVC];
                    }
                        break;
                        
                    default:
                    {
                        [self removeRedEnvelopView:strongRed];
                    }
                        break;
                }
            };
            [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:redEnvelopView.containerView endRemove:NO];
            [[ZXRouters sharedInstance].currentVC.view addSubview:redEnvelopView];
        } error:^(ZXResponse * _Nonnull response) {
            if (response.status == 201) {
                ZXLoginViewController *login = [[ZXLoginViewController alloc] init];
                UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:login];
                [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                [[ZXRouters sharedInstance].currentVC presentViewController:loginNavi animated:YES completion:nil];
                return;
            }
            if (response.status == 202) {
                [UtilsMacro openTBAuthViewWithVC:[ZXRouters sharedInstance].currentVC completion:^{}];
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

#pragma mark - Private Methods

+ (void)removeHomeToastAndHomeSearch {
    for (UIView *subView in [[UIApplication sharedApplication] keyWindow].subviews) {
        if ([subView isKindOfClass:[ZXHomeToast class]] || [subView isKindOfClass:[ZXHomeSearch class]]) {
            [subView removeFromSuperview];
        }
    }
}

+ (NSDictionary *)jsonStr2Dictionary:(NSString *)jsonStr {
    return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatMiniAppCallBack:(NSString *)extMsg {
    NSLog(@"extMsg:%@",extMsg);
}

@end
