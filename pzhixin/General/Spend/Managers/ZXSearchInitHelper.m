//
//  ZXSearchInitHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchInitHelper.h"

@implementation ZXSearchInitBanner

@end

@implementation ZXSearchKeyword

@end

@implementation ZXSearchInit

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXSearchKeyword class], @"keywords", [ZXSearchInitBanner class], @"banner", nil];
}

@end

@implementation ZXSearchInitHelper

+ (ZXSearchInitHelper *)sharedInstance {
    static ZXSearchInitHelper *searchInitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (searchInitHelper == nil) {
            searchInitHelper = [[ZXSearchInitHelper alloc] init];
        }
    });
    return searchInitHelper;
}

- (void)fetchSearchInitWithMore:(NSString *)inMore completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inMore != nil) {
        [parameters addEntriesFromDictionary:@{@"more": inMore}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SEARCH_INIT andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
