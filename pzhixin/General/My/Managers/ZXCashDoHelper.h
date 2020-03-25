//
//  ZXCashDoHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCashDoHelper : NSObject

+ (ZXCashDoHelper *)sharedInstance;

- (void)fetchCashDoWithAmount:(NSString *)inAmount andPwd:(NSString *_Nullable)inPwd completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
