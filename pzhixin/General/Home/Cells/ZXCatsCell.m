//
//  ZXCatsCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCatsCell.h"

@interface ZXCatsCell ()

@end

@implementation ZXCatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setClassify:(ZXClassify *)classify {
    _classify = classify;
    if (![UtilsMacro whetherIsEmptyWithObject:_classify.icon]) {
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_classify.icon] imageView:self.catsImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
    [self.catsName setText:_classify.name];
}

@end
