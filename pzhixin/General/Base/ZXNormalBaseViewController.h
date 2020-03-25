//
//  ZXNormalBaseViewController.h
//  zhixin
//
//  Created by zx on 12/2/15.
//  Copyright © 2015 zhixin. All rights reserved.
//

#import "ZXBaseViewController.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface ZXNormalBaseViewController : ZXBaseViewController

@property (nonatomic, assign) BOOL hiddenBackButton;
@property (strong, nonatomic) NSString *rightTitle;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

- (void)setTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color;
//- (void)setTitle:(NSString *)title font:(UIFont *)font;
- (void)setRightBtnTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setRightBtnTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;
- (void)setRightBtnImage:(UIImage *)image target:(id)target action:(SEL)action;
- (void)setRightBtnImage:(UIImage *)image andHighLightImage:(UIImage *)highImage target:(id)target action:(SEL)action;
- (void)setRightsBtnImages:(NSArray *)images targets:(NSArray *)targets actionStrings:(NSArray *)actionStrings;
- (void)setRightBtnImgae:(UIImage *)image andTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setLeftBtnImage:(UIImage *)image target:(id)target action:(SEL)action;

- (void)setLeftBtnTitle:(NSString *)title target:(id)target action:(SEL)action;

#pragma mark - button tapped

- (void)backButtonPressed:(id)sender;

@end
