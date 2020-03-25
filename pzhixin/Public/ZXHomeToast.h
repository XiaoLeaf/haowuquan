//
//  ZXHomeToast.h
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeToast : UIView

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *goodsImg;

@property (strong, nonatomic) UIView *nameView;

@property (strong, nonatomic) YYLabel *nameLab;

@property (strong, nonatomic) UIView *priceView;

@property (strong, nonatomic) UILabel *priceLab;

@property (strong, nonatomic) UILabel *couponLab;

@property (strong, nonatomic) UILabel *awardLab;

@property (strong, nonatomic) UIButton *moreBtn;

@property (strong, nonatomic) UIButton *getBtn;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) ZXCommonSearch *commonSearch;

@property (copy, nonatomic) void (^zxHomeToastBtnClick) (NSInteger btnTag);

@end

NS_ASSUME_NONNULL_END
