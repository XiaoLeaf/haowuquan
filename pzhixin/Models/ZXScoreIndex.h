//
//  ZXScoreIndex.h
//  pzhixin
//
//  Created by zhixin on 2019/10/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXNotice.h"
#import "ZXScoreDay.h"
#import "ZXScoreRuleItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreRule : NSObject

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) NSString *name;

@end

@interface ZXScoreIndex : NSObject

@property (strong, nonatomic) NSString *score;

@property (strong, nonatomic) NSString *is_signin;

@property (strong, nonatomic) ZXCommonNotice *adp;

@property (strong, nonatomic) ZXCommonNotice *notice;

@property (strong, nonatomic) ZXCommonNotice *record;

@property (strong, nonatomic) NSString *progress;

@property (strong, nonatomic) NSArray *day_arr;

@property (strong, nonatomic) NSArray *rules;

@end

NS_ASSUME_NONNULL_END
