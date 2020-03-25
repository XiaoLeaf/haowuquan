//
//  ZXDelFootPrintHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDelFootPrintHelper.h"

@implementation ZXDelFootPrintHelper

+ (ZXDelFootPrintHelper *)sharedInstance {
    static ZXDelFootPrintHelper *delFootPrintHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (delFootPrintHelper == nil) {
            delFootPrintHelper = [[ZXDelFootPrintHelper alloc] init];
        }
    });
    return delFootPrintHelper;
}

- (void)fetchDelFootPrintWithIds:(NSString *)inIds completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inIds != nil) {
        [parameters addEntriesFromDictionary:@{@"ids":inIds}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:DEL_FOOTPRINT andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
