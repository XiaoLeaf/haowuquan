//
//  ZXFavoriteHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavoriteHelper.h"

@implementation ZXFavoriteHelper

+ (ZXFavoriteHelper *)sharedInstance {
    static ZXFavoriteHelper *favoriteHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (favoriteHelper == nil) {
            favoriteHelper = [[ZXFavoriteHelper alloc] init];
        }
    });
    return favoriteHelper;
}

- (void)fetchGoodsFavoriteWithItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inItem_id != nil) {
        [parameters addEntriesFromDictionary:@{@"item_id":inItem_id}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:FAVORITE andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
