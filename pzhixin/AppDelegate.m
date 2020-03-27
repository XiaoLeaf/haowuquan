//
//  AppDelegate.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "AppDelegate.h"
#import "AppMacro.h"
#import "ZXNewHomeViewController.h"
#import "ZXLoginViewController.h"
#import "ZXWelfareViewController.h"
#import "ZXMemberViewController.h"
#import "ZXMyVC.h"
#import "ZXCommunityHomeVC.h"
#import "ZXGuideViewController.h"
#import "UITabBar+EX.h"
#import "ZXSetupViewController.h"
#import "ZXSearchResultViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "ZXMenu.h"
#import <Masonry/Masonry.h>
#import "ZXSplashRootVC.h"
//#import <UserNotifications/UserNotifications.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UITabBarControllerDelegate, JPUSHRegisterDelegate, UIGestureRecognizerDelegate, GDTSplashAdDelegate, BUSplashAdDelegate> {
    ZXNewHomeViewController *home;
    UINavigationController *homeNavi;
    ZXCommunityHomeVC *community;
    UINavigationController *communityNavi;
    ZXWelfareViewController *welfare;
    UINavigationController *welfareNavi;
    ZXMemberViewController *member;
    UINavigationController *memberNavi;
    ZXMyVC *my;
    UINavigationController *myNavi;
}

@property (strong, nonatomic) ZXHomeSearch *homeSearch;

@property (strong, nonatomic) ZXHomeToast *homeToast;

@property (strong, nonatomic) NSString *pasteStr;

@property (assign, nonatomic) NSInteger lastIndex;

@property (strong, nonatomic) GDTSplashAd *splashAd;

@property (strong, nonatomic) BUSplashAdView *splashAdView;

@property (strong, nonatomic) UIView *adBottomView;

@property (assign, nonatomic) BOOL isHomeTabRoot;

@property (assign, nonatomic) BOOL showingAd;

@property (strong, nonatomic) dispatch_semaphore_t adSema;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //穿山甲广告全局配置
    [BUAdSDKManager setAppID:BUADAppID];
    [BUAdSDKManager setIsPaidApp:NO];
    
    //消息角标相关
    [[ZXAppConfigHelper sharedInstance] setAppBadge:application.applicationIconBadgeNumber];
    [self zxFindNotification];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_BADGE_CHANGE object:nil];
    
    //webp
    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:webPCoder];
    
    //TABAnimate初始化
    [[TABAnimated sharedAnimated] initWithOnlySkeleton];
    [[TABAnimated sharedAnimated] setCloseCache:YES];
//    [[TABAnimated sharedAnimated] setOpenAnimationTag:YES];
//    [[TABAnimated sharedAnimated] setOpenLog:YES];
//    [[TABAnimatedBall shared] install];
    
    //错误信息捕捉
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //添加系统粘贴板改变监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(generalPasteboardChaneged:) name:UIPasteboardChangedNotification object:nil];
    
    //微信APPID注册
    [WXApi registerApp:@"wxa244ffcb53c7b9e6" universalLink:@"https://pzhixin.qieweb.com/"];
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
        NSLog(@"微信log:%@",log);
    }];
    
    //Bugly集成
    [Bugly startWithAppId:@"e203735a81"];
    
//    腾讯IM集成
//    [[TUIKit sharedInstance] setupWithAppId:1400250885];
    
    //极光推送
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        [entity setTypes:JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings];
    } else {
        // Fallback on earlier versions
        [entity setTypes:JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound];
    }
    [JPUSHService setLogOFF];
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"b375304d598313ffb8495320" channel:@"App Store" apsForProduction:NO];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        NSLog(@"resCode:%d  registrationID:%@", resCode, registrationID);
        if (resCode == 0) {
            [[ZXAppConfigHelper sharedInstance] setRegistrationID:registrationID];
        }
    }];
//    NSDictionary *remoterNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSLog(@"remoterNotification===>%@",remoterNotification);

    //阿里百川初始化
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
    //Debug模式下日志开关
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
//        NSLog(@"阿里百川初始化成功");
    } failure:^(NSError *error) {
        NSLog(@"Init Failed :%@", error.description);
    }];
    
    //IQ键盘管理
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //APP初始化 && 信号量阻塞等待APP初始化接口请求完毕
    [self initAppConfiguration];
    
    //初始化homeTabBarController
    [self loginSucceed];
    
    //开屏广告的展示
    [self showSplashAd];

    [self.window setBackgroundColor:BG_COLOR];
    
