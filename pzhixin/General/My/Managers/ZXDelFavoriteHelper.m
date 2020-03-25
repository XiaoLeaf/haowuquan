//
//  ZXDelFavoriteHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDelFavoriteHelper.h"

@implementation ZXDelFavoriteHelper

+ (ZXDelFavoriteHelper *)sharedInstance {
    static ZXDelFavoriteHelper *delFavoriteHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (delFavoriteHelper == nil) {
            delFavoriteHelper = [[ZXDelFavoriteHelper alloc] init];
        }
    });
    return delFavoriteHelper;
}

- (void)fetchDelFavoriteWithIds:(NSString *)inIds completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inIds != nil) {
        [parameters addEntriesFromDictionary:@{@"ids":inIds}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:DEL_FAVORITE andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
