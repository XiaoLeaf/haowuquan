//
//  ZXSearchCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/4.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchCell.h"

@implementation ZXSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setCornerRadius:13.0];
    [self setClipsToBounds:YES];
}

@end