//    //判断是否已展示过引导页
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:[   NSString stringWithFormat:@"%@Logined",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]]) {
//        [self loginSucceed];
//    } else {
//        ZXGuideViewController *guide = [[ZXGuideViewController alloc] init];
//        [self.window setRootViewController:guide];
//    }
    return YES;
}

- (void)methodWithBlock:(void (^)(id result))block {
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    TIMBackgroundParam *param = [[TIMBackgroundParam alloc] init];
//    [[TIMManager sharedInstance] doBackground:param succ:^{
//        NSLog(@"======上报进入后台成功=========");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"======上报进入后台失败========= code====>%d  msg====>%@",code, msg);
//    }];
    
    //保存当前时间戳，用于判断是否需要展示开屏广告
    [UtilsMacro saveEnterBackgroundTimeStamp];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [[TIMManager sharedInstance] doForeground:^{
//        NSLog(@"======上报进入前台成功=========");
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"======上报进入前台失败=========  code=====>%d  msg=====>%@",code, msg);
//    }];
    [[ZXAppConfigHelper sharedInstance] setAppBadge:application.applicationIconBadgeNumber];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_BADGE_CHANGE object:nil];
    
    //对比时间是否需要展示开屏广告
    if ([UtilsMacro checkWhetherNeedSplashAd]) {
        [self showSplashAd];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_showingAd) {
        return;
    }
    [self checkGeneralPasteBoard];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //weChatUtil初始化
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:@"wxa244ffcb53c7b9e6"].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:[ZXWeChatUtils sharedInstance]];
    }
    if (![[AlibcTradeSDK sharedInstance] application:app openURL:url options:options]) {
        return YES;
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.deviceToken = deviceToken;
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:[ZXWeChatUtils sharedInstance]];
}

#pragma mark - Private Methods

- (void)checkGeneralPasteBoard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (![UtilsMacro whetherIsEmptyWithObject:pasteboard.string]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //取出存储changeCount的值，与当前作对比，不一致则发生了变化，就弹窗
        NSInteger changeCount = [userDefaults integerForKey:@"changecount"];
        if (changeCount != pasteboard.changeCount) {
            self.pasteStr = pasteboard.string;
            if ([UtilsMacro isCanReachableNetWork]) {
                [[ZXSearchHelper sharedInstance] fetchSearchGoodsWithContent:self.pasteStr andFrom:[NSString stringWithFormat:@"%d",FROM_PASTEBOARD] completion:^(ZXResponse * _Nonnull response) {
                    ZXCommonSearch *commonSearch = [ZXCommonSearch yy_modelWithJSON:response.data];
                    NSDictionary *userInfo = @{@"commonSearch":commonSearch};
                    switch (commonSearch.type) {
                        case 1:
                        {
                            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_TOAST_POP] andUserInfo:userInfo viewController:[UtilsMacro topViewController]];
                        }
                            break;
                        case 2:
                        {
                            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_SEARCH_POP] andUserInfo:userInfo viewController:[UtilsMacro topViewController]];
                        }
                            break;
                            
                        default:
                            break;
                    }
                } error:^(ZXResponse * _Nonnull response) {
                    
                }];
            }
            [pasteboard setString:@""];
            //再次存储changeCount的数量
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:pasteboard.changeCount forKey:@"changecount"];
            [userDefaults synchronize];
        }
    }
}

//App初始化配置信息
- (void)initAppConfiguration {
    //信号量阻塞等待APP初始化接口请求完毕
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ZXAppConfigHelper sharedInstance] fetchAPPConfigCompletion:^(ZXResponse * _Nonnull response) {
//            NSLog(@"response:%@",response.data);
            ZXAppConfig *appConfig = [ZXAppConfig yy_modelWithJSON:response.data];
            [[ZXAppConfigHelper sharedInstance] setAppConfig:appConfig];

            //保存loading资源图片及预加载
            [UtilsMacro preloadLoadingAssetsWithLoadingAsset:[[[ZXAppConfigHelper sharedInstance] appConfig] img_res]];
//            [[ZXAppConfigHelper sharedInstance] setLoadingAsset:[[[ZXAppConfigHelper sharedInstance] appConfig] img_res]];
            dispatch_semaphore_signal(sema);
        } error:^(ZXResponse * _Nonnull response) {
//            [self initAppConfiguration];
            dispatch_semaphore_signal(sema);
            return;
        }];
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

//开屏广告的展示
- (void)showSplashAd {
    if ([self whetherShowDealPopView]) {
        return;
    }
    switch ([UtilsMacro fetchCurrentSecondSingleDigit] % (BU_AD_PLATFORM + 1)) {
        case TENCENT_AD_PLATFORM:
        {
            _showingAd = YES;
            [self fetchSplashAd];
        }
            break;
        case BU_AD_PLATFORM:
        {
            _showingAd = YES;
            [self fetchBuSplashAd];
        }
            break;

        default:
            break;
    }
}

