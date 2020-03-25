//
//  ZXGetGiftHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXGetGiftHelper : NSObject

+ (ZXGetGiftHelper *)sharedInstance;

- (void)fetchGetGiftWithId:(NSString *)inId Completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
