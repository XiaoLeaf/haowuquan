//
//  ZXScoreReceiveHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreReceiveHelper : NSObject

+ (ZXScoreReceiveHelper *)sharedInstance;

- (void)fetchScoreReceiveWithId:(NSString *)inId completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
