//
//  ZXCodeHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCodeHelper.h"

@implementation ZXCodeHelper

+ (ZXCodeHelper *)sharedInstance {
    static ZXCodeHelper *codeHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (codeHelper == nil) {
            codeHelper = [[ZXCodeHelper alloc] init];
        }
    });
    return codeHelper;
}

- (void)fetchCodeWithType:(NSString *)inType andTel:(NSString *_Nullable)inTel andUser_id:(NSString *_Nullable)inUser_id andUniondid:(NSString *_Nullable)inUnionid completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    if (inTel != nil) {
        [parameters addEntriesFromDictionary:@{@"tel":inTel}];
    }
    if (inUser_id != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inUser_id}];
    }
    if (inUnionid != nil) {
        [parameters addEntriesFromDictionary:@{@"unionid":inUnionid}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:VALIDATE_CODE andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
