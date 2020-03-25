//
//  ZXAuthBindHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAuthBindHelper : NSObject

+ (ZXAuthBindHelper *)sharedInstance;

- (void)fetchAuthBindWithRef:(NSString *)inRef andStep:(NSString *)inStep completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
