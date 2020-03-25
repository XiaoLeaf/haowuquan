//
//  ZXDetailCell_3.m
//  pzhixin
//
//  Created by zhixin on 2019/9/5.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDetailCell_3.h"
#import <Masonry/Masonry.h>

@implementation ZXDetailCell_3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createImgView];
    }
    return self;
}

- (void)createImgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
        }];
    }
}

- (void)setImgUrl:(NSString *)imgUrl {
    _imgUrl = imgUrl;
//    NSLog(@"_imgUrl:%@",_imgUrl);
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_imgUrl] imageView:_imgView placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

@end
