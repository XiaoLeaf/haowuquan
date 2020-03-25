//
//  ZXFeedbackPickCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/10.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFeedbackPickCell.h"

@implementation ZXFeedbackPickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setBorderWidth:0.5];
    [self.layer setBorderColor:[UtilsMacro colorWithHexString:@"EEEEEE"].CGColor];
}

@end
