//
//  ZXGoodsDetail.h
//  pzhixin
//
//  Created by zhixin on 2019/8/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXGoodsRow.h"
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsDetail : NSObject

@property (strong, nonatomic) NSString *itemId;

@property (strong, nonatomic) NSArray *rel_goods;

@property (strong, nonatomic) ZXGoodsRow *row;


@end

NS_ASSUME_NONNULL_END
