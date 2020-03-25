//
//  ZXAddrListHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddrItem : NSObject

@property (strong, nonatomic) NSString *addrId;

@property (strong, nonatomic) NSString *realname;

@property (strong, nonatomic) NSString *tel;

@property (strong, nonatomic) NSString *prov_id;

@property (strong, nonatomic) NSString *city_id;

@property (strong, nonatomic) NSString *area_id;

@property (strong, nonatomic) NSString *street_id;

@property (strong, nonatomic) NSString *pcas;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *is_def;

@property (strong, nonatomic) NSString *is_ht;

@end

@interface ZXAddrRes : NSObject

@property (strong, nonatomic) NSArray *list;

@end

@interface ZXAddrListHelper : NSObject

+ (ZXAddrListHelper *)sharedInstance;

- (void)fetchAddrListCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
