//
//  ZXHomeMenuCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;

@property (strong, nonatomic) NSArray *menuList;

@property (copy, nonatomic) void (^zxHomeMenuCellMenuDidSelected) (NSInteger cellTag, NSInteger menuTag);

@end

NS_ASSUME_NONNULL_END
