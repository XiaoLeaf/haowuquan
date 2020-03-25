//
//  ZXDetailRecCell.h
//  pzhixin
//
//  Created by zhixin on 2020/1/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDetailRecCell : UITableViewCell

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) TYCyclePagerView *recPagerView;

@property (strong, nonatomic) UIView *pageView;

@property (strong, nonatomic) UILabel *pageLab;

@property (strong, nonatomic) NSArray *recommendList;

@property (copy, nonatomic) void (^zxDetailRecCellDidSelectCollectionViewCell) (NSIndexPath *indexPath, ZXGoods *goods);

@end

NS_ASSUME_NONNULL_END
