//
//  ZXEditIntroView.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditIntroView.h"
#import "UtilsMacro.h"

@implementation ZXEditIntroView

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
        [self creatEditIntroView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)creatEditIntroView {
    
    if (!_editIntroView) {
        _editIntroView = [[UIView alloc] init];
        [_editIntroView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_editIntroView];
        [_editIntroView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_introTextView) {
        _introTextView = [[UITextView alloc] init];
        [_introTextView setFont:[UIFont systemFontOfSize:15.0]];
        [_introTextView setTextColor:HOME_TITLE_COLOR];
        [_introTextView setScrollEnabled:NO];
        [_editIntroView addSubview:_introTextView];
        [_introTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0);
            make.right.mas_equalTo(-20.0);
            make.top.mas_equalTo(10.0);
            make.bottom.mas_equalTo(-10.0);
        }];
    }
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_tipLabel setTextColor:COLOR_999999];
        [_tipLabel setText:@"有趣的个人简介可以获得更多的关注哦~"];
        [_editIntroView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.0);
            make.top.mas_equalTo(16.0);
            make.right.mas_equalTo(-20.0);
            make.height.mas_equalTo(20.0);
        }];
    }
    
//    self.editIntroView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 100.0)];
//    [self.editIntroView setBackgroundColor:[UIColor whiteColor]];
//    [self addSubview:self.editIntroView];
//
//    self.introTextView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 10.0, self.editIntroView.frame.size.width - 40.0, self.editIntroView.frame.size.height - 20.0)];
//    [self.introTextView setFont:[UIFont systemFontOfSize:15.0]];
//    [self.introTextView setTextColor:HOME_TITLE_COLOR];
//    [self.introTextView setScrollEnabled:NO];
//    [self.editIntroView addSubview:self.introTextView];
//
//    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 16.0, self.editIntroView.frame.size.width - 40.0, 20.0)];
//    [self.tipLabel setFont:[UIFont systemFontOfSize:15.0]];
//    [self.tipLabel setTextColor:COLOR_999999];
//    [self.tipLabel setText:@"有趣的个人简介可以获得更多的关注哦~"];
//    [self.editIntroView addSubview:self.tipLabel];
}

@end
