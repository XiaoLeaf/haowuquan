//
//  ZXGoodsDetailHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGoodsDetailHelper.h"

@implementation ZXGoodsDetailHelper

+ (ZXGoodsDetailHelper *)sharedInstance {
    static ZXGoodsDetailHelper *goodsDetailHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (goodsDetailHelper == nil) {
            goodsDetailHelper = [[ZXGoodsDetailHelper alloc] init];
        }
    });
    return goodsDetailHelper;
}

- (void)fetchGoodsDetailWithGoodsId:(NSString *)inGoods_id andItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inGoods_id != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inGoods_id}];
    }
    if (inItem_id != nil) {
        [parameters addEntriesFromDictionary:@{@"item_id":inItem_id}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:GOODS_DETAIL andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
