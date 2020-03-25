//
//  ZXFootPrintHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFootPrintHelper.h"

@implementation ZXFootPrintHelper

+ (ZXFootPrintHelper *)sharedInstance {
    static ZXFootPrintHelper *footPrintHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (footPrintHelper == nil) {
            footPrintHelper = [[ZXFootPrintHelper alloc] init];
        }
    });
    return footPrintHelper;
}

- (void)fetchFootPrintWithPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (inPage != nil) {
        [parameters addEntriesFromDictionary:@{@"page":inPage}];
    }
    [[ZXNewService sharedManager] postRequestWithUri:FOOTPRINT andParameters:parameters completionBlock:completionBlock errorBlock:errorBlock];
}

@end
