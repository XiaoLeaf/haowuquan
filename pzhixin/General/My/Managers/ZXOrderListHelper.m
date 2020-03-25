//
//  ZXOrderListHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOrderListHelper.h"

@implementation ZXOrderStatus

@end

@implementation ZXOrderList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXOrder class], @"list", [ZXCommonNotice class], @"notice", [ZXOrderStatus class], @"status_arr", [ZXOrderStatus class], @"mine_arr", nil];
}

@end

@implementation ZXOrderListHelper

+ (ZXOrderListHelper *)sharedInstance {
    static ZXOrderListHelper *orderListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (orderListHelper == nil) {
            orderListHelper = [[ZXOrderListHelper alloc] init];
        }
    });
    return orderListHelper;
}

- (void)fetchOrderListWithPage:(NSString *)inPage andMine:(NSString *)inMine andStatus:(NSString *)inStatus andS_time:(NSString *_Nullable)inS_time andE_time:(NSString *_Nullable)inE_time completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inMine != nil) {
        [parameters addEntriesFromDictionary:@{@"mine":inMine}];
    }
    if (inStatus != nil) {
        [parameters addEntriesFromDictionary:@{@"status":inStatus}];
    }
    if (inS_time != nil) {
        [parameters addEntriesFromDictionary:@{@"s_time":inS_time}];
    }
    if (inE_time != nil) {
        [parameters addEntriesFromDictionary:@{@"e_time":inE_time}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:ORDER_LIST andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
