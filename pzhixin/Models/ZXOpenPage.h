//
//  ZXOpenPage.h
//  pzhixin
//
//  Created by zhixin on 2019/10/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXOpenPage : NSObject

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *url_schame;

@property (strong, nonatomic) NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
