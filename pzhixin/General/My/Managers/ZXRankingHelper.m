//
//  ZXRankingHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRankingHelper.h"

@implementation ZXRankNotice

@end

@implementation ZXRankingType

@end

@implementation ZXRankingRes

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXRankNotice class], @"notice", [ZXRankingType class], @"type_arr", [ZXRanking class], @"list", nil];
}

@end

@implementation ZXRankingHelper

+ (ZXRankingHelper *)sharedInstance {
    static ZXRankingHelper *rankingHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (rankingHelper == nil) {
            rankingHelper = [[ZXRankingHelper alloc] init];
        }
    });
    return rankingHelper;
}

- (void)fetchRankingWithPage:(NSString *)inPage andType:(NSString *)inType completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:RANKING andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
