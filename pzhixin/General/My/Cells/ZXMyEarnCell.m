//
//  ZXMyEarnCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyEarnCell.h"

@implementation ZXMyEarnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:BG_COLOR];
    // Initialization code
    [self.mainView.layer setCornerRadius:5.0];
    
    UITapGestureRecognizer *tapToday = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTodayViewAction)];
    [self.todayView addGestureRecognizer:tapToday];
    
    UITapGestureRecognizer *tapMonth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMonthViewAction)];
    [self.monthView addGestureRecognizer:tapMonth];
    
    UITapGestureRecognizer *tapLastMonth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLastMonthAction)];
    [self.lastMonthLab addGestureRecognizer:tapLastMonth];
    
    UITapGestureRecognizer *tapLastHope = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLastHopeAction)];
    [self.lastHopeLab addGestureRecognizer:tapLastHope];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapTodayViewAction {
    if (self.zxMyEarnCellSubViewClick) {
        self.zxMyEarnCellSubViewClick(0);
    }
}

- (void)handleTapMonthViewAction {
    if (self.zxMyEarnCellSubViewClick) {
        self.zxMyEarnCellSubViewClick(1);
    }
}

- (void)handleTapLastMonthAction {
    if (self.zxMyEarnCellSubViewClick) {
        self.zxMyEarnCellSubViewClick(2);
    }
}

- (void)handleTapLastHopeAction {
    if (self.zxMyEarnCellSubViewClick) {
        self.zxMyEarnCellSubViewClick(3);
    }
}

#pragma mark - Setter

- (void)setUserInfo:(ZXUser *)userInfo {
    _userInfo = userInfo;
    NSArray *userBtnList = [[NSArray alloc] initWithArray:_userInfo.sbtns];
    if (userBtnList.count > 0) {
        ZXUserBtn *firstUserBtn = (ZXUserBtn *)[userBtnList objectAtIndex:0];
        if ([UtilsMacro whetherIsEmptyWithObject:firstUserBtn.val]) {
            [self.todayLab setText:@"0"];
        } else {
            [self.todayLab setText:firstUserBtn.val];
        }
        if ([UtilsMacro whetherIsEmptyWithObject:firstUserBtn.name]) {
            [self.todayTitle setText:@""];
        } else {
            [self.todayTitle setText:firstUserBtn.name];
        }
    }
    
    if (userBtnList.count > 1) {
        ZXUserBtn *secondUserBtn = (ZXUserBtn *)[userBtnList objectAtIndex:1];
        if ([UtilsMacro whetherIsEmptyWithObject:secondUserBtn.val]) {
            [self.monthLab setText:@"0"];
        } else {
            [self.monthLab setText:secondUserBtn.val];
        }
        if ([UtilsMacro whetherIsEmptyWithObject:secondUserBtn.name]) {
            [self.monthTitle setText:@""];
        } else {
            [self.monthTitle setText:secondUserBtn.name];
        }
    }
    
    if (userBtnList.count > 2) {
        ZXUserBtn *thirdUserBtn = (ZXUserBtn *)[userBtnList objectAtIndex:2];
        if ([UtilsMacro whetherIsEmptyWithObject:thirdUserBtn.val]) {
            [self.lastMonthLab setText:@"上月收益(元) 0"];
        } else {
            [self.lastMonthLab setText:[NSString stringWithFormat:@"%@ %@",thirdUserBtn.name, thirdUserBtn.val]];
        }
    }
    
    if (userBtnList.count > 3) {
        ZXUserBtn *fouthUserBtn = (ZXUserBtn *)[userBtnList objectAtIndex:3];
        if ([UtilsMacro whetherIsEmptyWithObject:fouthUserBtn.val]) {
            [self.lastHopeLab setText:@"上月预估(元) 0"];
        } else {
            [self.lastHopeLab setText:[NSString stringWithFormat:@"%@ %@", fouthUserBtn.name, fouthUserBtn.val]];
        }
    }
}

@end
