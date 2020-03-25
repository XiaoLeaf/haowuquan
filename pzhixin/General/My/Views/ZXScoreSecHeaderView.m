//
//  ZXScoreSecHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreSecHeaderView.h"

@implementation ZXScoreSecHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect goodsRect = CGRectMake(0.0, 0.0, SCREENWIDTH - 32.0, self.mainView.frame.size.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:goodsRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = goodsRect;
    maskLayer.path = maskPath.CGPath;
    self.mainView.layer.mask = maskLayer;
    [self.tipView.layer setCornerRadius:self.tipView.frame.size.width/2.0];
}

@end
