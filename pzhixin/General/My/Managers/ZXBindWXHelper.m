//
//  ZXBindWXHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXBindWXHelper.h"

@implementation ZXBindWXHelper

+ (ZXBindWXHelper *)sharedInstance {
    static ZXBindWXHelper *bindWXHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (bindWXHelper == nil) {
            bindWXHelper = [[ZXBindWXHelper alloc] init];
        }
    });
    return bindWXHelper;
}

- (void)fetchBindWXWithCode:(NSString *)inCode completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:BIND_WX andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
