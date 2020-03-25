//
//  ZXScoreHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreHeaderView.h"
#import <Masonry/Masonry.h>
#import "ZXScoreDayView.h"

@interface ZXScoreHeaderView ()

@property (strong, nonatomic) UILabel *mondayTip;

@property (strong, nonatomic) UILabel *tuesdayTip;

@property (strong, nonatomic) UILabel *wednesdayTip;

@property (strong, nonatomic) UILabel *thursdayTip;

@property (strong, nonatomic) UILabel *fridayTip;

@property (strong, nonatomic) UILabel *satdayTip;

@property (strong, nonatomic) UILabel *sundayTip;

@property (strong, nonatomic) UIView *weekView;

@property (strong, nonatomic) UILabel *ruleLab;

@end

@implementation ZXScoreHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.signView.layer setCornerRadius:5.0];
//    [self.signBtn.layer setCornerRadius:self.signBtn.frame.size.height/2.0];
    
//    UIImage *backImage = [UIImage imageNamed:@"ic_score_view_bg.png"];
//    UIEdgeInsets edge = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
//    backImage = [backImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
//    [self.bgImgView setImage:backImage];

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

#pragma mark - Setter

- (void)setScoreIndex:(ZXScoreIndex *)scoreIndex {
    _scoreIndex = scoreIndex;
    if (_scoreIndex) {
        [_totalLab countFromCurrentValueTo:[_scoreIndex.score integerValue]];
        [_numBtn setTitle:_scoreIndex.adp.txt forState:UIControlStateNormal];
        [_ruleLab setText:_scoreIndex.notice.txt];
        [_progressLab setText:_scoreIndex.progress];
        if ([_scoreIndex.is_signin integerValue] == 1) {
            [_signBtn setBackgroundColor:[HOME_TITLE_COLOR colorWithAlphaComponent:0.4]];
            [_signBtn setUserInteractionEnabled:NO];
            [_signBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
        } else {
            [_signBtn setBackgroundColor:THEME_COLOR];
            [_signBtn setUserInteractionEnabled:YES];
            [_signBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        }
        
        if (_weekView) {
            [_weekView removeFromSuperview];
            _weekView = nil;
        }
        
        _weekView = [[UIView alloc] init];
        [_signView addSubview:_weekView];
        [_weekView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.numBtn.mas_bottom).mas_offset(15.0);
            make.height.mas_equalTo(60.0);
            make.left.mas_equalTo(self.signView).mas_offset(20.0);
            make.right.mas_equalTo(self.signView).mas_offset(-20.0);
        }];
        
        NSMutableArray *dayViewList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [_scoreIndex.day_arr count]; i++) {
            ZXScoreDay *scoreDay = (ZXScoreDay *)[_scoreIndex.day_arr objectAtIndex:i];
            ZXScoreDayView *scoreDayView = [[ZXScoreDayView alloc] init];
            [scoreDayView setScoreDay:scoreDay];
            [_weekView addSubview:scoreDayView];
            [dayViewList addObject:scoreDayView];
        }
        [dayViewList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5.0 leadSpacing:0.0 tailSpacing:0.0];
        [dayViewList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.height.mas_equalTo(60.0);
        }];
    }
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
    
