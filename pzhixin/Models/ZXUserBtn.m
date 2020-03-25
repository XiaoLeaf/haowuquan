//
//  ZXUserBtn.m
//  pzhixin
//
//  Created by zhixin on 2019/11/6.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUserBtn.h"

@implementation ZXUserBtn

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
