//
//  ZXDetailCell_1.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.


#import <UIKit/UIKit.h>
#import "ZXBannerView.h"
#import <YYText/YYText.h>
#import "ZXGoodsDetail.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXDetailCell_1Delegate;

@interface ZXDetailCell_1 : UITableViewCell

@property (weak, nonatomic) IBOutlet ZXBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewTop;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) YYLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *awardView;
@property (strong, nonatomic) UILabel *commissionLabel;
@property (strong, nonatomic) UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissionLeft;
@property (weak, nonatomic) IBOutlet UIImageView *couponImg;
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopScore;
@property (weak, nonatomic) IBOutlet UILabel *shopCount;
@property (weak, nonatomic) IBOutlet UILabel *evaluateLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsEvaluate;
@property (weak, nonatomic) IBOutlet UILabel *serviceLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *diliverLab;
@property (weak, nonatomic) IBOutlet UILabel *diliverLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;
- (IBAction)handleTapFetchBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
- (IBAction)handleTapFavoriteBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *soldLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@property (strong, nonatomic) ZXGoodsDetail *goodsDetail;

@property (weak, nonatomic) id<ZXDetailCell_1Delegate>delegate;

@end

@protocol ZXDetailCell_1Delegate <NSObject>

- (void)detailCell1HandleTapFetchBtnAction;

- (void)detailCell1PlayerDidPlayToEnd;

- (void)detailCell1HandleTapFavoriteBtnAction;

@end

NS_ASSUME_NONNULL_END
