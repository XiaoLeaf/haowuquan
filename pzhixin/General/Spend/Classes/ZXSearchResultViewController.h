//
//  ZXSearchResultViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/7/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import "ZXClassify.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXSearchResultVCChangeSearchHisBlock)(NSString *content);

@interface ZXSearchResultViewController : UIViewController

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UICollectionView *resultCollectionView;
@property (strong, nonatomic) UIButton *synBtn;
@property (strong, nonatomic) UIButton *awardBtn;
@property (strong, nonatomic) UIButton *priceBtn;
@property (strong, nonatomic) UIButton *countBtn;
@property (strong, nonatomic) UIButton *typeBtn;

@property (strong, nonatomic) NSString *titleStr;

@property (strong, nonatomic) ZXClassify *classify;

@property (assign, nonatomic) NSInteger cats_id;

//来源，从搜索页进来==1  从分页类点击子分类进来==2
@property (assign, nonatomic) NSInteger fromType;

@property (copy, nonatomic) ZXSearchResultVCChangeSearchHisBlock zxSearchResultVCChangeSearchHisBlock;

@end

NS_ASSUME_NONNULL_END
