//
//  UIView+ZXFont.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "UIView+ZXFont.h"

@implementation UIView (ZXFont)

- (CGFloat)autoScaleWidth:(CGFloat)width {
    return width * (SCREENWIDTH / 375.0);
}

@end
