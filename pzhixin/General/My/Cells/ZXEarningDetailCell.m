//
//  ZXEarningDetailCell.m
//  pzhixin
//
//  Created by zhixin on 2019/8/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningDetailCell.h"
#import <Masonry/Masonry.h>

@interface ZXEarningDetailCell ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *userView;

@property (strong, nonatomic) UIImageView *headImg;

@property (strong, nonatomic) UILabel *nameLab;

@property (strong, nonatomic) UILabel *phoneLab;

@property (strong, nonatomic) UILabel *statusLab;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *moneyLab;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UILabel *createLab;

@property (strong, nonatomic) UILabel *clearLab;

@property (strong, nonatomic) UILabel *priceLab;

@end

@implementation ZXEarningDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}

- (void)setProfitList:(ZXProfitList *)profitList {
    _profitList = profitList;

    ZXUser *user = (ZXUser *)[_profitList user];
    [self.nameLab setText:user.nickname];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:user.icon] imageView:self.headImg placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    [self.phoneLab setText:[[user tel] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    if ([_profitList.status integerValue] == 2) {
        [_statusLab setTextColor:[UtilsMacro colorWithHexString:@"02C46C"]];
    } else {
        [_statusLab setTextColor:[UtilsMacro colorWithHexString:@"E82C0E"]];
    }
    [self.statusLab setText:_profitList.status_str];
    [self.titleLab setText:_profitList.title];
    [self.createLab setText:[NSString stringWithFormat:@"创建时间:%@",_profitList.create_time]];
    [self.clearLab setText:[NSString stringWithFormat:@"结算时间:%@",_profitList.earning_time]];
    [self.moneyLab setText:[NSString stringWithFormat:@"+ %@",_profitList.bonus]];
    [self.priceLab setText:[NSString stringWithFormat:@"消费金额:%@",_profitList.amount]];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Private Method

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0.0);
        }];
    }
    
    if (!_userView) {
        _userView = [[UIView alloc] init];
        [_mainView addSubview:_userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0.0);
//            make.height.mas_equalTo(46.0);
        }];
    }
    
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        [_headImg setContentMode:UIViewContentModeScaleAspectFill];
        [_headImg setClipsToBounds:YES];
        [_headImg.layer setCornerRadius:2.0];
        [_userView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25.0);
            make.top.mas_equalTo(12.0);
            make.left.mas_equalTo(15.0);
            make.bottom.mas_equalTo(-9.0).priorityHigh();
        }];
    }
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        [_nameLab setFont:[UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium]];
        [_nameLab setTextColor:COLOR_666666];
        [_nameLab setText:@"Leaf"];
        [_userView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImg.mas_right).mas_offset(5.0);
            make.top.mas_equalTo(12.0);
            make.height.mas_equalTo(13.0);
        }];
    }
    
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        [_phoneLab setFont:[UIFont systemFontOfSize:10.0]];
        [_phoneLab setTextColor:COLOR_999999];
        [_phoneLab setText:@"188****8169"];
        [_userView addSubview:_phoneLab];
        [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLab.mas_bottom);
            make.left.mas_equalTo(self.headImg.mas_right).mas_offset(5.0);
            make.height.mas_equalTo(12.0);
        }];
    }
    
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        [_statusLab setText:@"正在维权中！"];
        [_statusLab setTextColor:[UtilsMacro colorWithHexString:@"02C46C"]];
        [_statusLab setFont:[UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium]];
        [_userView addSubview:_statusLab];
        [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        [_moneyLab setTextColor:THEME_COLOR];
        [_moneyLab setFont:[UIFont systemFontOfSize:13.0]];
        [_moneyLab setText:@"+200.0"];
        [_moneyLab setTextAlignment:NSTextAlignmentRight];
        [_moneyLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_mainView addSubview:_moneyLab];
        [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.0);
            make.height.mas_equalTo(15.0);
            make.top.mas_equalTo(self.userView.mas_bottom);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }

    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setFont:[UIFont systemFontOfSize:13.0]];
        [_titleLab setTextColor:COLOR_666666];
        [_titleLab setText:@"惠灵顿腕表手表男丹尼尔惠灵顿腕表灵顿DW惠灵顿腕表手表男丹尼尔惠灵顿腕表灵顿DW"];
        [_mainView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0);
            make.height.mas_equalTo(15.0);
            make.top.mas_equalTo(self.userView.mas_bottom);
            make.right.mas_equalTo(self.moneyLab.mas_left).mas_offset(-30.0);
        }];
    }

    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [_mainView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0);
            make.right.mas_equalTo(-15.0);
            make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10.0);
            make.bottom.mas_equalTo(-12.0);
        }];
    }

    if (!_createLab) {
        _createLab = [[UILabel alloc] init];
        [_createLab setTextColor:COLOR_999999];
        [_createLab setFont:[UIFont systemFontOfSize:10.0]];
        [_createLab setText:@"创建:07-30 09:54"];
        [_bottomView addSubview:_createLab];
        [_createLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
        }];
    }

    if (!_clearLab) {
        _clearLab = [[UILabel alloc] init];
        [_clearLab setTextColor:COLOR_999999];
        [_clearLab setFont:[UIFont systemFontOfSize:10.0]];
        [_clearLab setText:@"结算:09-14 15:23"];
        [_bottomView addSubview:_clearLab];
        [_clearLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(self.createLab.mas_right).mas_offset(10.0);
        }];
    }

    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        [_priceLab setTextColor:COLOR_999999];
        [_priceLab setFont:[UIFont systemFontOfSize:10.0]];
        [_priceLab setText:@"消费金额 ￥10000.90"];
        [_bottomView addSubview:_priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0.0);
        }];
    }
}

@end
