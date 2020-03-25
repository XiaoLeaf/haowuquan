//
//  ZXUrlCouponHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXUrlCoupon : NSObject

@property (strong, nonatomic) NSString *item_id;

@property (strong, nonatomic) NSString *js;

@property (strong, nonatomic) NSString *coupon_amount;

@property (strong, nonatomic) NSString *commission;

@end

@interface ZXUrlCouponHelper : NSObject

+ (ZXUrlCouponHelper *)sharedInstance;

- (void)fetchUrlCouponWithUrl:(NSString *)inUrl completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
