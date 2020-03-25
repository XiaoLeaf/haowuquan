//
//  ZXSucceedShareHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/12/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSucceedShareHelper.h"

@implementation ZXSucceedShareHelper

+ (ZXSucceedShareHelper *)sharedInstance {
    static ZXSucceedShareHelper *succeedShareHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (succeedShareHelper == nil) {
            succeedShareHelper = [[ZXSucceedShareHelper alloc] init];
        }
    });
    return succeedShareHelper;
}

- (void)fetchSucceedShareWithType:(NSString *)inType andRel_id:(NSString *_Nullable)inRel_id andUrl:(NSString *_Nullable)inUrl completion:(void (^)(ZXResponse * _Nonnull))completionBlock error:(void (^)(ZXResponse * _Nonnull))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type": inType}];
    }
    if (inRel_id != nil) {
        [parameters addEntriesFromDictionary:@{@"rel_id": inRel_id}];
    }
    if (inUrl != nil) {
        [parameters addEntriesFromDictionary:@{@"url": inUrl}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SHARE_SUCCEED andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
