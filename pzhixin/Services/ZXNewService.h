//
//  ZXNewService.h
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXNewServiceCompletionBlock)(ZXResponse *response);

typedef void(^ZXNewServiceErrorBlock)(ZXResponse *response);

@interface ZXNewService : NSObject

+ (ZXNewService *)sharedManager;

#pragma mark - 取消当前请求

- (void)cancelCurrentRequest;

#pragma mark - POST请求
/**
 @param inUri 接口地址
 @param inParameters 接口参数
 @param completionBlock 服务器返回status == 200时的block回调
 @param errorBlock 服务器返回status != 200时的回调。服务端返回的特殊status在这进行进一步的处理
 
 除上述两个block回调之外，其余返回的服务器错误统一在这个方法里面进行弹窗提示。
 */
- (void)postRequestWithUri:(NSString *)inUri
             andParameters:(NSMutableDictionary *)inParameters
           completionBlock:(void (^)(ZXResponse * response))completionBlock
                errorBlock:(void (^)(ZXResponse * response))errorBlock;

#pragma mark - GET
/**
 @param inUri 接口地址
 @param completionBlock 请求成功时的block回调
 @param errorBlock 请求失败时的回调。
 */
- (void)getRequestWithUri:(NSString *)inUri
          completionBlock:(void (^)(id result))completionBlock
               errorBlock:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
