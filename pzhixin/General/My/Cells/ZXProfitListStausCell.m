//
//  ZXProfitListStausCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProfitListStausCell.h"
#import <Masonry/Masonry.h>

@interface ZXProfitListStausCell ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *userView;

@property (strong, nonatomic) UILabel *statusLab;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *moneyLab;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UILabel *createLab;

@property (strong, nonatomic) UILabel *clearLab;

@property (strong, nonatomic) UILabel *priceLab;

@end

@implementation ZXProfitListStausCell

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
            make.height.mas_equalTo(40.0);
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
            make.top.mas_equalTo(12.0);
            make.height.mas_equalTo(12.0);
        }];
    }
    
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        [_moneyLab setTextColor:THEME_COLOR];
        [_moneyLab setFont:[UIFont systemFontOfSize:13.0]];
        [_moneyLab setText:@"+200.0"];
        [_moneyLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_mainView addSubview:_moneyLab];
        [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.0);
            make.height.mas_equalTo(10.0);
            make.top.mas_equalTo(self.userView.mas_bottom).mas_offset(12.5);
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
            make.top.mas_equalTo(self.moneyLab.mas_bottom).mas_offset(10.0);
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
