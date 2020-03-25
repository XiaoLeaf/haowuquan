//
//  ZXUserStat.h
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXMyMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXUserStat : NSObject

@property (strong, nonatomic) NSString *coupon_num;

@property (strong, nonatomic) NSString *day_profit;

@property (strong, nonatomic) NSString *last_month_predict;

@property (strong, nonatomic) NSString *last_month_profit;

@property (strong, nonatomic) NSString *money;

@property (strong, nonatomic) NSString *month_profit;

@property (strong, nonatomic) NSString *profit;

@property (strong, nonatomic) NSString *score;

@end

NS_ASSUME_NONNULL_END
