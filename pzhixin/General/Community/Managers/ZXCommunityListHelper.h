//
//  ZXCommunityListHelper.h
//  pzhixin
//
//  Created by zhixin on 2020/3/11.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommunityListHelper : NSObject

+ (ZXCommunityListHelper *)sharedInstance;

- (void)fetchCommunityListWithPage:(NSString *)inPage andFid:(NSString *_Nullable)inFid andCid:(NSString *_Nullable)inCid andKeyword:(NSString *_Nullable)inKeyword completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
