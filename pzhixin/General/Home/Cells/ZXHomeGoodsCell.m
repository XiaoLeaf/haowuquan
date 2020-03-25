//
//  ZXHomeGoodsCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeGoodsCell.h"

@implementation ZXHomeGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setCornerRadius:5.0];
    [self setClipsToBounds:YES];
    
    NSString *orinalStr = @"￥240";
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:orinalStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, orinalStr.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UtilsMacro colorWithHexString:@"B1B1B1"] range:NSMakeRange(0, orinalStr.length)];
    [self.originalLabel setAttributedText:attri];
}

@end
