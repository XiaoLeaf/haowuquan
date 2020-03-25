//
//  ZXRedEnvelop.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRedEnvelop.h"

@implementation ZXRedEnvelop

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"red_id":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXRedBtn class], @"btn", [ZXOpenPage class], @"params", [ZXRedTxt class], @"txt", nil];
}

@end
