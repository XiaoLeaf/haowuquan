//
//  ZXOrderListHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCommonNotice.h"
#import "ZXOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXOrderStatus : NSObject

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) NSString *val;

@end

@interface ZXOrderList : NSObject

@property (assign, nonatomic) NSInteger pagesize;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) ZXCommonNotice *notice;

@property (strong, nonatomic) NSDictionary *date_arr;

@property (strong, nonatomic) NSArray *status_arr;

@property (strong, nonatomic) NSArray *mine_arr;

@property (assign, nonatomic) NSInteger status_def;

@property (assign, nonatomic) NSInteger mine_def;

@end

@interface ZXOrderListHelper : NSObject

+ (ZXOrderListHelper *)sharedInstance;

- (void)fetchOrderListWithPage:(NSString *)inPage andMine:(NSString *)inMine andStatus:(NSString *)inStatus andS_time:(NSString *_Nullable)inS_time andE_time:(NSString *_Nullable)inE_time completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
