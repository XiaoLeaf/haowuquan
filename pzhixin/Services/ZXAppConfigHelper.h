//
//  ZXAppConfigHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXLoadingAsset.h"
#import "ZXClassify.h"
#import "ZXMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXPolicy: NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *content;

@end

@interface ZXConfigH5Item : NSObject

@property (strong, nonatomic) NSString *txt;

@property (strong, nonatomic) NSString *url_schema;

@property (strong, nonatomic) NSString *url;

@end

@interface ZXConfigH5 : NSObject

@property (strong, nonatomic) ZXConfigH5Item *agreement;

@property (strong, nonatomic) ZXConfigH5Item *feedback;

@property (strong, nonatomic) ZXConfigH5Item *intro;

@property (strong, nonatomic) ZXConfigH5Item *member;

@property (strong, nonatomic) ZXConfigH5Item *unable_login;

@property (strong, nonatomic) ZXConfigH5Item *message;

@end

@interface ZXAppConfig : NSObject

@property (strong, nonatomic) NSArray *cats;

@property (strong, nonatomic) NSString *copyright;

@property (strong, nonatomic) ZXConfigH5 *h5;

@property (strong, nonatomic) ZXLoadingAsset *img_res;

@property (strong, nonatomic) NSArray *menus;

@property (strong, nonatomic) NSString *tb_auth_url;

@property (strong, nonatomic) NSString *tb_hack_js;

@property (strong, nonatomic) NSString *tb_auth_check_str;

@property (strong, nonatomic) ZXPolicy *policy;

@property (strong, nonatomic) UIImage *small_img;

@property (strong, nonatomic) UIImage *big_img;

@end

@interface ZXAppConfigHelper : NSObject

+ (ZXAppConfigHelper *)sharedInstance;

- (void)fetchAPPConfigCompletion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

- (NSArray *)classifyList;

- (void)setClassifyList:(NSArray *)classifyList;

- (NSString *)taobaoAuthUrl;

- (void)setTaobaoAuthUrl:(NSString *)taobaoAuthUrl;

- (NSString *)welfareUrl;

- (void)setWelfareUrl:(NSString *)welfareUrl;

- (NSString *)registrationID;

- (void)setRegistrationID:(NSString *)registrationID;

#pragma mark - loading

- (ZXLoadingAsset *)loadingAsset;

- (void)setLoadingAsset:(ZXLoadingAsset *)loadingAsset;

#pragma mark - APP配置信息

- (ZXAppConfig *)appConfig;

- (void)setAppConfig:(ZXAppConfig *)appConfig;

#pragma mark - Badge

- (NSInteger)appBadge;

- (void)setAppBadge:(NSInteger)appBadge;

@end

NS_ASSUME_NONNULL_END
