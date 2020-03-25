//
//  ZXGoodsRow.h
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsUp : NSObject

@property (strong, nonatomic) NSString *txt;

@property (strong, nonatomic) NSString *btn_txt;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXGoodsRow : NSObject

@property (strong, nonatomic) NSString *commission;

@property (strong, nonatomic) NSArray *content;

@property (strong, nonatomic) NSString *coupon_amount;

@property (strong, nonatomic) NSString *coupon_info;

@property (strong, nonatomic) NSString *coupon_end_time;

@property (strong, nonatomic) NSString *coupon_start_time;

@property (strong, nonatomic) NSString *desc;

@property (strong, nonatomic) NSString *itemId;

@property (strong, nonatomic) NSString *taobaoId;

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *ori_price;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSArray *score;

@property (strong, nonatomic) NSString *shop_des_score;

@property (strong, nonatomic) NSString *shop_dsr;

@property (strong, nonatomic) NSString *shop_dev_score;

@property (strong, nonatomic) NSString *shop_icon;

@property (strong, nonatomic) NSString *shop_sell_count;

@property (strong, nonatomic) NSString *shop_ser_score;

@property (strong, nonatomic) NSString *shop_title;

@property (strong, nonatomic) NSString *shop_type;

@property (strong, nonatomic) NSArray *slides;

@property (strong, nonatomic) NSArray *slides_thumb;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *video;

@property (strong, nonatomic) NSString *volume;

@property (strong, nonatomic) NSString *is_fav;

@property (strong, nonatomic) ZXGoodsUp *up_arr;

@end

NS_ASSUME_NONNULL_END
