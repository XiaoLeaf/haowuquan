//
//  ZXScoreCell.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreCell.h"

@implementation ZXScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.actionBtn.layer setCornerRadius:self.actionBtn.frame.size.height/2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setScoreRuleItem:(ZXScoreRuleItem *)scoreRuleItem {
    _scoreRuleItem = scoreRuleItem;
    [self.titleLab setText:_scoreRuleItem.title];
    [_descLab setText:_scoreRuleItem.desc];
    [_numLab setText:[NSString stringWithFormat:@"+%@",_scoreRuleItem.score]];
    [_actionBtn setTitle:_scoreRuleItem.btn_txt forState:UIControlStateNormal];
    switch ([_scoreRuleItem.status integerValue]) {
        case 1:
        {
            [_actionBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
            [_actionBtn setBackgroundColor:[UIColor whiteColor]];
            [_actionBtn.layer setBorderWidth:0.5];
            [_actionBtn.layer setBorderColor:COLOR_999999.CGColor];
        }
            break;
        case 2:
        {
            [_actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_actionBtn setBackgroundColor:THEME_COLOR];
            [_actionBtn.layer setBorderWidth:0.0];
        }
            break;
        case 3:
        {
            [_actionBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [_actionBtn setBackgroundColor:[UIColor whiteColor]];
            [_actionBtn.layer setBorderWidth:0.5];
            [_actionBtn.layer setBorderColor:THEME_COLOR.CGColor];
        }
            break;
        case 4:
        {
            [_actionBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [_actionBtn setBackgroundColor:[UIColor whiteColor]];
            [_actionBtn.layer setBorderWidth:0.5];
            [_actionBtn.layer setBorderColor:THEME_COLOR.CGColor];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Method

- (IBAction)handleTapActionBtnAction:(id)sender {
    if (self.zxScoreCellBtnClick) {
        self.zxScoreCellBtnClick();
    }
}

@end
