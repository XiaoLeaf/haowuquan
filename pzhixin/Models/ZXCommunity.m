//
//  ZXCommunity.m
//  pzhixin
//
//  Created by zhixin on 2020/3/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXCommunity.h"

@implementation ZXCommunity

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXCommunityGrow class], @"grow", [ZXCommunityAuthor class], @"author", [ZXCommunityDetail class], @"detail", [ZXCommunityComment class], @"comment", nil];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将community_id映射到key为id的数据字段
    return @{@"community_id":@"id"};
}

@end
