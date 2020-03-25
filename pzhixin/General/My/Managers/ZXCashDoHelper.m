//
//  ZXCashDoHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashDoHelper.h"

@implementation ZXCashDoHelper

+ (ZXCashDoHelper *)sharedInstance {
    static ZXCashDoHelper *cashDoHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cashDoHelper == nil) {
            cashDoHelper = [[ZXCashDoHelper alloc] init];
        }
    });
    return cashDoHelper;
}

- (void)fetchCashDoWithAmount:(NSString *)inAmount andPwd:(NSString *_Nullable)inPwd completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inAmount != nil) {
        [parameters addEntriesFromDictionary:@{@"amount":inAmount}];
    }
    if (inPwd != nil) {
        [parameters addEntriesFromDictionary:@{@"pwd":inPwd}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:CASH_DO andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
