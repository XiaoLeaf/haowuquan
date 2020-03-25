//
//  ZXRechargeHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRechargeHeaderView.h"

@implementation ZXRechargeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Button Method

- (IBAction)handleTapContactBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rechargeHeaderViewHandleTapContactBtnAction)]) {
        [self.delegate rechargeHeaderViewHandleTapContactBtnAction];
    }
}

@end
