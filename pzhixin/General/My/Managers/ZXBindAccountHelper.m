//
//  ZXBindAccountHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXBindAccountHelper.h"

@implementation ZXBindAccountHelper

+ (ZXBindAccountHelper *)sharedInstance {
    static ZXBindAccountHelper *bindAccountHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (bindAccountHelper == nil) {
            bindAccountHelper = [[ZXBindAccountHelper alloc] init];
        }
    });
    return bindAccountHelper;
}

- (void)fetchBindAccountWithRealName:(NSString *)inRealName andAlipay:(NSString *)inAlipay andCode:(NSString *_Nullable)inCode andType:(NSString *)inType completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inRealName != nil) {
        [parameters addEntriesFromDictionary:@{@"realname":inRealName}];
    }
    if (inAlipay != nil) {
        [parameters addEntriesFromDictionary:@{@"alipay":inAlipay}];
    }
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:BIND_ACCOUNT andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
