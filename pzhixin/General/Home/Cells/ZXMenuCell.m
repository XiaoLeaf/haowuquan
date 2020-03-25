//
//  ZXMenuCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMenuCell.h"

@implementation ZXMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setHomeBtn:(ZXHomeSlides *)homeBtn {
    _homeBtn = homeBtn;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_homeBtn.img] imageView:_menuImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    [_menuLab setText:_homeBtn.name];
}

@end
