//
//  ZXScoreRuleItem.m
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreRuleItem.h"

@implementation ZXScoreRuleItem

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将item_id映射到key为id的数据字段
    return @{@"item_id":@"id"};
}

@end
