//
//  ZXRedEnvelop.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXRedBtn.h"
#import "ZXOpenPage.h"
#import "ZXRedTxt.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXRedEnvelop : NSObject

@property (strong, nonatomic) NSString *red_id;

@property (strong, nonatomic) NSString *cache_key;

@property (strong, nonatomic) NSString *need;

@property (strong, nonatomic) NSString *bg;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *url_schema;

@property (strong, nonatomic) ZXRedBtn *btn;

@property (strong, nonatomic) ZXRedTxt *txt;

@property (strong, nonatomic) ZXOpenPage *params;

@property (assign, nonatomic) BOOL showed;

@end

NS_ASSUME_NONNULL_END
