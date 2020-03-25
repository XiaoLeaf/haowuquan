//
//  ZXModifyTelHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXModifyTelHelper : NSObject

+ (ZXModifyTelHelper *)sharedInstance;

- (void)fetchModifyTelWithStep:(NSString *)inStep andCode:(NSString *)inCode andTel:(NSString *_Nullable)inTel andCodeNew:(NSString *_Nullable)inCodeNew completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
