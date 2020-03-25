//
//  ZXHomeVC.h
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHomeBannerCell.h"
#import "ZXNewHomeViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXHomeVCCycleScrollViewDidScrollToIndex)(NSInteger index);

typedef void(^ZXHomeVCColorListBlock)(NSArray *colorList);

@interface ZXHomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *homeTable;

@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (strong, nonatomic) ZXHomeBannerCell *bannerCell;

@property (strong, nonatomic) NSMutableArray *colorList;

@property (copy, nonatomic) ZXHomeVCCycleScrollViewDidScrollToIndex zxHomeVCCycleScrollViewDidScrollToIndex;

@property (copy, nonatomic) ZXHomeVCColorListBlock zxHomeVCColorListBlock;

@property (copy, nonatomic) void(^zxHomeVCCycleViewScrolling) (NSInteger offset);

@property (copy, nonatomic) void(^zxHomeVCCycleViewResumeBlock) (NSInteger targetIndex);

@property (strong, nonatomic) ZXNewHomeViewController *realHome;

@property (copy, nonatomic) void(^zxHomeTableFirstLoading) (void);

@property (copy, nonatomic) void(^zxHomeTableDidScroll) (UIScrollView *scrollView);

@property (copy, nonatomic) void(^zxHomeTableWillBeginDragging) (UIScrollView *scrollView);

//在协议的弹窗出现之前阻断用户行为。viewWillAppear添加到视图上；viewDidAppear移除视图。
@property (strong, nonatomic, nullable) UIView *bgView;

@end

NS_ASSUME_NONNULL_END
