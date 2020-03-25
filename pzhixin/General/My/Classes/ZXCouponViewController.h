//
//  ZXCouponViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCouponViewController : ZXNormalBaseViewController <JXCategoryListContainerViewDelegate>

@property (strong, nonatomic) NSArray *titleList;

@property (strong, nonatomic) JXCategoryTitleView *categoryView;

@property (strong, nonatomic) JXCategoryListContainerView *listContainerView;

@end

NS_ASSUME_NONNULL_END
