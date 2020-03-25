//
//  ZXOrderClaimHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXOrderClaimHelper.h"

static ZXOrderClaimHelper *orderClaimHelper = nil;

@interface ZXOrderClaimHelper () {
    id claimTarget;
    SEL claimAction;
}

@end

@implementation ZXOrderClaimHelper

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (ZXOrderClaimHelper *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (orderClaimHelper == nil) {
            orderClaimHelper = [[ZXOrderClaimHelper alloc] init];
        }
    });
    return orderClaimHelper;
}

@end
