//
//  ZXSpendViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXSpendVCSingleCellDidSelect)(ZXGoods *goods);

typedef void(^ZXSpendVCDoubleCellLeftGoodsClick)(ZXGoods *goods);

typedef void(^ZXSpendVCDoubleCellRightGoodsClick)(ZXGoods *goods);

@interface ZXSpendViewController : UIViewController

@property (assign, nonatomic) NSInteger sortId;

@property (copy, nonatomic) ZXSpendVCSingleCellDidSelect zxSpendVCSingleCellDidSelect;

@property (copy, nonatomic) ZXSpendVCDoubleCellLeftGoodsClick zxSpendVCDoubleCellLeftGoodsClick;

@property (copy, nonatomic) ZXSpendVCDoubleCellRightGoodsClick zxSpendVCDoubleCellRightGoodsClick;

@end

NS_ASSUME_NONNULL_END
