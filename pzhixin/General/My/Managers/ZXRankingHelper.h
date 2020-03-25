//
//  ZXRankingHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXRanking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXRankNotice : NSObject

@property (strong, nonatomic) NSString *txt;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXRankingType : NSObject

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) NSString *val;

@end

@interface ZXRankingRes : NSObject

@property (assign, nonatomic) NSInteger pagesize;

@property (strong, nonatomic) NSArray *type_arr;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) NSArray *notice;

@end

@interface ZXRankingHelper : NSObject

+ (ZXRankingHelper *)sharedInstance;

- (void)fetchRankingWithPage:(NSString *)inPage andType:(NSString *)inType completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
