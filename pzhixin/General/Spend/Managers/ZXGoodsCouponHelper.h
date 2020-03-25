//
//  ZXGoodsCouponHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsCouponHelper : NSObject

+ (ZXGoodsCouponHelper *)sharedInstance;

- (void)fetchGoodsCouponWithId:(NSString *)inId andItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
