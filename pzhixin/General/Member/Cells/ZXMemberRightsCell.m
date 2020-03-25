//
//  ZXMemberRightsCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMemberRightsCell.h"
#import <Masonry/Masonry.h>

@interface ZXMemberRightsCell ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *bgImgView;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIView *userView;

@property (strong, nonatomic) UIImageView *userHead;

@property (strong, nonatomic) UILabel *nameLab;

@property (strong, nonatomic) UIImageView *levelImg;

@property (strong, nonatomic) UIProgressView *fansProgress;

@property (strong, nonatomic) UILabel *fansLab;

@property (strong, nonatomic) UIButton *inviteBtn;

@property (strong, nonatomic) UIImageView *rightsImg;

@property (strong, nonatomic) UIButton *checkBtn;

@property (strong, nonatomic) UIView *rightsView;

@property (strong, nonatomic) UIButton *firstBtn;

@property (strong, nonatomic) UIButton *secondBtn;

@property (strong, nonatomic) UIButton *thirdBtn;

@end

@implementation ZXMemberRightsCell

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
        [self setBackgroundColor:[UIColor clearColor]];
        [self memberRightCreateSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_rightsView setNeedsLayout];
    [_rightsView layoutIfNeeded];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _rightsView.bounds;
    gradientLayer.colors = @[(__bridge id)[UtilsMacro colorWithHexString:@"EAD5C1"].CGColor,
                             (__bridge id)[UtilsMacro colorWithHexString:@"EAD3B4"].CGColor,
                             (__bridge id)[UtilsMacro colorWithHexString:@"E9D4B6"].CGColor,
                             (__bridge id)[UtilsMacro colorWithHexString:@"E6D7B9"].CGColor,
                             (__bridge id)[UtilsMacro colorWithHexString:@"FBD9A4"].CGColor,];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    [_rightsView.layer addSublayer:gradientLayer];

    // 图形绘制 layer
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:gradientLayer.bounds cornerRadius:9.0];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 1.0;
    gradientLayer.mask = shapeLayer;
}

#pragma mark - Private Methods

