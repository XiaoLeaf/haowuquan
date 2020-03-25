//
//  ZXOpenPage.m
//  pzhixin
//
//  Created by zhixin on 2019/10/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOpenPage.h"

@implementation ZXOpenPage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end
