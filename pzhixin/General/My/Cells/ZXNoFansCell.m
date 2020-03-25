//
//  ZXNoFansCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNoFansCell.h"

@implementation ZXNoFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.inviteBtn.layer setCornerRadius:2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Button Method

- (IBAction)handleTapInviteBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noFansCellHandleTapInviteBtnAction)]) {
        [self.delegate noFansCellHandleTapInviteBtnAction];
    }
}

@end
