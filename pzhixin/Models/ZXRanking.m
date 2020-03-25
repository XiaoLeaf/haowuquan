//
//  ZXRanking.m
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRanking.h"

@implementation ZXRanking

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXUser class], @"user", nil];
}

@end
