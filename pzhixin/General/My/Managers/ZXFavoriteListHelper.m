//
//  ZXFavoriteListHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavoriteListHelper.h"

@implementation ZXFavoriteListHelper

+ (ZXFavoriteListHelper *)sharedInstance {
    static ZXFavoriteListHelper *favoriteListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (favoriteListHelper == nil) {
            favoriteListHelper = [[ZXFavoriteListHelper alloc] init];
        }
    });
    return favoriteListHelper;
}

- (void)fetchFavoriteListWithPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:FAVORITE_LIST andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
