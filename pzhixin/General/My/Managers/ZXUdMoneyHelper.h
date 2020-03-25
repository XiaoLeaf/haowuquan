//
//  ZXUdMoneyHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/9/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXUdMoneyHelper : NSObject

+ (ZXUdMoneyHelper *)sharedInstance;

- (void)fetchMoneyWithPage:(NSString *)inPage
                andType:(NSString *)inType
                andS_time:(NSString *_Nullable)inS_time
                andE_time:(NSString *_Nullable)inE_time
                completion:(void (^)(ZXResponse * response))completionBlock
                     error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
