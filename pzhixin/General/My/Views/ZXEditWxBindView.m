//
//  ZXEditWxBindView.m
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditWxBindView.h"

@implementation ZXEditWxBindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.logoImg.layer setCornerRadius:10.0];
    [self.userHeadImg.layer setCornerRadius:10.0];
    [self.bindBtn.layer setCornerRadius:2.0];
    
    UITapGestureRecognizer *tapUnBind = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapUnBindViewAction)];
    [self.unBindView addGestureRecognizer:tapUnBind];
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapUnBindViewAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editWxBindViewHandleTapUnBindViewAction)]) {
        [self.delegate editWxBindViewHandleTapUnBindViewAction];
    }
}

- (IBAction)handleTapBindBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editWxBindViewHanldeTapBindBtnAction)]) {
        [self.delegate editWxBindViewHanldeTapBindBtnAction];
    }
}

@end
