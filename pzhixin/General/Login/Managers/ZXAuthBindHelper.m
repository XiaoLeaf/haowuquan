//
//  ZXAuthBindHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAuthBindHelper.h"

@implementation ZXAuthBindHelper

+ (ZXAuthBindHelper *)sharedInstance {
    static ZXAuthBindHelper *authBindHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (authBindHelper == nil) {
            authBindHelper = [[ZXAuthBindHelper alloc] init];
        }
    });
    return authBindHelper;
}

- (void)fetchAuthBindWithRef:(NSString *)inRef andStep:(NSString *)inStep completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inRef != nil) {
        [parameters addEntriesFromDictionary:@{@"ref":inRef}];
    }
    if (inStep != nil) {
        [parameters addEntriesFromDictionary:@{@"step":inStep}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:AUTH_BIND andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
