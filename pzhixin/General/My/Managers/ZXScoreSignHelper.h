//
//  ZXScoreSignHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/22.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreSignHelper : NSObject

+ (ZXScoreSignHelper *)sharedInstance;

- (void)fetchScoreSignCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
