//
//  ZXCustomNavView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCustomNavView.h"
#import <Masonry/Masonry.h>

#define DOT_WIDTH 8.0

@interface ZXCustomNavView ()

@property (strong, nonatomic) UIView *customNav;

@property (strong, nonatomic) NSMutableArray *leftList;

@property (strong, nonatomic) NSMutableArray *rightList;

@end

@implementation ZXCustomNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - init

- (id)initWithLeftContent:(id _Nullable)left title:(id)title titleColor:(UIColor *)color rightContent:(id)right leftDot:(BOOL)leftDot {
    self = [super init];
    [self setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [self addSubview:[self customNavigationViewWithLeftContent:left title:title titleColor:color andRightContent:right leftDot:leftDot]];
    return self;
}

- (id)initWithSearchTF {
    self = [super init];
    [self setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [self customViewWithSearchTextField];
    return self;
}

- (id)initWithSearchBtn {
    self = [super init];
    [self setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [self customViewWithSearchBtn];
    return self;
}

- (id)initHomeNaviBarWithRight:(id)right {
    self = [super init];
    [self setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [self homeNaviBarWithRight:right];
    return self;
}

- (id)initWithSearchTFAndCancelBtn {
    self = [super init];
    [self setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [self searchVCNavBar];
    return self;
}

#pragma mark - Setter

- (void)setLeftHidden:(BOOL)leftHidden {
    _leftHidden = leftHidden;
    [_leftButton setHidden:_leftHidden];
}

- (void)setLeftContent:(id)leftContent {
    for (UIView *subView in _leftList) {
        [subView removeFromSuperview];
    }
    _leftList = [[NSMutableArray alloc] init];
    if ([leftContent isKindOfClass:[UIImage class]]) {
        _leftButton = [self leftBtnWithImage:leftContent];
        [_leftList addObject:_leftButton];
        [_customNav addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
        }];
    } else if ([leftContent isKindOfClass:[NSString class]]) {
        _leftButton = [self leftBtnWithTitle:leftContent];
        [_leftList addObject:_leftButton];
        [_customNav addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
        }];
    } else if ([leftContent isKindOfClass:[NSArray class]]) {
        NSArray *contentList = (NSArray *)leftContent;
        for (int i = 0; i < contentList.count; i++) {
            UIButton *tempBtn;
            if ([[contentList objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                tempBtn = [self leftBtnWithImage:[contentList objectAtIndex:i]];
            } else {
                tempBtn = [self leftBtnWithTitle:[contentList objectAtIndex:i]];
            }
            [tempBtn setTag:i];
            [_customNav addSubview:tempBtn];
            [_leftList addObject:tempBtn];
            [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.mas_equalTo(i * 30.0 + 20.0);
                } else {
                    make.left.mas_equalTo(i * 30.0 + 25.0);
                }
                make.width.mas_equalTo(30.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
                make.bottom.mas_equalTo(0.0);
            }];
        }
    }
}

- (void)setRightContent:(id)rightContent {
    for (UIView *subView in _rightList) {
        [subView removeFromSuperview];
    }
    [_rightList removeAllObjects];
    if ([UtilsMacro whetherIsEmptyWithObject:rightContent]) {
        return;
    }
    if ([rightContent isKindOfClass:[NSArray class]]) {
        NSArray *contentList = (NSArray *)rightContent;
        for (int i = 0; i < [contentList count]; i++) {
            UIButton *tempBtn;
            if ([[contentList objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                tempBtn = [self rightBtnWithImage:[contentList objectAtIndex:i]];
            } else {
                tempBtn = [self rightBtnWithTitle:[contentList objectAtIndex:i]];
            }
            [tempBtn setTag:i];
            [_customNav addSubview:tempBtn];
            [_rightList addObject:tempBtn];
            [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.right.mas_equalTo(-i * 30.0 - 20.0);
                } else {
                    make.right.mas_equalTo(-i * 30.0 - 25.0);
                }
                make.width.mas_equalTo(30.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
                make.bottom.mas_equalTo(0.0);
            }];
        }
    } else if ([rightContent isKindOfClass:[NSString class]]) {
        UIButton *tempBtn = [self rightBtnWithTitle:rightContent];
        _rightBtn = tempBtn;
        [_customNav addSubview:_rightBtn];
        [_rightList addObject:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20.0);
            make.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
        }];
    } else {
        UIButton *tempBtn = [self rightBtnWithImage:rightContent];
        _rightBtn = tempBtn;
        [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_customNav addSubview:_rightBtn];
        [_rightList addObject:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
        }];
    }
}

#pragma mark - Private Methods

- (UIView *)customNavigationViewWithLeftContent:(id)left title:(id)title titleColor:(UIColor *)color andRightContent:(id)right leftDot:(BOOL)leftDot {
    _rightList = [[NSMutableArray alloc] init];
    _leftList = [[NSMutableArray alloc] init];
    _customNav = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [self addSubview:_customNav];
    [_customNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0.0);
    }];

    if ([left isKindOfClass:[UIImage class]]) {
        _leftButton = [self leftBtnWithImage:left];
        [_leftList addObject:_leftButton];
        if (!_badgeDot && leftDot) {
            [self createBadgeDot];
        }
        [_leftButton addSubview:_badgeDot];
        [_badgeDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-22.0 + DOT_WIDTH/2.0);
            make.width.height.mas_equalTo(DOT_WIDTH);
            make.centerY.mas_equalTo(self.leftButton).mas_offset(-DOT_WIDTH + 1.0);
        }];
        [_customNav addSubview:_leftButton];
    } else if ([left isKindOfClass:[NSString class]]) {
        _leftButton = [self leftBtnWithTitle:left];
        [_leftList addObject:_leftButton];
        if (!_badgeDot && leftDot) {
            [self createBadgeDot];
        }
        [_leftButton addSubview:_badgeDot];
        [_badgeDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-22.0 + DOT_WIDTH/2.0);
            make.width.height.mas_equalTo(DOT_WIDTH);
            make.centerY.mas_equalTo(self.leftButton).mas_offset(-DOT_WIDTH + 1.0);
        }];
        [_customNav addSubview:_leftButton];
    } else if ([left isKindOfClass:[NSArray class]]) {
        NSArray *contentList = (NSArray *)left;
        for (int i = 0; i < contentList.count; i++) {
            UIButton *tempBtn;
            if ([[contentList objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                tempBtn = [self leftBtnWithImage:[contentList objectAtIndex:i]];
            } else {
                tempBtn = [self leftBtnWithTitle:[contentList objectAtIndex:i]];
            }
            [tempBtn setTag:i];
            [_customNav addSubview:tempBtn];
            [_leftList addObject:tempBtn];
            [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.mas_equalTo(-i * 30.0 - 20.0);
                } else {
                    make.left.mas_equalTo(-i * 30.0 - 25.0);
                }
                make.width.mas_equalTo(30.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
                make.bottom.mas_equalTo(0.0);
            }];
        }
    }
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(60.0);
        make.top.mas_equalTo(STATUS_HEIGHT);
    }];
    
    UIView *titleView = [[UIView alloc] init];
    [_customNav addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_customNav);
        make.top.mas_equalTo(STATUS_HEIGHT);
        make.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(180.0);
    }];
    
    if ([title isKindOfClass:[UIImage class]]) {
        UIImageView *titleImg = [[UIImageView alloc] init];
        [titleImg setContentMode:UIViewContentModeScaleAspectFit];
        [titleImg setImage:title];
        [titleView addSubview:titleImg];
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.centerY.mas_equalTo(titleView);
            make.height.mas_equalTo(20.0);
        }];
    } else if ([title isKindOfClass:[NSString class]]) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setText:title];
        [_titleLab setFont:TITLE_FONT];
        [_titleLab setTextColor:color];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0.0);
        }];
    } else {
        [titleView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(titleView);
            make.width.mas_equalTo(150.0);
            make.height.mas_equalTo(25.0);
        }];
    }
    
    if (![UtilsMacro whetherIsEmptyWithObject:right]) {
        if ([right isKindOfClass:[NSArray class]]) {
            NSArray *contentList = (NSArray *)right;
            for (int i = 0; i < [contentList count]; i++) {
                UIButton *tempBtn;
                if ([[contentList objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                    tempBtn = [self rightBtnWithImage:[contentList objectAtIndex:i]];
                } else {
                    tempBtn = [self rightBtnWithTitle:[contentList objectAtIndex:i]];
                }
                [tempBtn setTag:i];
                [_customNav addSubview:tempBtn];
                [_rightList addObject:tempBtn];
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i == 0) {
                        make.right.mas_equalTo(-i * 30.0 - 20.0);
                    } else {
                        make.right.mas_equalTo(-i * 30.0 - 25.0);
                    }
                    make.width.mas_equalTo(30.0);
                    make.top.mas_equalTo(STATUS_HEIGHT);
                    make.bottom.mas_equalTo(0.0);
                }];
            }
        } else if ([right isKindOfClass:[NSString class]]) {
            UIButton *tempBtn = [self rightBtnWithTitle:right];
            _rightBtn = tempBtn;
            [_customNav addSubview:_rightBtn];
            [_rightList addObject:_rightBtn];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0.0);
                make.width.mas_equalTo(60.0);
                make.right.mas_equalTo(-20.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
            }];
        } else {
            UIButton *tempBtn = [self rightBtnWithImage:right];
            _rightBtn = tempBtn;
            [_customNav addSubview:_rightBtn];
            [_rightList addObject:_rightBtn];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0.0);
                make.width.mas_equalTo(60.0);
                make.right.mas_equalTo(-20.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
            }];
        }
    }
    
    return _customNav;
}

