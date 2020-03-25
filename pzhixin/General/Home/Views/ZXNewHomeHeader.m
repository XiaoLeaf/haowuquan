//
//  ZXNewHomeHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewHomeHeader.h"

@implementation ZXNewHomeHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:BG_COLOR];
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTitleImgAction)];
    [self.titleImg addGestureRecognizer:tapImg];
}

#pragma mark - Private Methods

- (void)handleTapTitleImgAction {
    if (self.zxNewHomeHeaderImgClick) {
        self.zxNewHomeHeaderImgClick();
    }
}

@end
