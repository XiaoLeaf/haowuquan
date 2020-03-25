//
//  ZXGetWordHelper.h
//  pzhixin
//
//  Created by zhixin on 2020/3/14.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGetWordHelper : NSObject

+ (ZXGetWordHelper *)sharedInstance;

- (void)fetchCommunityWordWithParams:(NSString *)inParams completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
