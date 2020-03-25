//
//  ZXSettingHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSettingHelper.h"

@implementation ZXSettingRes

@end

@implementation ZXSettingHelper

+ (ZXSettingHelper *)sharedInstance {
    static ZXSettingHelper *settingHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (settingHelper == nil) {
            settingHelper = [[ZXSettingHelper alloc] init];
        }
    });
    return settingHelper;
}

- (void)fetchSettingWithType:(NSString *)inType andVal:(NSString *)inVal completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inType != nil) {
        [parameters addEntriesFromDictionary:@{@"type":inType}];
    }
    if (inVal != nil) {
        [parameters addEntriesFromDictionary:@{@"val":inVal}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SETTING
                                       andParameters:parameters
                                     completionBlock:completionBlock
                                          errorBlock:errorBlock];
}

@end
