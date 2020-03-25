//
//  AppDelegate.h
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <WechatOpenSDK/WXApi.h>
#import "ZXGuideViewController.h"
#import <JPush/JPUSHService.h>
//#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <Bugly/Bugly.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate> {
    UINavigationController *loginNavigationController;
    UINavigationController *homeNavigationController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *homeTabBarController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) NSData *deviceToken;

- (void)setSelectedIndexForHomeTabWithIndex:(NSInteger)index;

- (void)saveContext;

- (void)loginSucceed;

- (void)logoutSucceed;

+ (AppDelegate *)sharedInstance;


@end

