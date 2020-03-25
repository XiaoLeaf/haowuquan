//
//  ZXAddrInfoHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddrInfoHelper.h"

@implementation ZXAddrInfoHelper

+ (ZXAddrInfoHelper *)sharedInstance {
    static ZXAddrInfoHelper *addrInfoHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (addrInfoHelper == nil) {
            addrInfoHelper = [[ZXAddrInfoHelper alloc] init];
        }
    });
    return addrInfoHelper;
}

- (void)fetchAddrInfoWithAct:(NSString *)inAct andId:(NSString *)inId andRealName:(NSString *)inRealname andTel:(NSString *)inTel andProv_id:(NSString *)inProv_id andCity_id:(NSString *)inCity_id andArea_id:(NSString *)inArea_id andStreer_id:(NSString *)inStreet_id andAddress:(NSString *)inAddress andIs_def:(NSString *)inIs_def Completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inAct != nil) {
        [parameters addEntriesFromDictionary:@{@"act":inAct}];
    }
    if (inId != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inId}];
    }
    if (inRealname != nil) {
        [parameters addEntriesFromDictionary:@{@"realname":inRealname}];
    }
    if (inTel != nil) {
        [parameters addEntriesFromDictionary:@{@"tel":inTel}];
    }
    if (inProv_id != nil) {
        [parameters addEntriesFromDictionary:@{@"prov_id":inProv_id}];
    }
    if (inCity_id != nil) {
        [parameters addEntriesFromDictionary:@{@"city_id":inCity_id}];
    }
    if (inArea_id != nil) {
        [parameters addEntriesFromDictionary:@{@"area_id":inArea_id}];
    }
    if (inStreet_id != nil) {
        [parameters addEntriesFromDictionary:@{@"street_id":inStreet_id}];
    }
    if (inAddress != nil) {
        [parameters addEntriesFromDictionary:@{@"address":inAddress}];
    }
    if (inIs_def != nil) {
        [parameters addEntriesFromDictionary:@{@"is_def":inIs_def}];
    }
//    NSLog(@"parameters:%@",parameters);
    [[ZXNewService sharedManager] postRequestWithUri:ADDR_INFO andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
