//
//  ZXMyMenu.m
//  pzhixin
//
//  Created by zhixin on 2019/11/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyMenu.h"

@implementation ZXMyMenu

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXMyMenuItem class], @"list", nil];
}

@end
