//
//  ZXCashInitHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashInitHelper.h"

@implementation ZXCashInitHelper

+ (ZXCashInitHelper *)sharedInstance {
    static ZXCashInitHelper *cashInitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cashInitHelper == nil) {
            cashInitHelper = [[ZXCashInitHelper alloc] init];
        }
    });
    return cashInitHelper;
}

- (void)fetchCashInitWithCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:CASH_INIT andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
