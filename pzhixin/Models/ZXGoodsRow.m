//
//  ZXGoodsRow.m
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGoodsRow.h"

@implementation ZXGoodsUp

@end

@implementation ZXGoodsRow

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"itemId":@"id",@"taobaoId":@"item_id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXGoodsUp class], @"up_arr", nil];
}

@end

