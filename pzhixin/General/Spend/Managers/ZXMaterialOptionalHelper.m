//
//  ZXMaterialOptionalHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/8/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMaterialOptionalHelper.h"

@implementation ZXMaterial

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXGoods class], @"goods", [ZXSubjectSlide class], @"slides",  nil];
}

@end

@implementation ZXMaterialOptionalHelper

+ (ZXMaterialOptionalHelper *)sharedInstance {
    static ZXMaterialOptionalHelper *materialOptionalHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (materialOptionalHelper == nil) {
            materialOptionalHelper = [[ZXMaterialOptionalHelper alloc] init];
        }
    });
    return materialOptionalHelper;
}

- (void)fetchMaterialOptionalWithPage:(NSString *)inPage andCat_id:(NSString *_Nullable)inCat_id andSort:(NSString *)inSort completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    if (inCat_id != nil) {
        [parameters addEntriesFromDictionary:@{@"cid":inCat_id}];
    }
    if (inSort != nil) {
        [parameters addEntriesFromDictionary:@{@"sort":inSort}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:MATERIAL_OPTIONAL andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
