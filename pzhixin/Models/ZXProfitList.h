//
//  ZXProfitList.h
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXProfitList : NSObject

@property (strong, nonatomic) NSString *order_id;

@property (strong, nonatomic) NSString *item_id;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *order_type;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *earning_time;

@property (strong, nonatomic) NSString *amount;

@property (strong, nonatomic) NSString *status_str;

@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *bonus;

@property (strong, nonatomic) ZXUser *user;

@end

NS_ASSUME_NONNULL_END