- (BOOL)whetherShowDealPopView {
    BOOL result = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([UtilsMacro whetherIsEmptyWithObject:[userDefaults valueForKey:@"AGREEMENT"]]) {
        result = YES;
    } else {
        result = ![userDefaults boolForKey:@"AGREEMENT"];
    }
    return result;
}

//腾讯开屏广告
- (void)fetchSplashAd {
    _splashAd = [[GDTSplashAd alloc] initWithAppId:TencentAppID placementId:TencentSplash];
    _splashAd.delegate = self;
    _splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start_bg.png"]];
    _splashAd.fetchDelay = 3;
    
    //拉取并展示全屏开屏广告
//    [_splashAd loadAdAndShowInWindow:self.window];
    
    //设置开屏底部自定义logovView，展示半屏开屏广告
    _adBottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 87.0)];
    _adBottomView.backgroundColor = [UIColor whiteColor];
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_logo.png"]];
    [logoImg setContentMode:UIViewContentModeScaleAspectFill];
    [_adBottomView addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.adBottomView);
        make.bottom.mas_equalTo(-37.0);
        make.width.mas_equalTo(120.0);
        make.height.mas_equalTo(40.0);
    }];
    [_splashAd loadAdAndShowInWindow:self.window withBottomView:_adBottomView];
}

//穿山甲开屏广告
- (void)fetchBuSplashAd {
    _splashAdView = [[BUSplashAdView alloc] initWithSlotID:BUADSplash frame:[UIScreen mainScreen].bounds];
    _splashAdView.delegate = self;
    [_splashAdView loadAdData];
    [self.window.rootViewController.view addSubview:_splashAdView];
    _splashAdView.rootViewController = self.window.rootViewController;
}

#pragma mark - Public Methods

+ (AppDelegate *)sharedInstance {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]);
}

