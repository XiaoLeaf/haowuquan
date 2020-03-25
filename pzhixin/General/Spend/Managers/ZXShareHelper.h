//
//  ZXShareHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/4.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsShare : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *desc;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *ori_price;

@property (strong, nonatomic) NSString *commission;

@property (strong, nonatomic) NSString *commission_txt;

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSArray *slides;

@property (strong, nonatomic) NSArray *slides_thumb;

@property (strong, nonatomic) NSString *icode;

@property (strong, nonatomic) NSString *tpwd;

@property (strong, nonatomic) NSString *share_url;

@property (strong, nonatomic) NSString *qrcode_url;

@property (strong, nonatomic) NSString *qr_bg;

@property (strong, nonatomic) NSString *shop_type;

@property (strong, nonatomic) NSString *share_logo;

@property (strong, nonatomic) NSString *top_txt;

@property (strong, nonatomic) NSArray *share_txt;

@end

@interface ZXShareHelper : NSObject

+ (ZXShareHelper *)sharedInstance;

- (void)fetchSharelWithGoodsId:(NSString *)inGoods_id andItem_id:(NSString *)inItem_id completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
