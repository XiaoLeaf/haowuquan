//
//  ZXFavoritePickHeaderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavoritePickHeaderView.h"

@implementation ZXFavoritePickHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.pickBtn.layer setCornerRadius:self.pickBtn.frame.size.height/2.0];
    [self.pickBtn.layer setBorderWidth:1.0];
    [self.pickBtn.layer setBorderColor:[UtilsMacro colorWithHexString:@"DEDEDE"].CGColor];
}

#pragma mark - Button Method

- (IBAction)handleTapPickBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(favoritePickHeaderViewHandleTapPickBtnActionWithTag:)]) {
        [self.delegate favoritePickHeaderViewHandleTapPickBtnActionWithTag:btn.tag];
    }
}

@end
