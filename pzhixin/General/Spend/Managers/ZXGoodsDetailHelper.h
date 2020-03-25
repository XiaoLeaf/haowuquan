//
//  ZXGoodsDetailHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/8/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsDetailHelper : NSObject

+ (ZXGoodsDetailHelper *)sharedInstance;

- (void)fetchGoodsDetailWithGoodsId:(NSString *)inGoods_id andItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
