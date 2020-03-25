//
//  ZXCashList.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashList.h"

@implementation ZXCashList

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将classifyId映射到key为id的数据字段
    return @{@"cash_id":@"id"};
}

@end
