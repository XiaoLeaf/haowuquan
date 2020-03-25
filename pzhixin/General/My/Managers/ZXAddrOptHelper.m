//
//  ZXAddrOptHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddrOptHelper.h"

@implementation ZXAddrOptHelper

+ (ZXAddrOptHelper *)sharedInstance {
    static ZXAddrOptHelper *addrOptHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (addrOptHelper == nil) {
            addrOptHelper = [[ZXAddrOptHelper alloc] init];
        }
    });
    return addrOptHelper;
}

- (void)fetchAddrOptWithAct:(NSString *)inAct andId:(NSString *)inId completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inAct != nil) {
        [parameters addEntriesFromDictionary:@{@"act":inAct}];
    }
    if (inId != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inId}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:ADDR_OPT andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
