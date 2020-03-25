//
//  ZXSearchHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/7/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchHeaderView.h"

@implementation ZXSearchHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Button Method

- (IBAction)handleTapDeleteBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHeaderViewHandleTapDeleteBtn)]) {
        [self.delegate searchHeaderViewHandleTapDeleteBtn];
    }
}

- (IBAction)handleTapReplaceBtnAction:(id)sender {
    if (self.zxSearchHeaderViewReplaceClick) {
        self.zxSearchHeaderViewReplaceClick();
    }
}

@end
