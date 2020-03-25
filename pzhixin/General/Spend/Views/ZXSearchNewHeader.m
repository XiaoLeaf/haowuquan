//
//  ZXSearchNewHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/11/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchNewHeader.h"

@interface ZXSearchNewHeader ()

@end

@implementation ZXSearchNewHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codes
    [_headerImg.layer setCornerRadius:8.0];
    
    UITapGestureRecognizer *tapHeaderImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderImgAction)];
    [_headerImg addGestureRecognizer:tapHeaderImg];
}

#pragma mark

- (void)handleTapHeaderImgAction {
    if (self.zxSearchNewHeaderImgClick) {
        self.zxSearchNewHeaderImgClick();
    }
}

@end
