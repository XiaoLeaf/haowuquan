//
//  ZXGuessLikeHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGuessLikeHelper.h"

@implementation ZXGuessLikeHelper

+ (ZXGuessLikeHelper *)sharedInstance {
    static ZXGuessLikeHelper *guessLikeHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (guessLikeHelper == nil) {
            guessLikeHelper = [[ZXGuessLikeHelper alloc] init];
        }
    });
    return guessLikeHelper;
}

- (void)fetchGuessLikeWithPage:(NSString *)inPage andSort:(NSString *)inSort completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inSort != nil) {
        [parameters addEntriesFromDictionary:@{@"sort":inSort}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:GUESS_LIKE andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
