//
//  ZXUser.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXUser.h"

@implementation ZXUserGender

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

@end

@implementation ZXUser

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXUserStat class], @"stat", [ZXWXTmp class], @"wxtmp", [ZXUserBtn class], @"hbtns", [ZXUserBtn class], @"sbtns", [ZXUserGender class], @"gender_arr", [ZXMyMenu class], @"main_menus", [ZXMyMenu class], @"games_menus", [ZXMyMenu class], @"public_menus", nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
