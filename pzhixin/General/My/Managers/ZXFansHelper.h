//
//  ZXFansHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXFansHelper : NSObject

+ (ZXFansHelper *)sharedInstance;

- (void)fetchFansWithPage:(NSString *)inPage andType:(NSString *)inType andOrder:(NSString *)inOrder completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
