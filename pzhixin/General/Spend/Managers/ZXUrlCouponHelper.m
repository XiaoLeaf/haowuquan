//
//  ZXUrlCouponHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUrlCouponHelper.h"

@implementation ZXUrlCoupon

@end

@implementation ZXUrlCouponHelper

+ (ZXUrlCouponHelper *)sharedInstance {
    static ZXUrlCouponHelper *urlCouponHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (urlCouponHelper == nil) {
            urlCouponHelper = [[ZXUrlCouponHelper alloc] init];
        }
    });
    return urlCouponHelper;
}

- (void)fetchUrlCouponWithUrl:(NSString *)inUrl completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inUrl != nil) {
        [parameters addEntriesFromDictionary:@{@"url":inUrl}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SEARCH_URL_COUPON andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
