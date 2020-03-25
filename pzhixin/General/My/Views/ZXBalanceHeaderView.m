//
//  ZXBalanceHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXBalanceHeaderView.h"

@implementation ZXBalanceHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mainView.layer setCornerRadius:5.0];
    self.balanceLabel.format = @"%.2f";
    self.balanceLabel.animationDuration = 0.5;
    
    //设置渐变色背景
    CAGradientLayer *gradinentLayer = [CAGradientLayer layer];
    [gradinentLayer setColors:@[(__bridge id)[UtilsMacro colorWithHexString:@"FF5100"].CGColor, (__bridge id)[UtilsMacro colorWithHexString:@"FF8B00"].CGColor]];
    [gradinentLayer setLocations:@[@0.0, @1.0]];
    [gradinentLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradinentLayer setEndPoint:CGPointMake(1.0, 0.0)];
    [gradinentLayer setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH - 20.0, self.mainView.frame.size.height)];
    [self.mainView.layer addSublayer:gradinentLayer];
    
    [UtilsMacro addCornerRadiusForView:self.withdrawBtn andRadius:self.withdrawBtn.frame.size.height/2.0 andCornes:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    
    [self.mainView bringSubviewToFront:self.firstView];
    [self.mainView bringSubviewToFront:self.secondView];
    
}

#pragma mark - Button Method

- (IBAction)handleTapWithdrawBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(balanceHeaderViewHandleTapWithDrawBtnAction)]) {
        [self.delegate balanceHeaderViewHandleTapWithDrawBtnAction];
    }
}

@end
