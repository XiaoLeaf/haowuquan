//
//  ZXEarningFooterView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEarningFooterView.h"

@interface ZXEarningFooterView ()

@end

@implementation ZXEarningFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:BG_COLOR];
}

#pragma mark - Button Method

- (IBAction)handleTapIssueBtnAction:(id)sender {
    if (self.zxEarningFooterBtnClick) {
        self.zxEarningFooterBtnClick();
    }
}

@end
