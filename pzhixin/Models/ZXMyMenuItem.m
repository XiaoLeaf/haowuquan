//
//  ZXMyMenuItem.m
//  pzhixin
//
//  Created by zhixin on 2019/11/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyMenuItem.h"

@implementation ZXMyMenuItem

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
