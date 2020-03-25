//
//  ZXGoods.m
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGoods.h"

@implementation ZXGoods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"item_id":@"id", @"taobao_id":@"item_id", @"store_type":@"shop_type", @"zk_price":@"ori_price"};
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
