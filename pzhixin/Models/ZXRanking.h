//
//  ZXRanking.h
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXRanking : NSObject

@property (strong, nonatomic) NSString *no;

@property (strong, nonatomic) NSString *amount;

@property (strong, nonatomic) ZXUser *user;

@end

NS_ASSUME_NONNULL_END
