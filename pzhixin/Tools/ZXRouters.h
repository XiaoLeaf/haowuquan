//
//  ZXRouters.h
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPushObj : NSObject

@property (strong, nonatomic) NSDictionary *params;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXRouters : NSObject

#pragma mark - Public Methods

+ (ZXRouters *)sharedInstance;

- (void)openPageWithUrl:(NSString *)pageUrl andUserInfo:(id _Nullable)userInfo viewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
