//
//  ZXPersonalCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPersonalCell.h"

@implementation ZXPersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImage.layer setCornerRadius:self.headImage.frame.size.width/2.0];
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeadImgAction)];
    [self.headImage addGestureRecognizer:tapHead];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapHeadImgAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personalCellHandleTapHeadImgAction)]) {
        [self.delegate personalCellHandleTapHeadImgAction];
    }
}

@end
