//
//  ZXNewEarningCell.h
//  pzhixin
//
//  Created by zhixin on 2019/11/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXProfitHome.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXNewEarningCell : UITableViewCell

@property (strong, nonatomic) NSArray *itemList;

@property (copy, nonatomic) void (^zxNewEarningCellItemClick) (ZXProfitSubItem *subItem);

@end

NS_ASSUME_NONNULL_END
