//
//  ZXGoodsDetailVC.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXGoods.h"
#import "ZXFavorite.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsDetailVC : UIViewController

@property (strong, nonatomic) ZXGoods *goods;

@property (strong, nonatomic) ZXFavorite *favorite;

@end

NS_ASSUME_NONNULL_END
