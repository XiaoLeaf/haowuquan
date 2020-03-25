//
//  ZXHomeIndexHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/10/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXRedEnvelop.h"
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXDayRec : NSObject

@property (strong, nonatomic) NSString *banner;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXHomeSlides : NSObject

@property (strong, nonatomic) NSString *bg_color;

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXHomeNotice : NSObject

@property (strong, nonatomic) NSString *is_new;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXHomeIndex : NSObject

@property (strong, nonatomic) NSArray *gift_arr;

@property (strong, nonatomic) ZXDayRec *day_rec;

@property (strong, nonatomic) NSArray *slides;

@property (strong, nonatomic) NSArray *main_ads;

@property (strong, nonatomic) NSArray *notices;

@property (strong, nonatomic) ZXDayRec *ranking_goods;

@property (strong, nonatomic) NSArray *cbtns;

@end

@interface ZXHomeIndexHelper : NSObject

+ (ZXHomeIndexHelper *)sharedInstance;

- (void)fetchHomeIndexWithPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
