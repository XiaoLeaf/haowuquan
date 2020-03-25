//
//  ZXMyMenuCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXMyMenuCellDidSelectedBlock)(NSInteger index);

@interface ZXMyMenuCell : UITableViewCell

@property (copy, nonatomic) ZXMyMenuCellDidSelectedBlock zxMyMenuCellDidSelectedBlock;

@property (strong, nonatomic) ZXMyMenu *myMenu;

@end

NS_ASSUME_NONNULL_END
