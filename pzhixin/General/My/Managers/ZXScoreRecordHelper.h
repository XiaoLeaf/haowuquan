//
//  ZXScoreRecordHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreRecordHelper : NSObject

+ (ZXScoreRecordHelper *)sharedInstance;

- (void)fetchScoreRecordCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
