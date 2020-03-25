//
//  ZXPhoneBindLoginHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPhoneBindLoginHelper.h"

@implementation ZXPhoneBindLoginHelper

+ (ZXPhoneBindLoginHelper *)sharedInstance {
    static ZXPhoneBindLoginHelper *phoneBindLoginHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (phoneBindLoginHelper == nil) {
            phoneBindLoginHelper = [[ZXPhoneBindLoginHelper alloc] init];
        }
    });
    return phoneBindLoginHelper;
}

- (void)fetchBindOrLoginWithTel:(NSString *)inTel andCode:(NSString *)inCode andUnionid:(NSString *)inUnionid andUser_id:(NSString *)inUser_id andType:(NSString *)inType andPush_id:(NSString *)inPush_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inTel != nil) {
        [parameters addEntriesFromDictionary:@{@"tel":inTel}];
    }
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    if (inUnionid != nil) {
        [parameters addEntriesFromDictionary:@{@"unionid":inUnionid}];
    }
    if (inUser_id != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inUser_id}];
    }
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    if (inPush_id != nil) {
        [parameters addEntriesFromDictionary:@{@"push_id":inPush_id}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:TEL_LOGIN andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
