//
//  ZXGoods.h
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoods : NSObject

@property (strong, nonatomic) NSString *item_id;

@property (strong, nonatomic) NSString *taobao_id;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *volume;

@property (strong, nonatomic) NSString *store_type;

@property (strong, nonatomic) NSString *coupon_amount;

@property (strong, nonatomic) NSString *commission;

@property (strong, nonatomic) NSString *commission_rate;

@property (strong, nonatomic) NSString *zk_price;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *desc;

@property (strong, nonatomic) NSString *coupon_share_url;

@property (strong, nonatomic) NSArray *slides;

@property (strong, nonatomic) NSString *sotre_id;

@property (strong, nonatomic) NSString *shop_title;

@property (strong, nonatomic) NSString *pre_slide;

@end

NS_ASSUME_NONNULL_END
