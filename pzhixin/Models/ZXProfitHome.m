//
//  ZXProfitHome.m
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProfitHome.h"

@implementation ZXProfitSubItem

@end

@implementation ZXProfitItem

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXProfitSubItem class], @"items", nil];
}

@end

@implementation ZXProfitHome

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXCommonNotice class], @"faq", [ZXProfitItem class], @"list", nil];
}

@end
