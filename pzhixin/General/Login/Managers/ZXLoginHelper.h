//
//  ZXLoginHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXLoginHelper : NSObject

+ (ZXLoginHelper *)sharedInstance;

- (void)fetchLoginWithCode:(NSString *)inCode andPush_id:(NSString *)inPush_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

#pragma mark - 登录状态

- (BOOL)loginState;

- (void)setLoginState:(BOOL)state;

#pragma mark - 验证码

- (NSString *)authorization;

- (void)setAuthorization:(NSString *)auth;

@end

NS_ASSUME_NONNULL_END
