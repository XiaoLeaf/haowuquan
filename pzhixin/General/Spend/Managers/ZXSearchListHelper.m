//
//  ZXSearchListHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchListHelper.h"

@implementation ZXSearchListHelper

+ (ZXSearchListHelper *)sharedInstance {
    static ZXSearchListHelper *searchListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (searchListHelper == nil) {
            searchListHelper = [[ZXSearchListHelper alloc] init];
        }
    });
    return searchListHelper;
}

- (void)fetchSearchListWithPage:(NSString *)inPage andKeywords:(NSString *)inKeywords andSort:(NSString *)inSort completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inKeywords != nil) {
        [parameters addEntriesFromDictionary:@{@"keywords":inKeywords}];
    }
    if (inSort != nil) {
        [parameters addEntriesFromDictionary:@{@"sort":inSort}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SEARCH_LIST andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
