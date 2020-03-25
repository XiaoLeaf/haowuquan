//
//  ZXScoreIndex.m
//  pzhixin
//
//  Created by zhixin on 2019/10/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreIndex.h"

@implementation ZXScoreRule

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXScoreRuleItem class], @"list",  nil];
}

@end

@implementation ZXScoreIndex

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXCommonNotice class], @"notice", [ZXCommonNotice class], @"adp", [ZXScoreDay class], @"day_arr", [ZXScoreRule class], @"rules", [ZXCommonNotice class], @"record", nil];
}

@end
