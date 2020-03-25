//
//  ZXModifyPPwdHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXModifyPPwdHelper.h"

@implementation ZXModifyPPwdHelper

+ (ZXModifyPPwdHelper *)sharedInstance {
    static ZXModifyPPwdHelper *modifyPPwdHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (modifyPPwdHelper == nil) {
            modifyPPwdHelper = [[ZXModifyPPwdHelper alloc] init];
        }
    });
    return modifyPPwdHelper;
}

- (void)fetchModifyPPwdWithStep:(NSString *)inStep andVal:(NSString *_Nullable)inVal andCode:(NSString *_Nullable)inCode completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inStep != nil) {
        [parameters addEntriesFromDictionary:@{@"step":inStep}];
    }
    if (inVal != nil) {
        [parameters addEntriesFromDictionary:@{@"val":inVal}];
    }
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:MODIFY_PPWD
                                       andParameters:parameters
                                     completionBlock:completionBlock
                                          errorBlock:errorBlock];
}

@end
