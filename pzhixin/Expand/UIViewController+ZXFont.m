//
//  UIViewController+ZXFont.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "UIViewController+ZXFont.h"

@implementation UIViewController (ZXFont)

- (CGFloat)autoScaleWidth:(CGFloat)width {
    return width * (SCREENWIDTH / 375.0);
}

@end
