//
//  ZXPhoneBindLoginHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPhoneBindLoginHelper : NSObject

+ (ZXPhoneBindLoginHelper *)sharedInstance;

- (void)fetchBindOrLoginWithTel:(NSString *)inTel andCode:(NSString *)inCode andUnionid:(NSString *)inUnionid andUser_id:(NSString *)inUser_id andType:(NSString *)inType andPush_id:(NSString *)inPush_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
