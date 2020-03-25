//
//  ZXProfitListHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXProfitList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXProfitTypeItem : NSObject

@property (strong, nonatomic) NSString *val;

@property (strong, nonatomic) NSString *key;

@end

@interface ZXProfitListRes : NSObject

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *account_str;

@property (strong, nonatomic) NSString *profit_str;

@property (strong, nonatomic) NSDictionary *date_arr;

@property (strong, nonatomic) NSArray *mine_arr;

@property (strong, nonatomic) NSString *mine_def;

@property (strong, nonatomic) NSArray *type_arr;

@property (strong, nonatomic) NSString *type_def;

@property (strong, nonatomic) NSString *sum;

@property (assign, nonatomic) NSInteger pagesize;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) ZXCommonNotice *notice;

@end

@interface ZXProfitListHelper : NSObject

+ (ZXProfitListHelper *)sharedInstance;

- (void)fetchProfitListWithPage:(NSString *)inPage andMine:(NSString *)inMine andType:(NSString *)inType andS_time:(NSString *_Nullable)inS_time andE_time:(NSString *_Nullable)inE_time completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
