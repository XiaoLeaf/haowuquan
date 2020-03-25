//
//  ZXCashCancelHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashCancelHelper.h"

@implementation ZXCashCancelHelper

+ (ZXCashCancelHelper *)sharedInstance {
    static ZXCashCancelHelper *cashCancelHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cashCancelHelper == nil) {
            cashCancelHelper = [[ZXCashCancelHelper alloc] init];
        }
    });
    return cashCancelHelper;
}

- (void)fetchCashCancelWithId:(NSString *)inId completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inId != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inId}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:CASH_CANCEL andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
