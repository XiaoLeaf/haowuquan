//
//  ZXUnBindWxHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUnBindWxHelper.h"

@implementation ZXUnBindWxHelper

+ (ZXUnBindWxHelper *)sharedInstance {
    static ZXUnBindWxHelper *unBindWXHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (unBindWXHelper == nil) {
            unBindWXHelper = [[ZXUnBindWxHelper alloc] init];
        }
    });
    return unBindWXHelper;
}

- (void)fetchUnBindWXWithCode:(NSString *)inCode completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:UNBIND_WX andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
