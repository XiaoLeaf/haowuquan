//
//  ZXAppConfigHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAppConfigHelper.h"

@implementation ZXPolicy

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end

@implementation ZXConfigH5Item

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end

@implementation ZXConfigH5

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXConfigH5Item class], @"agreement", [ZXConfigH5Item class], @"feedback", [ZXConfigH5Item class], @"intro", [ZXConfigH5Item class], @"member", [ZXConfigH5Item class], @"unable_login", [ZXConfigH5Item class], @"message", nil];
}

@end

@implementation ZXAppConfig

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXClassify class], @"cats", [ZXConfigH5 class], @"h5", [ZXLoadingAsset class], @"loading", [ZXMenu class], @"menus", [ZXPolicy class], @"policy", nil];
}

@end

@implementation ZXAppConfigHelper

+ (ZXAppConfigHelper *)sharedInstance {
    static ZXAppConfigHelper *appConfigHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (appConfigHelper == nil) {
            appConfigHelper = [[ZXAppConfigHelper alloc] init];
        }
    });
    return appConfigHelper;
}

- (void)fetchAPPConfigCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:APP_CONFIG andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

#pragma mark - Public Methods

- (NSArray *)classifyList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"classify"]];
}

- (void)setClassifyList:(NSArray *)classifyList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *arrData = [NSKeyedArchiver archivedDataWithRootObject:classifyList];
    [userDefaults setValue:arrData forKey:@"classify"];
    [userDefaults synchronize];
}

- (NSString *)taobaoAuthUrl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"tb_auth_url"];
}

- (void)setTaobaoAuthUrl:(NSString *)taobaoAuthUrl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:taobaoAuthUrl forKey:@"tb_auth_url"];
    [userDefaults synchronize];
}

- (NSString *)welfareUrl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"welfare_url"];
}

- (void)setWelfareUrl:(NSString *)welfareUrl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:welfareUrl forKey:@"welfare_url"];
    [userDefaults synchronize];
}

- (NSString *)registrationID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"registrationID"];
}

- (void)setRegistrationID:(NSString *)registrationID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:registrationID forKey:@"registrationID"];
    [userDefaults synchronize];
}

#pragma mark - loading

- (ZXLoadingAsset *)loadingAsset {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefaults objectForKey:@"loading"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
}

- (void)setLoadingAsset:(ZXLoadingAsset *)loadingAsset {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *loadingData = [NSKeyedArchiver archivedDataWithRootObject:loadingAsset];
    [userDefaults setObject:loadingData forKey:@"loading"];
    [userDefaults synchronize];
}

#pragma mark - APP配置信息

- (ZXAppConfig *)appConfig {
    NSUserDefaults *configDefaults = [NSUserDefaults standardUserDefaults];
    NSData *confidData = [configDefaults objectForKey:@"appConfig"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:confidData];
}

- (void)setAppConfig:(ZXAppConfig *)appConfig {
    NSUserDefaults *configDefaults = [NSUserDefaults standardUserDefaults];
    NSData *configData = [NSKeyedArchiver archivedDataWithRootObject:appConfig];
    [configDefaults setObject:configData forKey:@"appConfig"];
    [configDefaults synchronize];
}

#pragma mark - Badge

- (NSInteger)appBadge {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"appBadge"];
}

- (void)setAppBadge:(NSInteger)appBadge {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:appBadge forKey:@"appBadge"];
    [userDefaults synchronize];
}

@end

