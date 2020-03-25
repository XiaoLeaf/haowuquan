//
//  ZXProfit.h
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXProfitList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXProfit : NSObject

@property (strong, nonatomic) NSString *s_time;

@property (strong, nonatomic) NSString *e_time;

@property (strong, nonatomic) NSString *sum;

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *account_str;

@property (strong, nonatomic) NSString *profit_str;

@property (strong, nonatomic) NSArray *list;

@end

NS_ASSUME_NONNULL_END
