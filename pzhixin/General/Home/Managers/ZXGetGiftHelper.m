//
//  ZXGetGiftHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGetGiftHelper.h"

@implementation ZXGetGiftHelper

+ (ZXGetGiftHelper *)sharedInstance {
    static ZXGetGiftHelper *getGiftHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (getGiftHelper == nil) {
            getGiftHelper = [[ZXGetGiftHelper alloc] init];
        }
    });
    return getGiftHelper;
}

- (void)fetchGetGiftWithId:(NSString *)inId Completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inId != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inId}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:GET_GIFT
                                       andParameters:parameters
                                     completionBlock:completionBlock
                                          errorBlock:errorBlock];
}

@end
