//
//  ZXModifyTelHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXModifyTelHelper.h"

@implementation ZXModifyTelHelper

+ (ZXModifyTelHelper *)sharedInstance {
    static ZXModifyTelHelper *modifyTelHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (modifyTelHelper == nil) {
            modifyTelHelper = [[ZXModifyTelHelper alloc] init];
        }
    });
    return modifyTelHelper;
}

- (void)fetchModifyTelWithStep:(NSString *)inStep andCode:(NSString *)inCode andTel:(NSString *_Nullable)inTel andCodeNew:(NSString *_Nullable)inCodeNew completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inStep != nil) {
        [parameters addEntriesFromDictionary:@{@"step":inStep}];
    }
    if (inCode != nil) {
        [parameters addEntriesFromDictionary:@{@"code":inCode}];
    }
    if (inTel != nil) {
        [parameters addEntriesFromDictionary:@{@"tel":inTel}];
    }
    if (inCodeNew != nil) {
        [parameters addEntriesFromDictionary:@{@"code_new":inCodeNew}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:MODIFY_TEL
                                       andParameters:parameters
                                     completionBlock:completionBlock
                                          errorBlock:errorBlock];
}

@end
