//
//  ZXTBCancelAuthHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXTBCancelAuthHelper.h"

@implementation ZXTBCancelAuthHelper

+ (ZXTBCancelAuthHelper *)sharedInstance {
    static ZXTBCancelAuthHelper *tbCancelAuthHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tbCancelAuthHelper == nil) {
            tbCancelAuthHelper = [[ZXTBCancelAuthHelper alloc] init];
        }
    });
    return tbCancelAuthHelper;
}

- (void)fetchTBCancelAuthCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:TAOBAO_CANCEL_AUTH andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
