//
//  ZXAddrOptHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddrOptHelper : NSObject

+ (ZXAddrOptHelper *)sharedInstance;

- (void)fetchAddrOptWithAct:(NSString *)inAct andId:(NSString *)inId completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
