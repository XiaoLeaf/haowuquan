//
//  ZXEarningHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXEarningHeaderViewDelegate;

@interface ZXEarningHeaderView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *bgImgView;

@property (strong, nonatomic) UILabel *totalLab;

@property (strong, nonatomic) UICountingLabel *countLab;

@property (strong, nonatomic) UILabel *balanceLab;

@property (strong, nonatomic) UIButton *withdrawBtn;

@property (weak, nonatomic) id<ZXEarningHeaderViewDelegate>delegate;

@end

@protocol ZXEarningHeaderViewDelegate <NSObject>

- (void)earningHeaderViewHandleTapWithdrawBtnAction;

@end

NS_ASSUME_NONNULL_END
