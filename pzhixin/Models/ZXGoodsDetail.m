//
//  ZXGoodsDetail.m
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGoodsDetail.h"

@implementation ZXGoodsDetail

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXGoodsRow class], @"row", [ZXGoods class], @"rel_goods", nil];
}


+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"itemId":@"id"};
}

@end
