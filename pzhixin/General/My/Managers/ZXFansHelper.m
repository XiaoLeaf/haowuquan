//
//  ZXFansHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansHelper.h"

@implementation ZXFansHelper

+ (ZXFansHelper *)sharedInstance {
    static ZXFansHelper *fansHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (fansHelper == nil) {
            fansHelper = [[ZXFansHelper alloc] init];
        }
    });
    return fansHelper;
}

- (void)fetchFansWithPage:(NSString *)inPage andType:(NSString *)inType andOrder:(NSString *)inOrder completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    if (inOrder != nil) {
        [parameters addEntriesFromDictionary:@{@"order":inOrder}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:FANS andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