- (void)memberRightCreateSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
//        [_mainView setBackgroundColor:BG_COLOR];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
        }];
    }

    if (!_topView) {
        _topView = [[UIView alloc] init];
        [_mainView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView);
            make.left.mas_equalTo(self.mainView);
            make.right.mas_equalTo(self.mainView);
            make.height.mas_equalTo(386.0);
        }];
    }

    if (!_userView) {
        _userView = [[UIView alloc] init];
        [_topView addSubview:_userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.topView);
            make.right.mas_equalTo(self.topView);
            make.top.mas_equalTo(self.topView).mas_offset(12.0);
            make.height.mas_equalTo(44.0);
        }];
    }

    if (!_userHead) {
        _userHead = [[UIImageView alloc] init];
        [_userHead.layer setCornerRadius:22.0];
        [_userHead setContentMode:UIViewContentModeScaleAspectFill];
        [_userHead setBackgroundColor:THEME_COLOR];
        [_userView addSubview:_userHead];
        [_userHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userView).mas_offset(25.0);
            make.top.mas_equalTo(self.userView);
            make.bottom.mas_equalTo(self.userView);
            make.width.mas_equalTo(self.userHead.mas_height);
        }];
    }

    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        [_nameLab setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_nameLab setTextColor:[UtilsMacro colorWithHexString:@"F2FFFF"]];
        [_userView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.left.mas_equalTo(self.userHead.mas_right).mas_offset(10.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
        [_nameLab setText:@"Leaf"];
    }

    if (!_levelImg) {
        _levelImg = [[UIImageView alloc] init];
        [_levelImg setContentMode:UIViewContentModeScaleAspectFit];
//        [_levelImg setImage:[UIImage imageNamed:@"ic_member_svip"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:@""] imageView:self.levelImg placeholderImage:[UIImage imageNamed:@"ic_member_svip"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
        });
        [_userView addSubview:_levelImg];
        [_levelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLab.mas_right).mas_offset(5.0);
            make.height.mas_equalTo(15.0);
            make.top.mas_equalTo(0.0);
            make.width.mas_equalTo(30.0);
        }];
    }

    if (!_fansProgress) {
        _fansProgress = [[UIProgressView alloc] init];
        [_fansProgress setTrackTintColor:[UtilsMacro colorWithHexString:@"242932"]];
        [_fansProgress setProgressTintColor:[UtilsMacro colorWithHexString:@"FED39D"]];
        [_fansProgress setProgress:0.3];
        [_userView addSubview:_fansProgress];
        [_fansProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userHead.mas_right).mas_offset(10.0);
            make.height.mas_equalTo(2.0);
            make.width.mas_equalTo(SCREENWIDTH * 150.0/375.0);
            make.centerY.mas_equalTo(self.userView);
        }];
    }

    if (!_fansLab) {
        _fansLab = [[UILabel alloc] init];
        [_fansLab setText:@"粉丝:30/90"];
        [_fansLab setFont:[UIFont systemFontOfSize:10.0]];
        [_fansLab setTextColor:[UtilsMacro colorWithHexString:@"FEEFD6"]];
        [_userView addSubview:_fansLab];
        [_fansLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(self.userHead.mas_right).mas_offset(10.0);
            make.height.mas_equalTo(12.0);
        }];
    }

    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_inviteBtn setImage:[UIImage imageNamed:@"ic_member_invite"] forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.inviteBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_member_invite"]];
        });
        [_inviteBtn setTag:0];
        [_inviteBtn addTarget:self action:@selector(handleTapMemberRightsCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_userView addSubview:_inviteBtn];
        [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.userView);
            make.right.mas_equalTo(self.userView).mas_offset(-15.0);
            make.width.mas_equalTo(60.0);
            make.height.mas_equalTo(24.0);
        }];
    }

    if (!_rightsImg) {
        _rightsImg = [[UIImageView alloc] init];
//        [_rightsImg setImage:[UIImage imageNamed:@"ic_member_right"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:@""] imageView:self.rightsImg placeholderImage:[UIImage imageNamed:@"ic_member_right"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
        });
        [_rightsImg setContentMode:UIViewContentModeScaleAspectFill];
        [_topView addSubview:_rightsImg];
        [_rightsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userView.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(20.0);
            make.right.mas_equalTo(-20.0);
            make.height.mas_equalTo(70.0);
        }];
    }

    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"查看等级规则" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[UtilsMacro colorWithHexString:@"F3DCBC"] forState:UIControlStateNormal];
        [_checkBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_checkBtn setTag:1];
        [_checkBtn addTarget:self action:@selector(handleTapMemberRightsCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_userView addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.rightsImg.mas_bottom).mas_offset(-10.0);
            make.width.mas_equalTo(70.0);
            make.height.mas_equalTo(20.0);
            make.centerX.mas_equalTo(self.topView);
        }];
    }

    if (!_rightsView) {
        _rightsView = [[UIView alloc] init];
        [_rightsView setBackgroundColor:[[UtilsMacro colorWithHexString:@"111721"] colorWithAlphaComponent:0.5]];
        [_rightsView.layer setCornerRadius:9.0];
        [_topView addSubview:_rightsView];
        [_rightsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.rightsImg.mas_bottom).mas_offset(20.0);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
            make.bottom.mas_equalTo(-20.0).priorityHigh();
        }];
    }

    UIView *levelView = [[UIView alloc] init];
    [_rightsView addSubview:levelView];
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rightsView);
        make.height.mas_equalTo(50.0);
        make.left.mas_equalTo(self.rightsView).mas_offset(80.0);
        make.right.mas_equalTo(self.rightsView).mas_offset(-80.0);
    }];

    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.firstBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_rights_expert_nor"]];
            [self.firstBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"ic_rights_expert_selected"]];
        });
//        [_firstBtn setImage:[UIImage imageNamed:@"ic_rights_expert_nor"] forState:UIControlStateNormal];
//        [_firstBtn setImage:[UIImage imageNamed:@"ic_rights_expert_selected"] forState:UIControlStateSelected];
        [_firstBtn addTarget:self action:@selector(handleTapMemberRightsCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_firstBtn setTag:2];
        [levelView addSubview:_firstBtn];
    }

    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.secondBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_rights_vip_nor"]];
            [self.secondBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"ic_rights_vip_selected"]];
        });
//        [_secondBtn setImage:[UIImage imageNamed:@"ic_rights_vip_nor"] forState:UIControlStateNormal];
//        [_secondBtn setImage:[UIImage imageNamed:@"ic_rights_vip_selected"] forState:UIControlStateSelected];
        [_secondBtn addTarget:self action:@selector(handleTapMemberRightsCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_secondBtn setTag:3];
        [levelView addSubview:_secondBtn];
    }

    if (!_thirdBtn) {
        _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.thirdBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_rights_svip_nor"]];
            [self.thirdBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"ic_rights_svip_selected"]];
        });
//        [_thirdBtn setImage:[UIImage imageNamed:@"ic_rights_svip_nor"] forState:UIControlStateNormal];
//        [_thirdBtn setImage:[UIImage imageNamed:@"ic_rights_svip_selected"] forState:UIControlStateSelected];
        [_thirdBtn addTarget:self action:@selector(handleTapMemberRightsCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_thirdBtn setTag:4];
        [levelView addSubview:_thirdBtn];
    }

    NSMutableArray *btnList = [[NSMutableArray alloc] initWithObjects:_firstBtn, _secondBtn, _thirdBtn, nil];
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
    [btnList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(0.0);
    }];
}

#pragma mark - Button Method

- (void)handleTapMemberRightsCellBtnAction:(UIButton *)btn {
    
}

@end
