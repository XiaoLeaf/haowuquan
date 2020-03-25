//
//  ZXScoreReceiveHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreReceiveHelper.h"

@implementation ZXScoreReceiveHelper

+ (ZXScoreReceiveHelper *)sharedInstance {
    static ZXScoreReceiveHelper *scoreReceiveHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (scoreReceiveHelper == nil) {
            scoreReceiveHelper = [[ZXScoreReceiveHelper alloc] init];
        }
    });
    return scoreReceiveHelper;
}

- (void)fetchScoreReceiveWithId:(NSString *)inId completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inId != nil) {
        [parameters addEntriesFromDictionary:@{@"id":inId}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:SCORE_RECEIVE andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
