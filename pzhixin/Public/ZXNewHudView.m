//
//  ZXNewHudView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/15.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewHudView.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Masonry/Masonry.h>

@interface ZXNewHudView ()

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UIImage *gifImg;

@end

@implementation ZXNewHudView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
        [self.layer setCornerRadius:4.0];
        [self.layer setMasksToBounds:YES];
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        _gifImg = [UIImage sd_imageWithGIFData:gifData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:nil];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading]] placeholderImage:_gifImg];
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
}

@end