- (UIButton *)leftBtnWithImage:(UIImage *)image {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:image forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return leftBtn;
}

- (UIButton *)leftBtnWithTitle:(NSString *)title {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return leftBtn;
}

- (void)leftBtnClick:(UIButton *)button {
    if (self.leftButtonClick) {
        self.leftButtonClick(button);
    }
}

- (UIButton *)rightBtnWithImage:(UIImage *)image {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:image forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

- (UIButton *)rightBtnWithTitle:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

- (void)rightBtnClick:(UIButton *)button {
    if (self.rightButtonClick) {
        self.rightButtonClick(button);
    }
}

#pragma mark - Custom With TextField

- (void)customViewWithSearchTextField {
    UIButton *leftBtn = [self leftBtnWithImage:[UIImage imageNamed:@"ic_whole_back"]];
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.0);
        make.top.mas_equalTo(STATUS_HEIGHT);
        make.width.mas_equalTo(60.0);
    }];

    _searchTextField = [[UITextField alloc] init];
    [_searchTextField setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F2F6"]];
    [_searchTextField setPlaceholder:@"粘贴宝贝标题，先领券再购物"];
    [_searchTextField setTextColor:HOME_TITLE_COLOR];
    [_searchTextField setFont:[UIFont systemFontOfSize:14.0]];
    [_searchTextField.layer setCornerRadius:16.0];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField setClipsToBounds:YES];
    [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, 26.0)];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 3.0, 12.0, 20.0)];
    [iconImg setImage:[UIImage imageNamed:@"icon_search"]];
    [iconImg setContentMode:UIViewContentModeScaleAspectFill];
    [leftView addSubview:iconImg];
    [_searchTextField setLeftView:leftView];
    [_searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32.0);
        make.right.mas_equalTo(-20.0);
        make.top.mas_equalTo(STATUS_HEIGHT + 6.0);
        make.left.mas_equalTo(leftBtn.mas_right);
    }];
}

