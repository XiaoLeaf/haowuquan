//
//  ZXScoreSignHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/22.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreSignHelper.h"

@implementation ZXScoreSignHelper

+ (ZXScoreSignHelper *)sharedInstance {
    static ZXScoreSignHelper *scoreSignHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (scoreSignHelper == nil) {
            scoreSignHelper = [[ZXScoreSignHelper alloc] init];
        }
    });
    return scoreSignHelper;
}

- (void)fetchScoreSignCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:SCORE_SIGNIN andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
