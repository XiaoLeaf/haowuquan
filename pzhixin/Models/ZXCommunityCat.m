//
//  ZXCommunityCat.m
//  pzhixin
//
//  Created by zhixin on 2020/3/14.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXCommunityCat.h"

@implementation ZXCommunityCat

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXCommunityCat class], @"child", nil];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将cid映射到key为id的数据字段
    return @{@"cid":@"id"};
}

@end
