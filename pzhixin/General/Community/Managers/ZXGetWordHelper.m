//
//  ZXGetWordHelper.m
//  pzhixin
//
//  Created by zhixin on 2020/3/14.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXGetWordHelper.h"

@implementation ZXGetWordHelper

+ (ZXGetWordHelper *)sharedInstance {
    static ZXGetWordHelper *getWordHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (getWordHelper == nil) {
            getWordHelper = [[ZXGetWordHelper alloc] init];
        }
    });
    return getWordHelper;
}

- (void)fetchCommunityWordWithParams:(NSString *)inParams completion:(void (^)(ZXResponse * _Nonnull))completionBlock error:(void (^)(ZXResponse * _Nonnull))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inParams != nil) {
        [parameters addEntriesFromDictionary:@{@"params":inParams}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:COMMUNITY_GET_WORD andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
