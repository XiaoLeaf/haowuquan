//
//  ZXDetailHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBannerView.h"
#import <YYText/YYText.h>
#import "ZXGoodsDetail.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXDetailHeaderViewDelegate;

@interface ZXDetailHeaderView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) ZXBannerView *bannerView;

@property (strong, nonatomic) UIView *goodsView;

@property (strong, nonatomic) UIView *priceView;

@property (strong, nonatomic) UILabel *currentPrice;

@property (strong, nonatomic) UILabel *originalPrice;

@property (strong, nonatomic) UIButton *favoriteBtn;

@property (strong, nonatomic) UIView *nameView;

@property (strong, nonatomic) ZXLabel *nameLabel;

@property (strong, nonatomic) UIView *awardView;

@property (strong, nonatomic) UILabel *commissionLabel;

@property (strong, nonatomic) UILabel *couponLabel;

@property (strong, nonatomic) UILabel *soldLab;

@property (strong, nonatomic) UIView *promoteView;

@property (strong, nonatomic) UILabel *promoteLab;

@property (strong, nonatomic) UIButton *checkPromote;

@property (strong, nonatomic) UIView *descView;

@property (strong, nonatomic) UIImageView *descImg;

@property (strong, nonatomic) UILabel *descLab;

@property (strong, nonatomic) UIView *couponView;

@property (strong, nonatomic) UIImageView *couponBgImg;

@property (strong, nonatomic) UIButton *fetchBtn;

@property (strong, nonatomic) UIImageView *dotImg;

@property (strong, nonatomic) UIView *couponContentView;

@property (strong, nonatomic) UIImageView *couponTipImg;

@property (strong, nonatomic) UILabel *couponLab;

@property (strong, nonatomic) UILabel *couponNameLab;

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIView *shopView;

@property (strong, nonatomic) UIImageView *shopImg;

@property (strong, nonatomic) UILabel *shopName;

@property (strong, nonatomic) UILabel *shopScore;

@property (strong, nonatomic) UILabel *shopCount;

@property (strong, nonatomic) UILabel *evaluateLab;

@property (strong, nonatomic) UILabel *goodsEvaluate;

@property (strong, nonatomic) UILabel *serviceLab;

@property (strong, nonatomic) UILabel *serviceLabel;

@property (strong, nonatomic) UILabel *diliverLab;

@property (strong, nonatomic) UILabel *diliverLabel;

@property (strong, nonatomic) ZXGoodsDetail *goodsDetail;

@property (weak, nonatomic) id<ZXDetailHeaderViewDelegate>delegate;

@end

@protocol ZXDetailHeaderViewDelegate <NSObject>

- (void)detailHeaderViewHandleTapFetchBtnAction;

- (void)detailHeaderViewPlayerDidPlayToEnd;

- (void)detailHeaderViewHandleTapFavoriteBtnAction;

- (void)detailHeaderViewHandleTapCheckPromoteBtnAction;


@end

NS_ASSUME_NONNULL_END
