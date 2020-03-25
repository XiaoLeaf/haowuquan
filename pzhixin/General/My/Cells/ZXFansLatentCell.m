//
//  ZXFansLatentCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansLatentCell.h"

@implementation ZXFansLatentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.userImg.layer setCornerRadius:self.userImg.frame.size.height/2.0];
    [self.wakeBtn.layer setCornerRadius:self.wakeBtn.frame.size.height/2.0];
    [self.wakeBtn.layer setBorderWidth:1.0];
    [self.wakeBtn.layer setBorderColor:THEME_COLOR.CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Button Method

- (IBAction)handleTapWakeBtnAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansLatentCellHandleTapWakeBtnActionWithTag:)]) {
        [self.delegate fansLatentCellHandleTapWakeBtnActionWithTag:button.tag];
    }
}

@end
