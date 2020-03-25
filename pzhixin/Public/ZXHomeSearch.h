//
//  ZXHomeSearch.h
//  pzhixin
//
//  Created by zhixin on 2019/9/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXHomeSearchBtnClick)(NSInteger btnTag);

@interface ZXHomeSearch : UIView

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *bgImg;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *nameView;

@property (strong, nonatomic) UILabel *nameLab;

@property (strong, nonatomic) UIButton *searchBtn;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) ZXCommonSearch *commonSearch;

@property (copy, nonatomic) ZXHomeSearchBtnClick zxHomeSearchBtnClick;

@end

NS_ASSUME_NONNULL_END
