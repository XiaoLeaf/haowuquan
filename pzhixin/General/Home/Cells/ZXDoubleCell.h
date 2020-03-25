//
//  ZXDoubleCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXDoubleCellLeftGoodsClick)(NSInteger viewTag);

typedef void(^ZXDoubleCellRightGoodsClick)(NSInteger viewTag);

@interface ZXDoubleCell : UITableViewCell

@property (strong, nonatomic) ZXGoods *leftGoods;

@property (strong, nonatomic) ZXGoods *rightGoods;

@property (weak, nonatomic) IBOutlet UIView *leftGoodsView;

@property (weak, nonatomic) IBOutlet UIView *rightGoodsView;

@property (copy, nonatomic) ZXDoubleCellLeftGoodsClick zxDoubleCellLeftGoodsClick;

@property (copy, nonatomic) ZXDoubleCellRightGoodsClick zxDoubleCellRightGoodsClick;

@end

NS_ASSUME_NONNULL_END
