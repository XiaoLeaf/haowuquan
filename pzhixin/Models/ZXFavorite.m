//
//  ZXFavorite.m
//  pzhixin
//
//  Created by zhixin on 2019/9/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavorite.h"

@implementation ZXFavorite

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将zx_id映射到key为id的数据字段
    return @{@"zx_id":@"id"};
}

@end
