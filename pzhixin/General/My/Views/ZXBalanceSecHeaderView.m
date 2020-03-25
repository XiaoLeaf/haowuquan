//
//  ZXBalanceSecHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXBalanceSecHeaderView.h"

@interface ZXBalanceSecHeaderView ()

@end

@implementation ZXBalanceSecHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.typeBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [self.timeBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
}

#pragma mark - Button Method

- (IBAction)handleTapBtnActions:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.zxBalanceSecHeaderBtnClick) {
        self.zxBalanceSecHeaderBtnClick(btn.tag);
    }
}

@end
