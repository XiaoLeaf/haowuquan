//
//  ZXCodeHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCodeHelper : NSObject

+ (ZXCodeHelper *)sharedInstance;

- (void)fetchCodeWithType:(NSString *)inType andTel:(NSString *_Nullable)inTel andUser_id:(NSString *_Nullable)inUser_id andUniondid:(NSString *_Nullable)inUnionid completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
