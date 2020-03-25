//
//  ZXSortViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSortViewController : ZXNormalBaseViewController

@property (strong, nonatomic) UITableView *sortTabelView;
@property (strong, nonatomic) UICollectionView *sortCollectionView;

@end

NS_ASSUME_NONNULL_END
