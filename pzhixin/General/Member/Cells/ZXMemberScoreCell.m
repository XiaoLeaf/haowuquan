//
//  ZXMemberScoreCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMemberScoreCell.h"
#import <Masonry/Masonry.h>
#import "ZXScoreCell.h"

@interface ZXMemberScoreCell () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *scoreView;

@property (strong, nonatomic) UIButton *moreBtn;

@property (strong, nonatomic) UITableView *scoreTable;

@end

@implementation ZXMemberScoreCell

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
        
    }
    return self;
}

#pragma mark - Setter

- (void)setTaskList:(NSArray *)taskList {
    _taskList = taskList;
    [self setBackgroundColor:BG_COLOR];
    [self createSubviews];
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5.0);
            make.left.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
        }];
    }

    if (!_scoreView) {
        _scoreView = [[UIView alloc] init];
        [_scoreView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_scoreView];
        [_scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.left.right.mas_equalTo(self.mainView);
            make.height.mas_equalTo(40.0 + [self.taskList count] * 65.0);
        }];
    }

    UIView *scoreHeader = [[UIView alloc] init];
    [self.scoreView addSubview:scoreHeader];
    [scoreHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.scoreView);
        make.height.mas_equalTo(39.5);
    }];

    UIView *scoreTip = [[UIView alloc] init];
    [scoreTip setBackgroundColor:[UtilsMacro colorWithHexString:@"F6AF55"]];
    [scoreTip.layer setCornerRadius:1.0];
    [scoreHeader addSubview:scoreTip];
    [scoreTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0);
        make.height.mas_equalTo(15.0);
        make.centerY.mas_equalTo(scoreHeader);
        make.width.mas_equalTo(2.0);
    }];

    UILabel *scoreTitle = [[UILabel alloc] init];
    [scoreTitle setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
    [scoreTitle setTextColor:HOME_TITLE_COLOR];
    [scoreTitle setText:@"积分任务"];
    [scoreHeader addSubview:scoreTitle];
    [scoreTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scoreTip.mas_right).mas_offset(6.0);
        make.top.bottom.mas_equalTo(scoreHeader);
        make.width.mas_equalTo(0.0).priorityLow();
    }];

    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"ic_member_arrow"] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_moreBtn setTag:0];
        [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_moreBtn addTarget:self action:@selector(handleTapMemberScoreCellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [scoreHeader addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(scoreHeader);
            make.right.mas_equalTo(scoreHeader).mas_offset(16.0);
            make.width.mas_equalTo(100.0);
        }];

        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_moreBtn.imageView.frame.size.width, 0, _moreBtn.imageView.frame.size.width);
        _moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _moreBtn.titleLabel.frame.size.width, 0, -_moreBtn.titleLabel.frame.size.width);
    }

    UIView *scoreLine = [[UIView alloc] init];
    [scoreLine setBackgroundColor:[UtilsMacro colorWithHexString:@"EFEFEF"]];
    [_scoreView addSubview:scoreLine];
    [scoreLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scoreView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(scoreHeader.mas_bottom);
    }];

    if (!_scoreTable) {
        _scoreTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_scoreTable setShowsVerticalScrollIndicator:NO];
        [_scoreTable setShowsHorizontalScrollIndicator:NO];
        [_scoreTable setScrollEnabled:NO];
        [_scoreTable setDelegate:self];
        [_scoreTable setDataSource:self];
        [_scoreTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_scoreView addSubview:_scoreTable];
        [_scoreTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.0);
            make.top.mas_equalTo(scoreLine.mas_bottom);
        }];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.taskList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXScoreCell";
    ZXScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXScoreCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.mainLeft setConstant:0.0];
    [cell.mainRight setConstant:0.0];
//    [cell setDelegate:self];
    [cell.actionBtn setTag:indexPath.row];
    return cell;
}

#pragma mark - Button Method

- (void)handleTapMemberScoreCellBtnAction:(UIButton *)btn {
    if (self.zxMemberScoreCellBtnClick) {
        self.zxMemberScoreCellBtnClick();
    }
}

@end
