//
//  ZXResponse.h
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXResponse : NSObject

@property (assign, nonatomic) NSInteger status;

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) NSString *info;

@end

NS_ASSUME_NONNULL_END
