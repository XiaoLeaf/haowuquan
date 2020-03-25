//
//  ZXScoreRecordHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreRecordHelper.h"

@implementation ZXScoreRecordHelper

+ (ZXScoreRecordHelper *)sharedInstance {
    static ZXScoreRecordHelper *scoreRecordHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (scoreRecordHelper == nil) {
            scoreRecordHelper = [[ZXScoreRecordHelper alloc] init];
        }
    });
    return scoreRecordHelper;
}

- (void)fetchScoreRecordCompletion:(void (^)(ZXResponse * _Nonnull))completionBlock error:(void (^)(ZXResponse * _Nonnull))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [[ZXNewService sharedManager] postRequestWithUri:SCORE_RECORD andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
