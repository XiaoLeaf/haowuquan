//
//  ZXEditPhoneView.m
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditPhoneView.h"

@implementation ZXEditPhoneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.codeBtn.layer setCornerRadius:2.0];
    [self.submitBtn.layer setCornerRadius:2.0];
}

#pragma mark - Button Methods

- (IBAction)handleTapCodeBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPhoneHandleTapCodeBtnAction)]) {
        [self.delegate editPhoneHandleTapCodeBtnAction];
    }
}

- (IBAction)handleTapSubmitBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPhoneHandleTapSubmitBtnAction)]) {
        [self.delegate editPhoneHandleTapSubmitBtnAction];
    }
}

@end
