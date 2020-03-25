//
//  ZXScoreIndexHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreIndexHelper.h"

@implementation ZXScoreIndexHelper

+ (ZXScoreIndexHelper *)sharedInstance {
    static ZXScoreIndexHelper *scoreIndexHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (scoreIndexHelper == nil) {
            scoreIndexHelper = [[ZXScoreIndexHelper alloc] init];
        }
    });
    return scoreIndexHelper;
}

- (void)fetchScoreIndexCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:SCORE_INDEX andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
