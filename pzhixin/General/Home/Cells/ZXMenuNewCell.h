//
//  ZXMenuNewCell.h
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMenuNewCell : UITableViewCell

@property (copy, nonatomic) void (^zxMenuNewCellMenuClick) (NSInteger cellTag, NSInteger menuTag);

@property (strong, nonatomic) NSArray *menuList;

@end

NS_ASSUME_NONNULL_END
