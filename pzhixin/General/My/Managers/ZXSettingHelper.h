//
//  ZXSettingHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSettingRes : NSObject

@property (strong, nonatomic) NSString *val;

@end

@interface ZXSettingHelper : NSObject

+ (ZXSettingHelper *)sharedInstance;

- (void)fetchSettingWithType:(NSString *)inType andVal:(NSString *)inVal completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
