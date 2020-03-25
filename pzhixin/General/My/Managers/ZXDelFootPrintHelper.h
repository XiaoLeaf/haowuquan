//
//  ZXDelFootPrintHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDelFootPrintHelper : NSObject

+ (ZXDelFootPrintHelper *)sharedInstance;

- (void)fetchDelFootPrintWithIds:(NSString *)inIds completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
