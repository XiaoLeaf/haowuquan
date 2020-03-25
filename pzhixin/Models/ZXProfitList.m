//
//  ZXProfitList.m
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProfitList.h"

@implementation ZXProfitList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXUser class], @"user", nil];
}

@end
