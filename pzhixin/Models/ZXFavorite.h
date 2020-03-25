//
//  ZXFavorite.h
//  pzhixin
//
//  Created by zhixin on 2019/9/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXFavorite : NSObject

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) NSString *coupon_amount;

@property (strong, nonatomic) NSString *commission;

@property (strong, nonatomic) NSString *gid;

@property (strong, nonatomic) NSString *zx_id;

@property (strong, nonatomic) NSString *item_id;

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *ori_price;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *shop_type;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *u_time;

@property (strong, nonatomic) NSString *volume;

@end

NS_ASSUME_NONNULL_END