//    if (!_bgImgView) {
//        _bgImgView = [[UIImageView alloc] init];
//        [_bgImgView setContentMode:UIViewContentModeScaleAspectFill];
//        [_bgImgView setImage:[UIImage imageNamed:@"icon_score_bg"]];
//        [_mainView addSubview:_bgImgView];
//        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mainView);
//            make.left.mas_equalTo(self.mainView);
//            make.right.mas_equalTo(self.mainView);
//            make.height.mas_equalTo(207.0 + STATUS_HEIGHT);
//        }];
//    }
    
    if (!_totalLab) {
        _totalLab = [[UICountingLabel alloc] init];
        [_totalLab setTextColor:[UIColor whiteColor]];
        [_totalLab setFont:[UIFont systemFontOfSize:30.0]];
        [_totalLab setTextAlignment:NSTextAlignmentCenter];
        [_totalLab setText:@"0"];
        [_totalLab setFormat:@"%d"];
        [_totalLab setAnimationDuration:0.5];
        [_mainView addSubview:_totalLab];
        [_totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView).mas_offset(25.0);
            make.left.mas_equalTo(self.mainView);
            make.right.mas_equalTo(self.mainView);
            make.height.mas_equalTo(25.0);
        }];
    }
    
    UIView *ruleView = [[UIView alloc] init];
    UITapGestureRecognizer *tapRule = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapRuleViewAction)];
    [ruleView addGestureRecognizer:tapRule];
    [_mainView addSubview:ruleView];
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalLab.mas_bottom).mas_offset(10.0);
        make.centerX.mas_equalTo(self.mainView);
        make.height.mas_equalTo(14.0);
    }];
    
    _ruleLab = [[UILabel alloc] init];
    [_ruleLab setTextColor:[UtilsMacro colorWithHexString:@"FFE3C1"]];
    [_ruleLab setFont:[UIFont systemFontOfSize:12.0]];
    [_ruleLab setTextAlignment:NSTextAlignmentCenter];
    [ruleView addSubview:_ruleLab];
    [_ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0.0);
    }];
    
    if (!_signView) {
        _signView = [[UIView alloc] init];
        [_signView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
        [_mainView addSubview:_signView];
        [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mainView).mas_offset(16.0);
            make.right.mas_equalTo(self.mainView).mas_offset(-16.0);
            make.bottom.mas_equalTo(self.mainView);
            make.height.mas_equalTo(180.0);
        }];
        [_signView.layer setCornerRadius:5.0];
    }
    
    if (!_numBtn) {
        _numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numBtn setTitleColor:[UtilsMacro colorWithHexString:@"E07C52"] forState:UIControlStateNormal];
        [_numBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_numBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_numBtn addTarget:self action:@selector(handleTapNumBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_signView addSubview:_numBtn];
        [_numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.signView).mas_offset(20.0);
            make.top.mas_equalTo(self.signView).mas_offset(20.0);
            make.height.mas_equalTo(12.0);
            make.width.mas_lessThanOrEqualTo((SCREENWIDTH - 72.0)/2.0).priorityLow();
        }];
    }
    
    if (!_progressLab) {
        _progressLab = [[UILabel alloc] init];
        [_progressLab setTextColor:[UtilsMacro colorWithHexString:@"E07C52"]];
        [_progressLab setTextAlignment:NSTextAlignmentRight];
        [_progressLab setFont:[UIFont systemFontOfSize:12.0]];
        [_signView addSubview:_progressLab];
        [_progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20.0);
            make.height.mas_equalTo(12.0);
            make.width.mas_lessThanOrEqualTo((SCREENWIDTH - 72.0)/2.0).priorityLow();
            make.top.mas_equalTo(self.signView).mas_offset(20.0);
        }];
    }
    
    if (!_signBtn) {
        _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_signBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [_signBtn setBackgroundColor:[UIColor clearColor]];
        [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_signBtn addTarget:self action:@selector(handleTapSignBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_signView addSubview:_signBtn];
        [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.signView.mas_bottom).mas_offset(-20.0);
            make.centerX.mas_equalTo(self.signView);
            make.width.mas_equalTo(220.0);
            make.height.mas_equalTo(30.0);
        }];
        [_signBtn.layer setCornerRadius:15.0];
    }
}

#pragma mark - Button Method

- (void)handleTapSignBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scoreHeaderViewHandleTapSignBtnAction)]) {
        [self.delegate scoreHeaderViewHandleTapSignBtnAction];
    }
}

- (void)handleTapRuleViewAction {
    if (self.zxScoreHeaderViewRuleClick) {
        self.zxScoreHeaderViewRuleClick();
    }
}

- (void)handleTapNumBtnAction {
    if (self.zxScoreHeaderViewNumBtnClick) {
        self.zxScoreHeaderViewNumBtnClick();
    }
}

@end
