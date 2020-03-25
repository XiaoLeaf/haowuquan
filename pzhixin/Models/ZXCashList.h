//
//  ZXCashList.h
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCashList : NSObject

@property (strong, nonatomic) NSString *cash_id;

@property (strong, nonatomic) NSString *amount;

@property (strong, nonatomic) NSString *c_time;

@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *s_time;

@property (strong, nonatomic) NSString *memo;

@property (strong, nonatomic) NSString *status_str;

@end

NS_ASSUME_NONNULL_END
