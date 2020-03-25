//
//  ZXDelFavoriteHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDelFavoriteHelper : NSObject

+ (ZXDelFavoriteHelper *)sharedInstance;

- (void)fetchDelFavoriteWithIds:(NSString *)inIds completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
