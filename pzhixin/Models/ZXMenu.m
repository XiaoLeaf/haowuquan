//
//  ZXMenu.m
//  pzhixin
//
//  Created by zhixin on 2019/10/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMenu.h"

@implementation ZXMenu

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将menu_id映射到key为id的数据字段
    return @{@"menu_id":@"id"};
}

@end
