//
//  ZXShareHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/4.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXShareHelper.h"

@implementation ZXGoodsShare

@end

@implementation ZXShareHelper

+ (ZXShareHelper *)sharedInstance {
    static ZXShareHelper *shareHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareHelper == nil) {
            shareHelper = [[ZXShareHelper alloc] init];
        }
    });
    return shareHelper;
}

- (void)fetchSharelWithGoodsId:(NSString *)inGoods_id andItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * _Nonnull))completionBlock error:(void (^)(ZXResponse * _Nonnull))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inGoods_id != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inGoods_id}];
    }
    if (inItem_id != nil) {
        [parameters addEntriesFromDictionary:@{@"item_id":inItem_id}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:GOODS_SHARE andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
