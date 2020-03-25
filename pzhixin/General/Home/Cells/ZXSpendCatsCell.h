//
//  ZXSpendCatsCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXClassify.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXSpendCatsCellDidSelect)(ZXClassify *classify);

@interface ZXSpendCatsCell : UITableViewCell

@property (strong, nonatomic) NSArray *classifyList;

@property (copy, nonatomic) ZXSpendCatsCellDidSelect zxSpendCatsCellDidSelect;

@end

NS_ASSUME_NONNULL_END
