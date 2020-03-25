//
//  ZXShareImgCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXShareImgCell.h"

@implementation ZXShareImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mainImg.layer setCornerRadius:1.0];
}

#pragma mark - Button Method

- (IBAction)handleTapPickBtnAction:(id)sender {
    [self.pickBtn setSelected:!self.pickBtn.isSelected];
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareImgCellHanleTapPickBtnActionWithCell:andTag:)]) {
        [self.delegate shareImgCellHanleTapPickBtnActionWithCell:self andTag:button.tag];
    }
}

@end
