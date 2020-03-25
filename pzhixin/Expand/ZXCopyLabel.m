//
//  ZXCopyLabel.m
//  pzhixin
//
//  Created by zhixin on 2020/3/12.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXCopyLabel.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@implementation ZXCopyLabel

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
        [self attachTapHandle];
    }
    return self;
}

- (void)attachTapHandle {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self becomeFirstResponder];
        UIMenuController *menuVC = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
        [menuVC setMenuItems:@[copyMenuItem]];
        [menuVC setTargetRect:self.frame inView:self.superview];
        [menuVC setMenuVisible:YES animated:YES];
    }];
    [self addGestureRecognizer:tap];
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
    [UtilsMacro generalPasteboardCopy:self.text];
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
