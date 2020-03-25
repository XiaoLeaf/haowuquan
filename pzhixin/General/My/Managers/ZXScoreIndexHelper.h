//
//  ZXScoreIndexHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreIndexHelper : NSObject

+ (ZXScoreIndexHelper *)sharedInstance;

- (void)fetchScoreIndexCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
