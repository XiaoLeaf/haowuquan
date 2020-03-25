//
//  ZXGoodsCouponHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGoodsCouponHelper.h"

@implementation ZXGoodsCouponHelper

+ (ZXGoodsCouponHelper *)sharedInstance {
    static ZXGoodsCouponHelper *goodsCouponHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (goodsCouponHelper == nil) {
            goodsCouponHelper = [[ZXGoodsCouponHelper alloc] init];
        }
    });
    return goodsCouponHelper;
}

- (void)fetchGoodsCouponWithId:(NSString *)inId andItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inId != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inId}];
    }
    if (inItem_id != nil) {
        [parameters addEntriesFromDictionary:@{@"item_id":inItem_id}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:GOODS_COUPON andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
