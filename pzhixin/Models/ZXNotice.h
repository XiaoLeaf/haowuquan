//
//  ZXNotice.h
//  pzhixin
//
//  Created by zhixin on 2019/10/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNotice : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) NSString *is_fullpage;

@property (strong, nonatomic) NSString *bar_style;

@property (strong, nonatomic) NSString *bar_bgcolor;

@property (strong, nonatomic) NSArray *btn;

@property (assign, nonatomic) BOOL bounce;


@end

NS_ASSUME_NONNULL_END
