//
//  ZXSearchListHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSearchListHelper : NSObject

+ (ZXSearchListHelper *)sharedInstance;

- (void)fetchSearchListWithPage:(NSString *)inPage andKeywords:(NSString *)inKeywords andSort:(NSString *)inSort completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
