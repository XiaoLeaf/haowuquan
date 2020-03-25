//
//  ZXMyHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXUser.h"
#import "ZXResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyHelper : NSObject

+ (ZXMyHelper *)sharedInstance;

- (void)fetchMyInfoWithCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

#pragma mark - 用户信息

- (ZXUser *)userInfo;

- (void)setUserInfo:(ZXUser *)userInfo;

@end

NS_ASSUME_NONNULL_END
