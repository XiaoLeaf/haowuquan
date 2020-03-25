//
//  ZXMiniApp.m
//  pzhixin
//
//  Created by zhixin on 2019/12/4.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMiniApp.h"

@implementation ZXMiniApp

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将originalId映射到key为id的数据字段
    return @{@"originalId":@"username"};
}

@end
