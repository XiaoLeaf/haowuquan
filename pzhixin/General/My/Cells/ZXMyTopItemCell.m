//
//  ZXMyTopItemCell.m
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyTopItemCell.h"

@implementation ZXMyTopItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Setter

- (void)setUserBtn:(ZXUserBtn *)userBtn {
    _userBtn = userBtn;
    [_coutLab setText:userBtn.val];
    [_nameLab setText:userBtn.name];
}

@end
