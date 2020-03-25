//
//  ZXNewSpendHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/10/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXClassify.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXNewSpendHeaderCellDidSelected)(ZXClassify *classify);

@interface ZXNewSpendHeader : UIView

@property (strong, nonatomic) NSArray *classifyList;

@property (nonatomic, copy) ZXNewSpendHeaderCellDidSelected zxNewSpendHeaderCellDidSelected;

@end

NS_ASSUME_NONNULL_END
