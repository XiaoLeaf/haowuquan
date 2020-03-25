//
//  ZXDoubleSkeleCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/27.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDoubleSkeleCell.h"

@interface ZXDoubleSkeleCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation ZXDoubleSkeleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
