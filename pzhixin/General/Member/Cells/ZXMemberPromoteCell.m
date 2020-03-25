//
//  ZXMemberPromoteCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMemberPromoteCell.h"
#import <Masonry/Masonry.h>

@interface ZXMemberPromoteCell ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *promoteView;

@property (strong, nonatomic) UILabel *expertLab;

@property (strong, nonatomic) UIImageView *expertImg;

@property (strong, nonatomic) UIProgressView *expertProgress;

@property (strong, nonatomic) UILabel *vipLab;

@property (strong, nonatomic) UIImageView *vipImg;

@property (strong, nonatomic) UIProgressView *vipProgress;

@property (strong, nonatomic) UILabel *svipLab;

@property (strong, nonatomic) UIImageView *svipImg;

@property (strong, nonatomic) UIProgressView *svipProgress;

@property (strong, nonatomic) UIButton *inviteButton;

@end

@implementation ZXMemberPromoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:BG_COLOR];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
        }];
    }

    if (!_promoteView) {
        _promoteView = [[UIView alloc] init];
        [_promoteView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_promoteView];
        [_promoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.mainView);
            make.top.mas_equalTo(self.mainView);
            make.height.mas_equalTo(300.0);
        }];
    }

    UIView *promoteHeader = [[UIView alloc] init];
    [_promoteView addSubview:promoteHeader];
    [promoteHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.promoteView);
        make.height.mas_equalTo(39.5);
    }];

    UIView *promoteTip = [[UIView alloc] init];
    [promoteTip setBackgroundColor:[UtilsMacro colorWithHexString:@"F6AF55"]];
    [promoteTip.layer setCornerRadius:1.0];
    [promoteHeader addSubview:promoteTip];
    [promoteTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0);
        make.height.mas_equalTo(15.0);
        make.centerY.mas_equalTo(promoteHeader);
        make.width.mas_equalTo(2.0);
    }];

    UILabel *promoteTitle = [[UILabel alloc] init];
    [promoteTitle setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
    [promoteTitle setTextColor:HOME_TITLE_COLOR];
    [promoteTitle setText:@"如何升级"];
    [promoteHeader addSubview:promoteTitle];
    [promoteTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(promoteTip.mas_right).mas_offset(6.0);
        make.top.bottom.mas_equalTo(promoteHeader);
        make.width.mas_equalTo(0.0).priorityLow();
    }];

    UIView *promoteLine = [[UIView alloc] init];
    [promoteLine setBackgroundColor:[UtilsMacro colorWithHexString:@"EFEFEF"]];
    [_promoteView addSubview:promoteLine];
    [promoteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.promoteView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(promoteHeader.mas_bottom);
    }];

    UILabel *promoterLab = [[UILabel alloc] init];
    [promoterLab setText:@"邀请粉丝(有效粉丝达99/499人即可升级VIP/SVIP会员)"];
    [promoterLab setFont:[UIFont systemFontOfSize:12.0]];
    [promoterLab setTextColor:COLOR_666666];
    [_promoteView addSubview:promoterLab];
    [promoterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.promoteView).mas_offset(16.0);
        make.height.mas_equalTo(15.0);
        make.width.mas_equalTo(0.0).priorityLow();
        make.top.mas_equalTo(promoteLine.mas_bottom).mas_offset(20.0);
    }];

    UIView *promoteLevelView = [[UIView alloc] init];
    [_promoteView addSubview:promoteLevelView];
    [promoteLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(promoterLab.mas_bottom);
        make.left.right.mas_equalTo(self.promoteView);
        make.height.mas_equalTo(110.0);
    }];

    if (!_expertLab) {
        _expertLab = [[UILabel alloc] init];
        [_expertLab setBackgroundColor:[UtilsMacro colorWithHexString:@"FFC780"]];
        [_expertLab.layer setCornerRadius:6.0];
        [_expertLab.layer setMasksToBounds:YES];
        [promoteLevelView addSubview:_expertLab];
        [_expertLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(34.0);
            make.left.mas_equalTo(22.0);
            make.width.height.mas_equalTo(12.0);
        }];
    }

    if (!_expertImg) {
        _expertImg = [[UIImageView alloc] init];
        [_expertImg setContentMode:UIViewContentModeScaleAspectFit];
        [_expertImg setImage:[UIImage imageNamed:@"ic_promote_expert"]];
        [promoteLevelView addSubview:_expertImg];
        [_expertImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.expertLab.mas_centerX);
            make.width.mas_equalTo(32.0);
            make.height.mas_equalTo(14.0);
            make.top.mas_equalTo(self.expertLab.mas_bottom).mas_offset(15.0);
        }];
    }

    if (!_expertProgress) {
        _expertProgress = [[UIProgressView alloc] init];
        [_expertProgress setProgress:0.5];
        [_expertProgress setTrackTintColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
        [_expertProgress setProgressTintColor:[UtilsMacro colorWithHexString:@"FFC780"]];
        [promoteLevelView addSubview:_expertProgress];
        [_expertProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.expertLab.mas_right).mas_offset(-1.0);
            make.height.mas_equalTo(2.0);
            make.top.mas_equalTo(39.0);
            make.width.mas_equalTo(SCREENWIDTH * 60.0 / 375.0);
        }];
    }

    if (!_vipLab) {
        _vipLab = [[UILabel alloc] init];
        [_vipLab setBackgroundColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
        [_vipLab setText:@"99"];
        [_vipLab setTextColor:COLOR_666666];
        [_vipLab setTextAlignment:NSTextAlignmentCenter];
        [_vipLab setFont:[UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium]];
        [_vipLab.layer setCornerRadius:14.0];
        [_vipLab.layer setMasksToBounds:YES];
        [promoteLevelView addSubview:_vipLab];
        [_vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.expertLab.mas_centerY);
            make.left.mas_equalTo(self.expertProgress.mas_right);
            make.width.height.mas_equalTo(28.0);
        }];
    }

    if (!_vipImg) {
        _vipImg = [[UIImageView alloc] init];
        [_vipImg setContentMode:UIViewContentModeScaleAspectFit];
        [_vipImg setImage:[UIImage imageNamed:@"ic_promote_vip"]];
        [promoteLevelView addSubview:_vipImg];
        [_vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.vipLab.mas_centerX);
            make.width.mas_equalTo(32.0);
            make.height.mas_equalTo(14.0);
            make.centerY.mas_equalTo(self.expertImg.mas_centerY);
        }];
    }

    if (!_vipProgress) {
        _vipProgress = [[UIProgressView alloc] init];
        [_vipProgress setTrackTintColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
        [_vipProgress setProgressTintColor:[UtilsMacro colorWithHexString:@"FFC780"]];
        [promoteLevelView addSubview:_vipProgress];
        [_vipProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vipLab.mas_right);
            make.height.mas_equalTo(2.0);
            make.top.mas_equalTo(39.0);
            make.width.mas_equalTo(SCREENWIDTH * 90.0 / 375.0);
        }];
    }

    if (!_svipLab) {
        _svipLab = [[UILabel alloc] init];
        [_svipLab setBackgroundColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
        [_svipLab setText:@"499"];
        [_svipLab setTextColor:COLOR_666666];
        [_svipLab setTextAlignment:NSTextAlignmentCenter];
        [_svipLab setFont:[UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium]];
        [_svipLab.layer setCornerRadius:14.0];
        [_svipLab.layer setMasksToBounds:YES];
        [promoteLevelView addSubview:_svipLab];
        [_svipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.expertLab.mas_centerY);
            make.left.mas_equalTo(self.vipProgress.mas_right);
            make.width.height.mas_equalTo(28.0);
        }];
    }

    if (!_svipImg) {
        _svipImg = [[UIImageView alloc] init];
        [_svipImg setContentMode:UIViewContentModeScaleAspectFit];
        [_svipImg setImage:[UIImage imageNamed:@"ic_promote_svip"]];
        [promoteLevelView addSubview:_svipImg];
        [_svipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.svipLab.mas_centerX);
            make.width.mas_equalTo(32.0);
            make.height.mas_equalTo(14.0);
            make.centerY.mas_equalTo(self.expertImg.mas_centerY);
        }];
    }

    if (!_svipProgress) {
        _svipProgress = [[UIProgressView alloc] init];
        [_svipProgress setTrackTintColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
        [_svipProgress setProgressTintColor:[UtilsMacro colorWithHexString:@"FFC780"]];
        [promoteLevelView addSubview:_svipProgress];
        [_svipProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.svipLab.mas_right);
            make.height.mas_equalTo(2.0);
            make.top.mas_equalTo(39.0);
            make.right.mas_equalTo(promoteLevelView).mas_offset(-17.0);
        }];
    }



    UILabel *explainLab = [[UILabel alloc] init];
    [explainLab setTextColor:COLOR_999999];
    [explainLab setFont:[UIFont systemFontOfSize:10.0]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"*注:有效粉丝定义:2019年9月15日起，自买或分享1单且付款总金额不小于1元(退款为失效)。"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UtilsMacro colorWithHexString:@"FE5B00"] range:NSMakeRange(0, 1)];
    [explainLab setAttributedText:attributeStr];
    [explainLab setNumberOfLines:0];
    [_promoteView addSubview:explainLab];
    [explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0);
        make.right.mas_equalTo(-16.0);
        make.top.mas_equalTo(promoteLevelView.mas_bottom);
        make.height.mas_equalTo(0.0).priorityLow();
    }];

    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteButton setTitleColor:[UtilsMacro colorWithHexString:@"6A2C13"] forState:UIControlStateNormal];
        [_inviteButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_inviteButton setTag:8];
        [_inviteButton.layer setCornerRadius:20.0];
        [_inviteButton addTarget:self action:@selector(handleTapMemberPromoteCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_inviteButton setBackgroundColor:[UtilsMacro colorWithHexString:@"FFC780"]];
        [_promoteView addSubview:_inviteButton];
        [_inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(explainLab.mas_bottom).mas_offset(18.0);
            make.left.mas_equalTo(22.0);
            make.right.mas_equalTo(-22.0);
            make.height.mas_equalTo(40.0);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapMemberPromoteCellBtnAction:(UIButton *)btn {
    
}

@end
