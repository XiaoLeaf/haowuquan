//
//  ZXDetailRecItemCell.h
//  pzhixin
//
//  Created by zhixin on 2020/1/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDetailRecItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (strong, nonatomic) NSArray *recommendList;

@property (copy, nonatomic) void (^zxDetailRecItemCellDidSelectCollectionViewCell) (NSIndexPath *indexPath, ZXGoods *goods);

@end

NS_ASSUME_NONNULL_END
