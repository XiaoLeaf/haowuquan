//
//  ZXSearchInitHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSearchInitBanner : NSObject

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXSearchKeyword : NSObject

@property (strong, nonatomic) NSString *val;

@property (strong, nonatomic) NSString *color;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXSearchInit : NSObject

@property (strong, nonatomic) NSArray *keywords;

@property (strong, nonatomic) ZXSearchInitBanner *banner;

@end

@interface ZXSearchInitHelper : NSObject

+ (ZXSearchInitHelper *)sharedInstance;

- (void)fetchSearchInitWithMore:(NSString *)inMore completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
