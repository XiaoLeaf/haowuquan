//
//  ZXAddressPickCell.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressPickCell.h"

@implementation ZXAddressPickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setPcasJson:(ZXPcasJson *)pcasJson {
    _pcasJson = pcasJson;
    [_nameLab setText:_pcasJson.n];
}

@end
