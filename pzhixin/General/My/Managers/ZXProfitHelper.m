//
//  ZXProfitHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProfitHelper.h"

@implementation ZXProfitHelper

+ (ZXProfitHelper *)sharedInstance {
    static ZXProfitHelper *profitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (profitHelper == nil) {
            profitHelper = [[ZXProfitHelper alloc] init];
        }
    });
    return profitHelper;
}

- (void)fetchProfitWithCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:PROFIT andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
