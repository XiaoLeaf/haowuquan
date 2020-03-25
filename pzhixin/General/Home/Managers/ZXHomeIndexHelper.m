//
//  ZXHomeIndexHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeIndexHelper.h"

@implementation ZXDayRec

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXGoods class], @"list", nil];
}

@end

@implementation ZXHomeSlides

@end

@implementation ZXHomeIndex

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXRedEnvelop class], @"gift_arr", [ZXDayRec class] , @"day_rec", [ZXHomeSlides class], @"slides", [ZXHomeSlides class], @"main_ads", [ZXHomeNotice class], @"notices", [ZXDayRec class], @"ranking_goods", [ZXHomeSlides class], @"cbtns", nil];
}

@end

@implementation ZXHomeNotice

@end

@implementation ZXHomeIndexHelper

+ (ZXHomeIndexHelper *)sharedInstance {
    static ZXHomeIndexHelper *homeIndexHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (homeIndexHelper == nil) {
            homeIndexHelper = [[ZXHomeIndexHelper alloc] init];
        }
    });
    return homeIndexHelper;
}

- (void)fetchHomeIndexWithPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:INDEX_START
                                       andParameters:parameters
                                     completionBlock:completionBlock
                                          errorBlock:errorBlock];
}

@end
