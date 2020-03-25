//
//  ZXGuessLikeHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGuessLikeHelper : NSObject

+ (ZXGuessLikeHelper *)sharedInstance;

- (void)fetchGuessLikeWithPage:(NSString *)inPage andSort:(NSString *)inSort completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
