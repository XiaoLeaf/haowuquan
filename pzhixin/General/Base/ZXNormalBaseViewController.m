//
//  ZXNormalBaseViewController.m
//  zhixin
//
//  Created by zx on 12/2/15.
//  Copyright © 2015 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

@interface ZXNormalBaseViewController ()
{
//    UIButton *leftBtn;
//    UIButton *rightBtn;
    UILabel *titleLabel;
}

@end

@implementation ZXNormalBaseViewController
@synthesize hiddenBackButton = _hiddenBackButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    self.navigationItem.titleView = [self titleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - setter

- (void)setHiddenBackButton:(BOOL)hiddenBackButton {
    _hiddenBackButton = hiddenBackButton;
    
    if (_hiddenBackButton) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title font:[UIFont systemFontOfSize:18] color:[UIColor whiteColor]];
}

#pragma mark - private methods

- (UIBarButtonItem *)backBarButtonItem {
    _leftBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [_leftBtn setImage:[UIImage imageNamed:@"ic_whole_back.png"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [_leftBtn setTitle:@"    " forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    return leftBtnItem;
}

- (UIView *)titleView {
    UIView *myTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [myTitleView setBackgroundColor:[UIColor clearColor]];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, myTitleView.frame.size.width, myTitleView.frame.size.height)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:self.title];
    [myTitleView addSubview:titleLabel];
    return myTitleView;
}

- (UIBarButtonItem *)rightBarButtonItem {
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_rightBtn setAdjustsImageWhenHighlighted:NO];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    return rightBtnItem;
}

- (UIBarButtonItem *)leftBarButtonItem {
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_leftBtn setAdjustsImageWhenHighlighted:NO];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    return leftBtnItem;
}

- (UIBarButtonItem *)customRightBarButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *customRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [customRightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [customRightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    customRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [customRightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customRightBtn setImage:image forState:UIControlStateNormal];
    [customRightBtn setAdjustsImageWhenHighlighted:NO];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:customRightBtn];
    return rightBtnItem;
}

#pragma mark - button tapped

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - public methods

- (void)setTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    if (titleLabel != nil) {
        [titleLabel setText:title];
        [titleLabel setFont:font];
        [titleLabel setTextColor:color];
    }
}

- (void)setRightBtnTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self setRightBtnTitle:title font:[UIFont systemFontOfSize:12.0f] color:HOME_TITLE_COLOR target:target action:action];
    [self setRightTitle:title];
}

- (void)setRightBtnTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action {
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn.titleLabel setFont:font];
    [_rightBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)setLeftBtnTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self setLeftBtnTitle:title font:[UIFont systemFontOfSize:15.0] target:target action:action];
}

- (void)setLeftBtnTitle:(NSString *)title font:(UIFont *)font target:(id)target action:(SEL)action {
    [self.navigationItem setLeftBarButtonItem:[self leftBarButtonItem]];
    [_leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setTitle:title forState:UIControlStateNormal];
    [_leftBtn.titleLabel setFont:font];
}

- (void)setRightBtnImage:(UIImage *)image target:(id)target action:(SEL)action {
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setImage:image forState:UIControlStateNormal];
}

- (void)setRightBtnImage:(UIImage *)image andHighLightImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setImage:image forState:UIControlStateNormal];
    [_rightBtn setImage:highImage forState:UIControlStateHighlighted];
}

- (void)setLeftBtnImage:(UIImage *)image target:(id)target action:(SEL)action {
    [self.navigationItem setLeftBarButtonItem:[self backBarButtonItem]];
    [_leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setImage:image forState:UIControlStateNormal];
}

- (void)setRightBtnImgae:(UIImage *)image andTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self setRightBtnTitle:title font:[UIFont systemFontOfSize:15.0f] color:HOME_TITLE_COLOR target:target action:action];
    [self setRightTitle:title];
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [_rightBtn setImage:image forState:UIControlStateNormal];
    [_rightBtn setImage:image forState:UIControlStateHighlighted];
    [_rightBtn setAdjustsImageWhenHighlighted:NO];
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, _rightBtn.titleLabel.frame.size.width + 5.0);
//    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _rightBtn.imageView.frame.size.width + 10.0, 0, 0);
}

- (void)setRightsBtnImages:(NSArray *)images targets:(NSArray *)targets actionStrings:(NSArray *)actionStrings {
    if ([images count] <= 0 || [images count] != [targets count] || [images count] != [actionStrings count] || [targets count] != [actionStrings count]) {
        return;
    }
    NSMutableArray *items = [NSMutableArray new];
    for (int i = 0; i < [images count]; i++) {
        [items addObject:[self customRightBarButtonItemWithImage:[images objectAtIndex:i] target:[targets objectAtIndex:i] action:NSSelectorFromString([actionStrings objectAtIndex:i])]];
    }
    [self.navigationItem setRightBarButtonItems:items];
}

@end
