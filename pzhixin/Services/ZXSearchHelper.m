//
//  ZXSearchHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchHelper.h"

@implementation ZXCommonSearch

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"goods_id":@"id"};
}

@end

@implementation ZXSearchHelper

+ (ZXSearchHelper *)sharedInstance {
    static ZXSearchHelper *searchHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (searchHelper == nil) {
            searchHelper = [[ZXSearchHelper alloc] init];
        }
    });
    return searchHelper;
}

- (void)fetchSearchGoodsWithContent:(NSString *)inContent andFrom:(NSString *)inFrom completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inContent != nil) {
        [parameters addEntriesFromDictionary:@{@"content":inContent}];
    }
    if (inFrom != nil) {
        [parameters addEntriesFromDictionary:@{@"from":inFrom}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SEARCH_GOODS andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