#pragma mark - Custom With Button

- (void)customViewWithSearchBtn {
    _leftButton = [self leftBtnWithImage:[UIImage imageNamed:@"ic_whole_back"]];
    [self addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.0);
        make.top.mas_equalTo(STATUS_HEIGHT);
        make.width.mas_equalTo(60.0);
    }];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"粘贴宝贝标题，先领券再购物" forState:UIControlStateNormal];
    [searchBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [searchBtn.layer setCornerRadius:16.0];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)];
    [searchBtn setAdjustsImageWhenHighlighted:NO];
    [searchBtn addTarget:self action:@selector(handleTapSearchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftButton.mas_right);
        make.right.mas_equalTo(-20.0);
        make.height.mas_equalTo(32.0);
        make.top.mas_equalTo(STATUS_HEIGHT + 6.0);
    }];
}

- (void)handleTapSearchBtnAction {
    if (self.searchButtonClick) {
        self.searchButtonClick();
    }
}

#pragma mark - Home NaviBar

- (void)homeNaviBarWithRight:(id)right {
//    _leftButton = [self leftBtnWithImage:[UIImage imageNamed:@"ic_spend_title"]];
//    [self addSubview:_leftButton];
//    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12.0);
//        make.width.mas_equalTo(40.0);
//        make.height.mas_equalTo(22.0);
//        make.top.mas_equalTo(STATUS_HEIGHT + 11.0);
//    }];
    
    if (![UtilsMacro whetherIsEmptyWithObject:right]) {
        if ([right isKindOfClass:[NSArray class]]) {
            NSArray *contentList = (NSArray *)right;
            for (int i = 0; i < [contentList count]; i++) {
                UIButton *tempBtn;
                if ([[contentList objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                    tempBtn = [self rightBtnWithImage:[contentList objectAtIndex:i]];
                } else {
                    tempBtn = [self rightBtnWithTitle:[contentList objectAtIndex:i]];
                }
                if (i == 1) {
                    _messageBtn = tempBtn;
                    if (!_badgeDot) {
                        [self createBadgeDot];
                    }
                    [tempBtn addSubview:_badgeDot];
                    [_badgeDot mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(0.0);
                        make.width.height.mas_equalTo(DOT_WIDTH);
                        make.centerY.mas_equalTo(tempBtn).mas_offset(-DOT_WIDTH);
                    }];
                }
                [tempBtn setTag:i];
                [self addSubview:tempBtn];
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i == 0) {
                        make.right.mas_equalTo(-i * 30.0 - 12.0);
                    } else {
                        make.right.mas_equalTo(-i * 30.0 - 17.0);
                    }
                    make.width.mas_equalTo(30.0);
                    make.top.mas_equalTo(STATUS_HEIGHT);
                    make.bottom.mas_equalTo(0.0);
                }];
            }
        }
    }
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"先领券再购物" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [searchBtn setImage:[UIImage imageNamed:@"icon_search_home"] forState:UIControlStateNormal];
    [searchBtn.layer setCornerRadius:16.0];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [searchBtn setAdjustsImageWhenHighlighted:NO];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [searchBtn addTarget:self action:@selector(handleTapHomeNaviBarSearchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    [self addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.width.mas_equalTo(SCREENWIDTH * 175 / 375);
        make.left.mas_equalTo(12.0);
        make.right.mas_equalTo(-2 * 30.0 - 17.0 - 12.0);
        make.height.mas_equalTo(32.0);
        make.top.mas_equalTo(STATUS_HEIGHT + 6.0);
    }];
}

