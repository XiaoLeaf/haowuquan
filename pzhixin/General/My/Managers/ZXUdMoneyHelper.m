//
//  ZXUdMoneyHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUdMoneyHelper.h"

@implementation ZXUdMoneyHelper

+ (ZXUdMoneyHelper *)sharedInstance {
    static ZXUdMoneyHelper *udMoneyHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (udMoneyHelper == nil) {
            udMoneyHelper = [[ZXUdMoneyHelper alloc] init];
        }
    });
    return udMoneyHelper;
}

- (void)fetchMoneyWithPage:(NSString *)inPage
                andType:(NSString *)inType
                andS_time:(NSString *_Nullable)inS_time
                andE_time:(NSString *_Nullable)inE_time
                completion:(void (^)(ZXResponse * response))completionBlock
                     error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
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
    [[ZXNewService sharedManager] postRequestWithUri:UD_MONEY andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
