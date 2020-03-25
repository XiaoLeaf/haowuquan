//
//  ZXAddrListHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddrListHelper.h"

@implementation ZXAddrItem

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将addrId映射到key为id的数据字段
    return @{@"addrId":@"id"};
}

- (id)copyWithZone:(NSZone *)zone {
    ZXAddrItem *addrItem = [[self class] allocWithZone:zone];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([ZXAddrItem class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [addrItem setValue:propertyValue forKey:propertyName];
        }
    }
    return addrItem;
}

@end

@implementation ZXAddrRes

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXAddrItem class], @"list", nil];
}

@end

@implementation ZXAddrListHelper

+ (ZXAddrListHelper *)sharedInstance {
    static ZXAddrListHelper *addrListHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (addrListHelper == nil) {
            addrListHelper = [[ZXAddrListHelper alloc] init];
        }
    });
    return addrListHelper;
}

- (void)fetchAddrListCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    [[ZXNewService sharedManager] postRequestWithUri:ADDR andParameters:[NSMutableDictionary new] completionBlock:completionBlock errorBlock:errorBlock];
}

@end
