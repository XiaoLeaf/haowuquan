//
//  ZXEditWxView.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditWxView.h"
#import "UtilsMacro.h"

@implementation ZXEditWxView

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
        [self creatEditWxView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)creatEditWxView {
    UIView *editWxView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 50.0)];
    [editWxView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:editWxView];
    
    self.wxTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, editWxView.frame.size.width - 40.0, editWxView.frame.size.height)];
    [self.wxTextField setTextColor:HOME_TITLE_COLOR];
    [self.wxTextField setFont:[UIFont systemFontOfSize:15.0]];
    [self.wxTextField setPlaceholder:@"请输入微信号"];
    [self.wxTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [editWxView addSubview:self.wxTextField];
}

@end
