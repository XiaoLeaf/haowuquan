//
//  ZXLoginHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXLoginHelper.h"

@implementation ZXLoginHelper

+ (ZXLoginHelper *)sharedInstance {
    static ZXLoginHelper *loginHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (loginHelper == nil) {
            loginHelper = [[ZXLoginHelper alloc] init];
        }
    });
    return loginHelper;
}

- (void)fetchLoginWithCode:(NSString *)inCode andPush_id:(NSString *)inPush_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    if (inPush_id != nil) {
        [parameters addEntriesFromDictionary:@{@"push_id":inPush_id}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:WX_LOGIN andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

#pragma mark - 登录状态

- (BOOL)loginState {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"loginState"];
}

- (void)setLoginState:(BOOL)state {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:state forKey:@"loginState"];
    [userDefaults synchronize];
}

#pragma mark - 验证码

- (NSString *)authorization {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"authorization"];
}

- (void)setAuthorization:(NSString *)auth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:auth forKey:@"authorization"];
    [userDefaults synchronize];
}

@end
