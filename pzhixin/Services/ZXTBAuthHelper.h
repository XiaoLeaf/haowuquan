//
//  ZXTBAuthHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXTBAuthHelper : NSObject

+ (ZXTBAuthHelper *)sharedInstance;

- (void)fetchTBAuthWithCode:(NSString *)inCode completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

#pragma mark - 授权状态

- (BOOL)tbAuthState;

- (void)setTBAuthState:(BOOL)state;

- (NSString *)relationId;

- (void)setRelationId:(NSString *)relationId;

@end

NS_ASSUME_NONNULL_END