- (void)loginSucceed {
    self.homeTabBarController = nil;
    if (self.homeTabBarController == nil) {
        
        home = [[ZXNewHomeViewController alloc] init];
        [home.tabBarItem setTitle:@"首页"];
        [home.tabBarItem setImage:[[UIImage imageNamed:@"tab_home_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [home.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [home.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -3.0)];
        homeNavi = [[UINavigationController alloc] initWithRootViewController:home];
        
        community = [[ZXCommunityHomeVC alloc] init];
        [community.tabBarItem setTitle:@"社区"];
        [community.tabBarItem setImage:[[UIImage imageNamed:@"tab_community_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [community.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_community_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [community.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -3.0)];
        communityNavi = [[UINavigationController alloc] initWithRootViewController:community];
        
        welfare = [[ZXWelfareViewController alloc] init];
        [welfare.tabBarItem setTitle:@"会员"];
        [welfare.tabBarItem setImage:[[UIImage imageNamed:@"tab_member_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [welfare.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_member_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [welfare.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -3.0)];
        welfareNavi = [[UINavigationController alloc] initWithRootViewController:welfare];
        
        member = [[ZXMemberViewController alloc] init];
        [member.tabBarItem setTitle:@"会员"];
        [member.tabBarItem setImage:[[UIImage imageNamed:@"tab_member_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [member.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_member_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [member.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -3.0)];
        memberNavi = [[UINavigationController alloc] initWithRootViewController:member];
        
        my = [[ZXMyVC alloc] init];
        [my.tabBarItem setTitle:@"我的"];
        [my.tabBarItem setImage:[[UIImage imageNamed:@"tab_me_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [my.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [my.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -3.0)];
        myNavi = [[UINavigationController alloc] initWithRootViewController:my];
        
        self.homeTabBarController = [[UITabBarController alloc] init];
        [self.homeTabBarController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self.homeTabBarController setViewControllers:@[homeNavi, communityNavi, welfareNavi, myNavi]];
        [self.homeTabBarController setDelegate:self];
        [self.homeTabBarController setSelectedIndex:0];
        _lastIndex = self.homeTabBarController.selectedIndex;
        
        [[UITabBar appearance] setTintColor:THEME_COLOR];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:THEME_COLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [[UITabBar appearance] setTranslucent:NO];
        
    }
    [self.window setRootViewController:self.homeTabBarController];
    
    //APP版本检查更新
    [UtilsMacro checkAppVersionUpdateWithViewController:self.window.rootViewController needToast:NO];
}

- (void)logoutSucceed {
    
}

- (void)setSelectedIndexForHomeTabWithIndex:(NSInteger)index {
    [self.homeTabBarController setSelectedIndex:index];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"pzhixin"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    [tabBarController.tabBar animationLottieImage:0];
    NSInteger count = -1;
    for (UIView *subView in tabBarController.tabBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            count++;
            if (count == tabBarController.selectedIndex && count != _lastIndex) {
                _lastIndex = tabBarController.selectedIndex;
                for (UIView *view in subView.subviews) {
                    if ([view isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                        [view.layer removeAnimationForKey:@"transform.scale"];
                        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.8 andView:view endRemove:YES];
                    }
                }
                break;
            }
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *loginVC = [[ZXLoginViewController alloc] init];
            [loginVC setTabIndex:3];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNavi animated:YES completion:nil];
            return NO;
        } else {
            return YES;
        }
    } else if ([viewController.tabBarItem.title isEqualToString:@"会员"]) {
        if (![[ZXLoginHelper sharedInstance] loginState]) {
            ZXLoginViewController *loginVC = [[ZXLoginViewController alloc] init];
            [loginVC setTabIndex:2];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNavi animated:YES completion:nil];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

#pragma mark - JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification  API_AVAILABLE(ios(10.0)){
    NSLog(@"openSettingsForNotification===>%@",notification);
//    UIAlertController *testAlert = [UtilsMacro zxAlertControllerWithTitle:@"测试" andMessage:@"测试推送通知" style:UIAlertControllerStyleAlert andAction:@[] alertActionClicked:^(NSInteger actionTag) {
//
//    }];
//    [self.homeTabBarController.selectedViewController presentViewController:testAlert animated:YES completion:nil];
}

//APP在前台活动收到推送通知的响应方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
//    NSLog(@"收到推送通知：%@", notification);
    NSInteger badgeNum = [notification.request.content.badge integerValue];
    [self setAppBadgeWithNum:badgeNum reduce:NO];
    [self zxFindNotification];
    completionHandler(UNNotificationPresentationOptionAlert);
}

//iOS 7.0及以上
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//点击通知栏的推送通知时的响应方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"收到推送通知111：%@", response);
    if (![UtilsMacro whetherIsEmptyWithObject:response.notification.request.content.userInfo] && [[response.notification.request.content.userInfo allKeys] containsObject:@"json"] && ![UtilsMacro whetherIsEmptyWithObject:[response.notification.request.content.userInfo valueForKey:@"json"]]) {
        NSLog(@"userInfo:%@",response.notification.request.content.userInfo);
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[[response.notification.request.content.userInfo valueForKey:@"json"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if ([UtilsMacro whetherIsEmptyWithObject:params]) {
            NSLog(@"收到用户内容：%@", params);
            ZXPushObj *pushObj = [ZXPushObj yy_modelWithJSON:params];
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, pushObj.url_schema] andUserInfo:pushObj viewController:[UtilsMacro topViewController]];
        }
    }
    NSInteger badgeNum = [response.notification.request.content.badge integerValue];
    [self setAppBadgeWithNum:badgeNum reduce:YES];
    [self zxFindNotification];
    completionHandler();
}

- (void)setAppBadgeWithNum:(NSInteger)badgeNum reduce:(BOOL)reduce {
    [JPUSHService setBadge:-1];
    if (@available(iOS 11.0, *)) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    } else {
        UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
        clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0.3)];
        clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
        clearEpisodeNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    }
}

- (void)zxFindNotification {
    JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
    identifier.identifiers = nil;
    if (@available(iOS 10.0, *)) {
        identifier.delivered = YES;
    } else {
        
    }
    identifier.findCompletionHandler = ^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ZXAppConfigHelper sharedInstance] setAppBadge:results.count];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:APP_BADGE_CHANGE object:nil];
        });
    };
    [JPUSHService findNotification:identifier];
}

#pragma mark - GDTSplashAdDelegate

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    _showingAd = NO;
    [self checkGeneralPasteBoard];
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    _showingAd = NO;
    [self checkGeneralPasteBoard];
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd {
    
}

- (void)splashAdLifeTime:(NSUInteger)time {
    
}

#pragma mark - BUSplashAdDelegate

- (void)splashAdDidLoad:(BUSplashAdView *)splashAd {
    
}

- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    [_splashAdView removeFromSuperview];
    _showingAd = NO;
    [self checkGeneralPasteBoard];
}

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    
}

- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    
}

- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [_splashAdView removeFromSuperview];
    _showingAd = NO;
    [self checkGeneralPasteBoard];
}

- (void)splashAdWillClose:(BUSplashAdView *)splashAd {
    
}

@end
