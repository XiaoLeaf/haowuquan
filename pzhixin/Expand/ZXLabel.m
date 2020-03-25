//
//  ZXLabel.m
//  pzhixin
//
//  Created by zhixin on 2019/9/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXLabel.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@implementation ZXLabel

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
        [self attachLongTapHandle];
    }
    return self;
}

- (void)attachLongTapHandle {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        // 防止长按之后连续触发该事件
        if (sender.state == UIGestureRecognizerStateBegan) {
            // UILabel成为第一响应者
            [self becomeFirstResponder];
            UIMenuController *menuVC = [UIMenuController sharedMenuController];
            UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
            [menuVC setMenuItems:@[copyMenuItem]];
            [menuVC setTargetRect:self.frame inView:self.superview];
            [menuVC setMenuVisible:YES animated:YES];
        }
    }];
    [self addGestureRecognizer:longPress];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
//    if (action == @selector(paste:)) {
//        return YES;
//    }
//    if (action == @selector(delete:)) {
//        return YES;
//    }
//    if (action == @selector(selectAll:)) {
//        return YES;
//    }
//    if (action == @selector(cut:)) {
//        return YES;
//    }
    return NO;
}

- (void)copyAction:(id)sender {
    [UtilsMacro generalPasteboardCopy:self.goodsTitle];
}

- (void)paste:(id)sender {
//    NSLog(@"paste");
}

- (void)delete:(id)sender {
//    NSLog(@"delete");
}

- (void)selectAll:(id)sender {
//    NSLog(@"selectAll");
}

- (void)cut:(id)sender {
//    NSLog(@"cut");
}

@end
