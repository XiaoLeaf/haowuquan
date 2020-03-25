//
//  ZXCommunityListHelper.m
//  pzhixin
//
//  Created by zhixin on 2020/3/11.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXCommunityListHelper.h"

@implementation ZXCommunityListHelper

+ (ZXCommunityListHelper *)sharedInstance {
    static ZXCommunityListHelper *communityListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (communityListHelper == nil) {
            communityListHelper = [[ZXCommunityListHelper alloc] init];
        }
    });
    return communityListHelper;
}

- (void)fetchCommunityListWithPage:(NSString *)inPage andFid:(NSString *_Nullable)inFid andCid:(NSString *_Nullable)inCid andKeyword:(NSString *_Nullable)inKeyword completion:(void (^)(ZXResponse * _Nonnull))completionBlock error:(void (^)(ZXResponse * _Nonnull))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inFid != nil) {
        [parameters addEntriesFromDictionary:@{@"fid":inFid}];
    }
    if (inCid != nil) {
        [parameters addEntriesFromDictionary:@{@"cid":inCid}];
    }
    if (inKeyword != nil) {
        [parameters addEntriesFromDictionary:@{@"keyword":inKeyword}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:COMMUNITY_GET_LIST andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
