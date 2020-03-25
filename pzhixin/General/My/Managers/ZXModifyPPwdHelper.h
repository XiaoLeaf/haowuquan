//
//  ZXModifyPPwdHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXModifyPPwdHelper : NSObject

+ (ZXModifyPPwdHelper *)sharedInstance;

- (void)fetchModifyPPwdWithStep:(NSString *)inStep andVal:(NSString *_Nullable)inVal andCode:(NSString *_Nullable)inCode completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