- (void)handleTapHomeNaviBarSearchBtnAction {
    if (self.searchButtonClick) {
        self.searchButtonClick();
    }
}

- (UILabel *)createBadgeDot {
    if (!_badgeDot) {
        _badgeDot = [[UILabel alloc] init];
        [_badgeDot setClipsToBounds:YES];
        if ([[ZXAppConfigHelper sharedInstance] appBadge] > 0) {
            [_badgeDot setHidden:NO];
        } else {
            [_badgeDot setHidden:YES];
        }
        [_badgeDot.layer setCornerRadius:DOT_WIDTH/2.0];
        [_badgeDot setBackgroundColor:[UIColor redColor]];
    }
    return _badgeDot;
}

- (void)searchVCNavBar {
    _rightBtn = [self rightBtnWithTitle:@"取消"];
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_HEIGHT);
        make.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(60.0);
        make.right.mas_equalTo(-15.0);
    }];

    _searchTextField = [[UITextField alloc] init];
    [_searchTextField setBackgroundColor:UIColor.whiteColor];
    [_searchTextField setPlaceholder:@"粘贴宝贝标题，先领券再购物"];
    [_searchTextField setTextColor:HOME_TITLE_COLOR];
    [_searchTextField setFont:[UIFont systemFontOfSize:14.0]];
    [_searchTextField.layer setCornerRadius:16.0];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField setClipsToBounds:YES];
    [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, 26.0)];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 3.0, 12.0, 20.0)];
    [iconImg setImage:[UIImage imageNamed:@"icon_search"]];
    [iconImg setContentMode:UIViewContentModeScaleAspectFill];
    [leftView addSubview:iconImg];
    [_searchTextField setLeftView:leftView];
    [_searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32.0);
        make.right.mas_equalTo(self.rightBtn.mas_left);
        make.top.mas_equalTo(STATUS_HEIGHT + 6.0);
        make.left.mas_equalTo(15.0);
    }];
}

@end
