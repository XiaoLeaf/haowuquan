//
//  ZXProfitListHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProfitListHelper.h"

@implementation ZXProfitTypeItem

@end

@implementation ZXProfitListRes

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXProfitTypeItem class], @"type_arr", [ZXProfitTypeItem class], @"mine_arr", [ZXProfitList class], @"list", [ZXCommonNotice class], @"notice", nil];
}

@end

@implementation ZXProfitListHelper

+ (ZXProfitListHelper *)sharedInstance {
    static ZXProfitListHelper *profitListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (profitListHelper == nil) {
            profitListHelper = [[ZXProfitListHelper alloc] init];
        }
    });
    return profitListHelper;
}

- (void)fetchProfitListWithPage:(NSString *)inPage andMine:(NSString *)inMine andType:(NSString *)inType andS_time:(NSString *_Nullable)inS_time andE_time:(NSString *_Nullable)inE_time completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inMine != nil) {
        [parameters addEntriesFromDictionary:@{@"mine":inMine}];
    }
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    if (inS_time != nil) {
        [parameters addEntriesFromDictionary:@{@"s_time":inS_time}];
    }
    if (inE_time != nil) {
        [parameters addEntriesFromDictionary:@{@"e_time":inE_time}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:PROFIT_LIST andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
