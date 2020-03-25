//
//  ZXCashListHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashListHelper.h"

@implementation ZXCashListHelper

+ (ZXCashListHelper *)sharedInstance {
    static ZXCashListHelper *cashListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cashListHelper == nil) {
            cashListHelper = [[ZXCashListHelper alloc] init];
        }
    });
    return cashListHelper;
}

- (void)fetchCashListWithPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:CASH_LIST andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
