//
//  ZXNotice.m
//  pzhixin
//
//  Created by zhixin on 2019/10/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNotice.h"

@implementation ZXNotice

- (id)init {
    self = [super init];
    if (self) {
        _url = @"";
        _title = @"";
        _is_fullpage = @"0";
        _bar_style = @"dark";
        _bar_bgcolor = @"EDEDED";
        _btn = @[@"1", @"0", @"0"];
        _bounce = NO;
    }
    return self;
}

@end
