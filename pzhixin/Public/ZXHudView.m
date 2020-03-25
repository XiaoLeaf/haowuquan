//
//  ZXHudView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/6.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHudView.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Masonry/Masonry.h>

@implementation ZXHudView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGSize)intrinsicContentSize {
    return CGSizeMake(80.0, 80.0);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:4.0];
        [self.layer setMasksToBounds:YES];
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        UIImage *gifImg = [UIImage sd_imageWithGIFData:gifData];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:nil];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] loading]] placeholderImage:gifImg];
        [imgView setFrame:self.bounds];
        [self addSubview:imgView];
    }
    return self;
}

@end
