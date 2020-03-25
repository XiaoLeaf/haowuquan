//
//  ZXCouponCell.h
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXCouponCellDelegate;

@interface ZXCouponCell : UITableViewCell

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIImageView *bgImgView;

@property (strong, nonatomic) UIImageView *tipImageView;

@property (strong, nonatomic) UIImageView *flagImgView;

@property (strong, nonatomic) UIView *prefixView;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *condiLabel;

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UIButton *flagbtn;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIView *timeView;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *useBtn;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIView *detailView;

@property (strong, nonatomic) UILabel *indiLabel;

@property (strong, nonatomic) UIButton *detailBtn;

@property (strong, nonatomic) UIView *tipView;

@property (strong, nonatomic) UILabel *detailLabel;

@property (weak, nonatomic) id<ZXCouponCellDelegate>delegate;

@end

@protocol ZXCouponCellDelegate <NSObject>

- (void)couponCellHandleTapDetailBtnAction:(ZXCouponCell *)cell;

@end

NS_ASSUME_NONNULL_END
