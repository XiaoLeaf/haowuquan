//
//  ZXEarningCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningCell.h"

@interface ZXEarningCell ()

@property (strong, nonatomic) ZXProfitDetail *profitDetail;

@end

@implementation ZXEarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setProfitHome:(ZXProfitHome *)profitHome {
    _profitHome = profitHome;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            _profitDetail = [_profitHome day];
            break;
        case 1:
            _profitDetail = [_profitHome yesterday];
            break;
        case 2:
            _profitDetail = [_profitHome month];
            break;
        case 3:
            _profitDetail = [_profitHome last_month];
            break;
            
        default:
            break;
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_profitDetail.num]) {
        [self.orderCountLab setText:@"0"];
    } else {
        [self.orderCountLab setText:_profitDetail.num];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_profitDetail.pay_profit]) {
        [self.payLab setText:@"0"];
    } else {
        [self.payLab setText:_profitDetail.pay_profit];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_profitDetail.earn_profit]) {
        [self.totalLab setText:@"0"];
    } else {
        [self.totalLab setText:_profitDetail.earn_profit];
    }
}

#pragma mark - Button Method

- (IBAction)handleTapExplainBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(earningCellHandleTapAtExplainBtnActionWithTag:)]) {
        [self.delegate earningCellHandleTapAtExplainBtnActionWithTag:btn.tag];
    }
}

@end
