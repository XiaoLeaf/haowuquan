//
//  ZXUserStat.m
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUserStat.h"

@implementation ZXUserStat

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
