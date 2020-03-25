//
//  ZXScoreHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXScoreIndex.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXScoreHeaderViewRuleClick)(void);

typedef void(^ZXScoreHeaderViewNumBtnClick)(void);

@protocol ZXScoreHeaderViewDelegate;

@interface ZXScoreHeaderView : UIView

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIImageView *bgImgView;
@property (strong, nonatomic) UICountingLabel *totalLab;
@property (strong, nonatomic) UIView *signView;
@property (strong, nonatomic) UIButton *numBtn;
@property (strong, nonatomic) UILabel *progressLab;
@property (strong, nonatomic) UIView *mondayView;
@property (strong, nonatomic) UILabel *mondayLab;
@property (strong, nonatomic) UIView *tuesdayView;
@property (strong, nonatomic) UILabel *tuesdayLab;
@property (strong, nonatomic) UIView *wednesdayView;
@property (strong, nonatomic) UILabel *wednesdayLab;
@property (strong, nonatomic) UIView *thursdayView;
@property (strong, nonatomic) UILabel *thursdayLab;
@property (strong, nonatomic) UIView *fridayView;
@property (strong, nonatomic) UILabel *fridayLab;
@property (strong, nonatomic) UIView *satdayView;
@property (strong, nonatomic) UILabel *satdayLab;
@property (strong, nonatomic) UIView *sundayView;
@property (strong, nonatomic) UILabel *sundayLab;
@property (strong, nonatomic) UIButton *signBtn;

@property (weak, nonatomic) id<ZXScoreHeaderViewDelegate>delegate;

@property (copy, nonatomic) ZXScoreHeaderViewRuleClick zxScoreHeaderViewRuleClick;

@property (copy, nonatomic) ZXScoreHeaderViewNumBtnClick zxScoreHeaderViewNumBtnClick;

@property (strong, nonatomic) ZXScoreIndex *scoreIndex;

@end

@protocol ZXScoreHeaderViewDelegate <NSObject>

- (void)scoreHeaderViewHandleTapSignBtnAction;

@end

NS_ASSUME_NONNULL_END
