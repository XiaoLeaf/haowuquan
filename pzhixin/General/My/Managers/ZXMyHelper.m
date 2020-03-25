//
//  ZXMyHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyHelper.h"

@implementation ZXMyHelper

+ (ZXMyHelper *)sharedInstance {
    static ZXMyHelper *myHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (myHelper == nil) {
            myHelper = [[ZXMyHelper alloc] init];
        }
    });
    return myHelper;
}

- (void)fetchMyInfoWithCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:USER_INDEX
                                       andParameters:[NSMutableDictionary new]
                                     completionBlock:completionBlock
                                          errorBlock:errorBlock];
}

#pragma mark - 用户信息

- (ZXUser *)userInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefaults objectForKey:@"userInfo"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
}

- (void)setUserInfo:(ZXUser *)userInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [userDefaults setObject:userData forKey:@"userInfo"];
    [userDefaults synchronize];
}

@end
