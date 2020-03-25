//
//  ZXProfit.m
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProfit.h"

@implementation ZXProfit

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXProfitList class], @"list", nil];
}

@end
