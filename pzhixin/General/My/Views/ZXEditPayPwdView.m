//
//  ZXEditPayPwdView.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditPayPwdView.h"
#import "UtilsMacro.h"

@implementation ZXEditPayPwdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createEditPayPwdView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createEditPayPwdView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 100.5)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    
    self.pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, contentView.frame.size.width - 20.0, 50.0)];
    [self.pwdTextField setFont:[UIFont systemFontOfSize:15.0]];
    [self.pwdTextField setTextColor:HOME_TITLE_COLOR];
    [self.pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.pwdTextField setPlaceholder:@"输入支付密码"];
    [self.pwdTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.pwdTextField setSecureTextEntry:YES];
    [self.pwdTextField setClearsOnBeginEditing:NO];
    [self.pwdTextField setClearsOnInsertion:NO];
    [contentView addSubview:self.pwdTextField];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20.0, self.pwdTextField.frame.origin.y + self.pwdTextField.frame.size.height, contentView.frame.size.width - 40.0, 0.5)];
    [line setBackgroundColor:BG_COLOR];
    [contentView addSubview:line];
    
    self.confirmTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, line.frame.origin.y + line.frame.size.height, contentView.frame.size.width - 20.0, 50.0)];
    [self.confirmTextField setFont:[UIFont systemFontOfSize:15.0]];
    [self.confirmTextField setTextColor:HOME_TITLE_COLOR];
    [self.confirmTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.confirmTextField setPlaceholder:@"确认支付密码"];
    [self.confirmTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.confirmTextField setSecureTextEntry:YES];
    [self.confirmTextField setClearsOnBeginEditing:NO];
    [self.confirmTextField setClearsOnInsertion:NO];
    [contentView addSubview:self.confirmTextField];
    
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setBackgroundColor:DEDEDE_COLOR];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setFrame:CGRectMake(20.0, contentView.frame.origin.y + contentView.frame.size.height + 40.0, SCREENWIDTH - 40.0, 40.0)];
    [self.submitBtn addTarget:self action:@selector(handleTapSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}

#pragma mark - Button Methods

- (void)handleTapSubmitBtnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPayPwdViewHandleTapSubmitBtnAction)]) {
        [self.delegate editPayPwdViewHandleTapSubmitBtnAction];
    }
}

@end
