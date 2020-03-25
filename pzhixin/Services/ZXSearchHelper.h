//
//  ZXSearchHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommonSearch : NSObject

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *goods_id;

@property (strong, nonatomic) NSString *item_id;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *shop_type;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *commission;

@property (strong, nonatomic) NSString *max_commission;

@property (strong, nonatomic) NSString *coupon_amount;

@property (strong, nonatomic) NSString *pre_slide;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXSearchHelper : NSObject

+ (ZXSearchHelper *)sharedInstance;

- (void)fetchSearchGoodsWithContent:(NSString *)inContent andFrom:(NSString *)inFrom completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
