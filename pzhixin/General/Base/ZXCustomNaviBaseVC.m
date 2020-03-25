//
//  ZXCustomNaviBaseVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCustomNaviBaseVC.h"
#import <Masonry/Masonry.h>

@interface ZXCustomNaviBaseVC ()

@property (strong, nonatomic) UIView *customNavBar;

@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) NSMutableArray *rightSubviews;

@end

@implementation ZXCustomNaviBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    self.fd_prefersNavigationBarHidden = YES;
    [self createCustomNavBar];
    [self createBackBtn];
    [self createTitleView];
    _rightSubviews = [[NSMutableArray alloc] init];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Block

//标题
- (ZXCustomNaviBaseVC *(^)(NSString *titleStr))titleStr {
    return ^ZXCustomNaviBaseVC *(NSString *titleStr) {
        [self.titleLab setText:titleStr];
        return self;
    };
}

//标题字体颜色
- (ZXCustomNaviBaseVC *(^)(UIColor *titleColor))titleColor {
    return ^ZXCustomNaviBaseVC *(UIColor *titleColor) {
        [self.titleLab setTextColor:titleColor];
        return self;
    };
}

//标题Font
- (ZXCustomNaviBaseVC *(^)(UIFont *titleFont))titleFont {
    return ^ZXCustomNaviBaseVC *(UIFont *titleFont) {
        [self.titleLab setFont:titleFont];
        return self;
    };
}

//是否隐藏返回按钮
- (ZXCustomNaviBaseVC *(^)(BOOL hideLeft))hideLeft {
    return ^ZXCustomNaviBaseVC *(BOOL hideLeft) {
        [self.backBtn setHidden:hideLeft];
        return self;
    };
}

//返回按钮是深色还是白色 YES == 白色 NO == 黑色
- (ZXCustomNaviBaseVC *(^)(BOOL light))light {
    return ^ZXCustomNaviBaseVC *(BOOL light) {
        if (light) {
            [self.backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
        } else {
            [self.backBtn setImage:[UIImage imageNamed:@"ic_whole_back"] forState:UIControlStateNormal];
        }
        return self;
    };
}

//导航栏背景色
- (ZXCustomNaviBaseVC *(^)(UIColor *bgColor))bgColor {
    return ^ZXCustomNaviBaseVC *(UIColor *bgColor) {
        [self.customNavBar setBackgroundColor:bgColor];
        return self;
    };
}

//右边按钮视图
- (ZXCustomNaviBaseVC *(^)(id rightItems))rightItems {
    //移除旧视图
    for (UIView *subView in _rightSubviews) {
        [subView removeFromSuperview];
    }
    _rightSubviews = [[NSMutableArray alloc] init];
    
    return ^ZXCustomNaviBaseVC *(id rightItems) {
        if ([rightItems isKindOfClass:[UIView class]]) {
            [self.customNavBar addSubview:rightItems];
            [rightItems mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(STATUS_HEIGHT);
                make.width.mas_equalTo(60.0);
                make.right.bottom.mas_equalTo(0.0);
            }];
            [self.rightSubviews addObject:rightItems];
        } else if ([rightItems isKindOfClass:[NSArray class]]) {
            for (int i = 0 ; i < [rightItems count]; i++) {
                UIButton *btn;
                if ([[rightItems objectAtIndex:i] isKindOfClass:[NSString class]]) {
                    btn = [self rightBtnWithTitle:[rightItems objectAtIndex:i]];
                } else if ([[rightItems objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                    btn = [self rightBtnWithImg:[rightItems objectAtIndex:i]];
                }
                [btn setTag:i];
                [btn addTarget:self action:@selector(handleTapRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.customNavBar addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0.0);
                    make.width.mas_equalTo(30.0);
                    make.top.mas_equalTo(STATUS_HEIGHT);
                    if (i == 0) {
                        make.right.mas_equalTo(-20.0);
                    } else {
                        make.right.mas_equalTo(-i * 30.0 - 25.0);
                    }
                }];
                [self.rightSubviews addObject:btn];
            }
        } else if ([rightItems isKindOfClass:[NSString class]]) {
            UIButton *btn = [self rightBtnWithTitle:rightItems];
            [btn setTag:0];
            [btn addTarget:self action:@selector(handleTapRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.customNavBar addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(0.0);
                make.width.mas_equalTo(60.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
            }];
            [self.rightSubviews addObject:btn];
        } else if ([rightItems isKindOfClass:[UIImage class]]) {
            UIButton *btn = [self rightBtnWithImg:rightItems];
            [btn setTag:0];
            [btn addTarget:self action:@selector(handleTapRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.customNavBar addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(0.0);
                make.width.mas_equalTo(60.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
            }];
            [self.rightSubviews addObject:btn];
        } else {
            
        }
        return self;
    };
}

#pragma mark - Button Methods

- (void)handleTapRightBtnAction:(UIButton *)btn {
    if (self.zxCustonNavBarRightBtnClick) {
        self.zxCustonNavBarRightBtnClick(btn.tag);
    }
}

#pragma mark - Private Methods

- (UIButton *)rightBtnWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    return button;
}

- (UIButton *)rightBtnWithImg:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (void)createCustomNavBar {
    if (!_customNavBar) {
        _customNavBar = [[UIView alloc] init];
        [_customNavBar setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_customNavBar];
        [_customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0.0);
            make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT);
        }];
    }
}

- (void)createBackBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_backBtn setImage:[UIImage imageNamed:@"ic_whole_back"] forState:UIControlStateNormal];
        [self.customNavBar addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
            make.width.mas_equalTo(60.0);
        }];
    }
}

- (void)createTitleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_customNavBar addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(STATUS_HEIGHT);
            make.bottom.mas_equalTo(0.0);
            make.centerX.mas_equalTo(self.customNavBar);
            make.width.mas_equalTo(150.0);
        }];
    }
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setFont:TITLE_FONT];
        [_titleLab setTextColor:HOME_TITLE_COLOR];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0.0);
        }];
    }
}

@end
