//
//  ZXInviteConfigHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/15.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXInviteConfigHelper.h"

@implementation ZXInviteConfigHelper

+ (ZXInviteConfigHelper *)sharedInstance {
    static ZXInviteConfigHelper *configHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (configHelper == nil) {
            configHelper = [[ZXInviteConfigHelper alloc] init];
        }
    });
    return configHelper;
}

- (void)fetchInviteConfigCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:INVITE_CONFIG andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
