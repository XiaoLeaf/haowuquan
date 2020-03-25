//
//  ZXPcasJson.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPcasJson.h"

@implementation ZXPcasJson

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"pcid":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXPcasJson class], @"c", nil];
}

@end
