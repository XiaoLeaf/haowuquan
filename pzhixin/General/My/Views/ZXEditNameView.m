//
//  ZXEditNameView.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditNameView.h"

@implementation ZXEditNameView

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
        [self creatEditNameView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)creatEditNameView {
    UIView *editNameView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 50.0)];
    [editNameView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:editNameView];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, editNameView.frame.size.width - 40.0, editNameView.frame.size.height)];
    [self.nameTextField setTextColor:HOME_TITLE_COLOR];
    [self.nameTextField setFont:[UIFont systemFontOfSize:15.0]];
    [self.nameTextField setPlaceholder:@"请输入昵称"];
    [self.nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [editNameView addSubview:self.nameTextField];
}

@end
