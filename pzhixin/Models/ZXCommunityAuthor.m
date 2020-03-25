//
//  ZXCommunityAuthor.m
//  pzhixin
//
//  Created by zhixin on 2020/3/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXCommunityAuthor.h"

@implementation ZXCommunityAuthor

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将author_id映射到key为id的数据字段
    return @{@"author_id":@"id"};
}

@end
