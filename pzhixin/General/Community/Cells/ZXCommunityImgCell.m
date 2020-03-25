//
//  ZXCommunityImgCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/5.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommunityImgCell.h"

@implementation ZXCommunityImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setClipsToBounds:YES];
    [self.imgView.layer setCornerRadius:2.0];
    [self.imgView.layer setMasksToBounds:YES];
}

@end
