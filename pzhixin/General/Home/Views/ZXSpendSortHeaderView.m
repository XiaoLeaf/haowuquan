//
//  ZXSpendSortHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSpendSortHeaderView.h"

#define DISTANCE 10.0

@implementation ZXSpendSortHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.26 * SCREENWIDTH / 5.0)];
    self.synBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.synBtn.imageView.frame.size.width - DISTANCE/2.0, 0, self.synBtn.imageView.frame.size.width);
    self.synBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.synBtn.titleLabel.frame.size.width, 0, -self.synBtn.titleLabel.frame.size.width - DISTANCE/2.0);
    
    self.priceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.priceBtn.imageView.frame.size.width - DISTANCE/2.0, 0, self.priceBtn.imageView.frame.size.width);
    self.priceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.priceBtn.titleLabel.frame.size.width, 0, -self.priceBtn.titleLabel.frame.size.width - DISTANCE/2.0);
    
    self.countBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.countBtn.imageView.frame.size.width - DISTANCE/2.0, 0, self.countBtn.imageView.frame.size.width);
    self.countBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.countBtn.titleLabel.frame.size.width, 0, -self.countBtn.titleLabel.frame.size.width - DISTANCE/2.0);
}

#pragma mark - Button Method

- (IBAction)handleTapRankBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.spendSortHeaderBtnClick) {
        self.spendSortHeaderBtnClick(btn);
    }
}

@end
