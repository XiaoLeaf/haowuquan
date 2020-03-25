//
//  ZXTBAuthHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXTBAuthHelper.h"

@implementation ZXTBAuthHelper

+ (ZXTBAuthHelper *)sharedInstance {
    static ZXTBAuthHelper *tbAuthHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tbAuthHelper == nil) {
            tbAuthHelper = [[ZXTBAuthHelper alloc] init];
        }
    });
    return tbAuthHelper;
}

- (void)fetchTBAuthWithCode:(NSString *)inCode completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inCode != nil) {
        NSCharacterSet *set = [NSCharacterSet URLUserAllowedCharacterSet];
        [parameters addEntriesFromDictionary:@{@"url":[inCode stringByAddingPercentEncodingWithAllowedCharacters:set]}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:TAOBAO_AUTH andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

#pragma mark - 授权状态

- (BOOL)tbAuthState {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"tbAuthState"];
}

- (void)setTBAuthState:(BOOL)state {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:state forKey:@"tbAuthState"];
    [userDefaults synchronize];
}

- (NSString *)relationId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"tbRelaitonId"];
}

- (void)setRelationId:(NSString *)relationId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:relationId forKey:@"tbRelaitonId"];
    [userDefaults synchronize];
}

@end
