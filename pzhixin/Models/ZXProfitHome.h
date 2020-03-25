//
//  ZXProfitHome.h
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXProfitDetail.h"
#import "ZXProfitFaq.h"
#import "ZXNotice.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXProfitSubItem : NSObject

@property (strong, nonatomic) NSString *txt;

@property (strong, nonatomic) NSString *val;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXProfitItem : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSArray *items;

@end

@interface ZXProfitHome : NSObject

@property (strong, nonatomic) NSString *money;

@property (strong, nonatomic) NSString *profit_total;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) ZXProfitDetail *day;

@property (strong, nonatomic) ZXProfitDetail *yesterday;

@property (strong, nonatomic) ZXProfitDetail *month;

@property (strong, nonatomic) ZXProfitDetail *last_month;

@property (strong, nonatomic) ZXCommonNotice *notice;

@end

NS_ASSUME_NONNULL_END
