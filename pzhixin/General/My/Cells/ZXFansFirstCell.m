//
//  ZXFansFirstCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansFirstCell.h"
#import <Masonry/Masonry.h>
#import "ZXInviteView.h"

@implementation ZXFansFirstCell

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

- (void)setFans:(ZXFans *)fans {
    _fans = fans;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_fans.icon] imageView:_userImg placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [_nameLab setText:_fans.nickname];
    switch ([_fans.rank integerValue]) {
        case 1:
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:ZXAppConfigHelper.sharedInstance.appConfig.img_res.rank_1] imageView:_levelImg placeholderImage:nil options:0 progress:nil completed:nil];
            break;
        case 2:
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:ZXAppConfigHelper.sharedInstance.appConfig.img_res.rank_2] imageView:_levelImg placeholderImage:nil options:0 progress:nil completed:nil];
            break;
//        case 3:
//            [_levelImg setImage:[UIImage imageNamed:@"ic_fans_svip"]];
            break;
            
        default:
            break;
    }
    [_timeLab setText:_fans.l_time];
    [_fansLab setText:[NSString stringWithFormat:@"%@",_fans.f_num]];
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-0.5);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    if (!_userView) {
        _userView = [[UIView alloc] init];
        [_mainView addSubview:_userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView);
            make.bottom.mas_equalTo(self.mainView);
            make.left.mas_equalTo(16.0);
        }];
    }
    
    if (!_userImg) {
        _userImg = [[UIImageView alloc] init];
        [_userImg setContentMode:UIViewContentModeScaleAspectFill];
        [_userImg.layer setCornerRadius:16.0];
//        [_userImg setBackgroundColor:THEME_COLOR];
        [_userImg setClipsToBounds:YES];
        [_userView addSubview:_userImg];
        [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(32.0);
            make.height.mas_equalTo(32.0);
            make.left.mas_equalTo(0.0);
            make.centerY.mas_equalTo(self.userView);
        }];
    }
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        [_nameLab setText:@"美琪琪琪琪"];
        [_nameLab setTextColor:HOME_TITLE_COLOR];
        [_nameLab setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
        [_userView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15.0);
            make.left.mas_equalTo(self.userImg.mas_right).mas_offset(5.0);
            make.top.mas_equalTo(18.0);
        }];
    }
    
    if (!_levelImg) {
        _levelImg = [[UIImageView alloc] init];
        [_levelImg setContentMode:UIViewContentModeScaleAspectFit];
        [_userView addSubview:_levelImg];
        [_levelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(32.0);
            make.height.mas_equalTo(15.0);
            make.left.mas_equalTo(self.nameLab.mas_right).mas_offset(5.0);
            make.centerY.mas_equalTo(self.nameLab);
        }];
    }
    
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setText:@"2019-09-09"];
        [_timeLab setTextColor:COLOR_666666];
        [_timeLab setFont:[UIFont systemFontOfSize:10.0]];
        [_userView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12.0);
            make.left.mas_equalTo(self.userImg.mas_right).mas_offset(5.0);
            make.top.mas_equalTo(self.nameLab.mas_bottom).mas_offset(5.0);
            make.right.mas_equalTo(self.userView);
        }];
    }
    
    if (!_fansView) {
        _fansView = [[UIView alloc] init];
        [_mainView addSubview:_fansView];
        [_fansView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView);
            make.bottom.mas_equalTo(self.mainView);
            make.right.mas_equalTo(-16.0);
            make.width.mas_greaterThanOrEqualTo(47.0);
        }];
    }
    
    if (!_fansLab) {
        _fansLab = [[UILabel alloc] init];
        [_fansLab setText:@"0"];
        [_fansLab setTextColor:COLOR_666666];
        [_fansLab setTextAlignment:NSTextAlignmentCenter];
        [_fansLab setFont:[UIFont systemFontOfSize:13.0]];
        [_fansView addSubview:_fansLab];
        [_fansLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansView);
            make.top.mas_equalTo(self.fansView);
            make.right.mas_equalTo(self.fansView);
            make.bottom.mas_equalTo(self.fansView);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapOperaButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansFirstCellHandleTapButtonActionWithTag:)]) {
        [self.delegate fansFirstCellHandleTapButtonActionWithTag:button.tag];
    }
}

@end
