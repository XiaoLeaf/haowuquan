//
//  ZXCashDetailCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCashDetailCell.h"
#import <Masonry/Masonry.h>

@interface ZXCashDetailCell ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *createLab;

@property (strong, nonatomic) UILabel *handleLab;

@property (strong, nonatomic) UILabel *countLab;

@end

@implementation ZXCashDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)setCashList:(ZXCashList *)cashList {
    _cashList = cashList;
    if ([_cashList.status integerValue] == 3) {
        [self.cancelBtn setHidden:NO];
    } else {
        [self.cancelBtn setHidden:YES];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_cashList.status_str]) {
        [self.titleLab setText:@""];
    } else {
        [self.titleLab setText:_cashList.status_str];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_cashList.c_time]) {
        [self.createLab setText:@"创建时间:-"];
    } else {
        [self.createLab setText:[NSString stringWithFormat:@"创建时间:%@",_cashList.c_time]];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_cashList.s_time]) {
        [self.handleLab setText:@""];
    } else {
        [self.handleLab setText:[NSString stringWithFormat:@"处理时间:%@",_cashList.s_time]];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_cashList.amount]) {
        [self.countLab setText:@"0"];
    } else {
        [self.countLab setText:_cashList.amount];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_cashList.memo]) {
        [self.reasonLab setText:@""];
        [self.reasonLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.createLab.mas_bottom).mas_offset(0.0);
        }];
    } else {
        [self.reasonLab setText:_cashList.memo];
        [self.reasonLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.createLab.mas_bottom).mas_offset(8.0);
        }];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [self labelWithColor:HOME_TITLE_COLOR font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
        [_titleLab setText:@"提现中"];
        [_titleLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_mainView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17.0);
            make.top.mas_equalTo(15.0);
            make.height.mas_equalTo(15.0);
        }];
    }
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"撤销" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_cancelBtn.layer setBorderWidth:0.5];
        [_cancelBtn.layer setBorderColor:THEME_COLOR.CGColor];
        [_cancelBtn setClipsToBounds:YES];
        [_cancelBtn.layer setCornerRadius:2.0];
        [_cancelBtn addTarget:self action:@selector(handleTapCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_right).mas_equalTo(10.0);
            make.centerY.mas_equalTo(self.titleLab);
            make.width.mas_equalTo(30.0);
            make.height.mas_equalTo(15.0);
        }];
    }
    
    if (!_createLab) {
        _createLab = [self labelWithColor:COLOR_999999 font:[UIFont systemFontOfSize:10.0]];
        [_createLab setText:@"创建时间:2019-08-27  17:21"];
        [_mainView addSubview:_createLab];
        [_createLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17.0);
            make.top.mas_equalTo(self.titleLab.mas_bottom).mas_equalTo(12.0);
            make.height.mas_equalTo(10.0);
        }];
    }
    
    if (!_handleLab) {
        _handleLab = [self labelWithColor:COLOR_999999 font:[UIFont systemFontOfSize:10.0]];
        [_handleLab setText:@"处理时间:2019-08-27  17:21"];
        [_mainView addSubview:_handleLab];
        [_handleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.createLab);
            make.height.mas_equalTo(10.0);
            make.left.mas_equalTo(self.createLab.mas_right).mas_equalTo(10.0);
        }];
    }
    
    if (!_countLab) {
        _countLab = [self labelWithColor:HOME_TITLE_COLOR font:[UIFont systemFontOfSize:15.0]];
        [_countLab setText:@"-100"];
        [_mainView addSubview:_countLab];
        [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17.0);
            make.height.mas_equalTo(11.0);
            make.centerY.mas_equalTo(self.titleLab);
        }];
    }
    
    if (!_reasonLab) {
        _reasonLab = [self labelWithColor:[UtilsMacro colorWithHexString:@"E82C0E"] font:[UIFont systemFontOfSize:12.0]];
        [_reasonLab setNumberOfLines:0];
        [_mainView addSubview:_reasonLab];
        [_reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.createLab.mas_bottom).mas_offset(8.0);
            make.left.mas_equalTo(17.0);
            make.right.mas_equalTo(-17.0);
            make.bottom.mas_equalTo(-15.0);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"ECECEA"]];
    [_mainView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0);
        make.right.mas_equalTo(-16.0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0.0);
    }];
}


- (UILabel *)labelWithColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:color];
    [label setFont:font];
    return label;
}

#pragma mark - Button Method

- (void)handleTapCancelBtnAction:(UIButton *)button {
    if (self.zxCashDetailCellCancelClick) {
        self.zxCashDetailCellCancelClick(button.tag);
    }
}

@end
