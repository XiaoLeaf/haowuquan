//
//  ZXSucceedShareHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/12/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSucceedShareHelper : NSObject

+ (ZXSucceedShareHelper *)sharedInstance;

/**
 @parameters inType 1、商品；2、邀请页；3、社区；9、URL。
 @parameters inRel_id type = 1时的商品id；type=2时海报id；type=3时社区id；type=9时为空
 @parameters inUrl type = 9时的链接
 */

- (void)fetchSucceedShareWithType:(NSString *)inType andRel_id:(NSString *_Nullable)inRel_id andUrl:(NSString *_Nullable)inUrl completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
