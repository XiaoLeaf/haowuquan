//
//  ZXProfitHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXProfitHelper : NSObject

+ (ZXProfitHelper *)sharedInstance;

- (void)fetchProfitWithCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
