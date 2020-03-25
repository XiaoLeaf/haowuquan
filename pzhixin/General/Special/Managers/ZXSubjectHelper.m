//
//  ZXSubjectHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSubjectHelper.h"

@implementation ZXSubjectParam

@end

@implementation ZXSubjectCat

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将catId映射到key为id的数据字段
    return @{@"catId":@"id"};
}

@end

@implementation ZXSubjectSlide

@end

@implementation ZXSubjectResult

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXSubjectCat class], @"category", [ZXGoods class], @"list", [ZXSubjectSlide class], @"slides", nil];
}

@end

@implementation ZXSubjectHelper

+ (ZXSubjectHelper *)sharedInstance {
    static ZXSubjectHelper *subjectHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (subjectHelper == nil) {
            subjectHelper = [[ZXSubjectHelper alloc] init];
        }
    });
    return subjectHelper;
}

- (void)fetchSubjectWithSid:(NSString *)inSid andCid:(NSString *)inCid andPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inSid != nil) {
        [parameters addEntriesFromDictionary:@{@"sid":inSid}];
    }
    if (inCid != nil) {
        [parameters addEntriesFromDictionary:@{@"cid":inCid}];
    }
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:GOODS_SUBJECT andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
