//
//  ZXCustomNavView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCustomNavView : UIView

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIButton *leftButton;

@property (strong, nonatomic) UIButton *rightBtn;

@property (strong, nonatomic) UIButton *messageBtn;

@property (strong, nonatomic) UIButton *scanBtn;

@property (strong, nonatomic) UILabel *badgeDot;

@property (strong, nonatomic) UITextField *searchTextField;

@property (assign, nonatomic) BOOL leftHidden;

@property (strong, nonatomic) id leftContent;

@property (strong, nonatomic, nullable) id rightContent;

@property (nonatomic, copy) void(^leftButtonClick) (UIButton *btn);;

@property (nonatomic, copy) void(^rightButtonClick) (UIButton *btn);

@property (nonatomic, copy) void(^searchButtonClick) (void);

- (id)initWithLeftContent:(id _Nullable)left title:(id)title titleColor:(UIColor *)color rightContent:(nullable id)right leftDot:(BOOL)leftDot;

- (id)initWithSearchTF;

- (id)initWithSearchBtn;

- (id)initWithSearchTFAndCancelBtn;

#pragma mark - Home NaviBar

- (id)initHomeNaviBarWithRight:(id)right;

@end

NS_ASSUME_NONNULL_END
