//
//  ZXAddrInfoHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddrInfoHelper : NSObject

+ (ZXAddrInfoHelper *)sharedInstance;

/**
 @param inAct  save为保存；为空时初始化
 @param inId  ==0新增；id > 0 编辑/保存
 @param inRealname 收货人姓名
 @param inTel 收货人手机号码
 @param inProv_id 省级区域id
 @param inCity_id 市级区域id
 @param inArea_id 区级区域id
 @param inStreet_id 街道区域id
 @param inAddress 地址
 @param inIs_def 是否为默认
 */

- (void)fetchAddrInfoWithAct:(NSString *)inAct andId:(NSString *)inId andRealName:(NSString *)inRealname andTel:(NSString *)inTel andProv_id:(NSString *)inProv_id andCity_id:(NSString *)inCity_id andArea_id:(NSString *)inArea_id andStreer_id:(NSString *)inStreet_id andAddress:(NSString *)inAddress andIs_def:(NSString *)inIs_def Completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
