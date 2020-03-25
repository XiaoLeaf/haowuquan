//
//  ZXProgressHUD.m
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXProgressHUD.h"
#import <SDWebImage/UIImage+GIF.h>
#import "ZXHudView.h"
#import <Masonry/Masonry.h>
#import "ZXNewHudView.h"

#define DELAY_TIME 1.5

static ZXProgressHUD *progressHud = nil;
static UIView *backgroundView = nil;

@interface ZXProgressHUD ()

@end

@implementation ZXProgressHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)loading {
    [self configLoadingWithView:nil];
}

+ (void)loadingForView:(UIView *)view {
    [self configLoadingWithView:view];
}

+ (void)loadingNoMask {
    ZXNewHudView *newHudView = [[ZXNewHudView alloc] init];
//    [newHudView setBackgroundColor:[UIColor whiteColor]];
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    [view addSubview:newHudView];
    [newHudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80.0);
        make.center.mas_equalTo(view);
    }];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:newHudView endRemove:NO];
}

+ (void)hideNoMaskHud {
    NSArray *hudList = [[NSArray alloc] initWithArray:[self newHudView]];
    if ([hudList count] <= 0) {
        return;
    }
    for (int i = 0 ; i < [hudList count] - 1; i++) {
        ZXNewHudView *subView = [hudList objectAtIndex:i];
        [subView removeFromSuperview];
    }
    __block ZXNewHudView *newHudView = [hudList lastObject];
    if (newHudView) {
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:newHudView endRemove:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [newHudView removeFromSuperview];
            newHudView = nil;
        });
    }
}

+ (NSArray *)newHudView {
    NSMutableArray *hudList = [[NSMutableArray alloc] init];
    NSEnumerator *subviewsEnum = [[[UIApplication sharedApplication] keyWindow].subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[ZXNewHudView class]]) {
            ZXNewHudView *newHudView = (ZXNewHudView *)subview;
            [hudList addObject:newHudView];
            return hudList;
        }
    }
    return @[];
}

+ (void)configLoadingWithView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    ZXNewHudView *newHudView = [[ZXNewHudView alloc] init];
    [view addSubview:newHudView];
    [newHudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80.0);
        make.center.mas_equalTo(view);
    }];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:newHudView endRemove:NO];
}

+ (void)loadSucceedWithMaskMsg:(NSString *)msg {
    [self hideAllHUD];
    if ([UtilsMacro whetherIsEmptyWithObject:msg]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        UIView *view = [[UIApplication sharedApplication] keyWindow];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [progressHud setMode:MBProgressHUDModeText];
        [progressHud.backgroundView setHidden:YES];
        progressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        [progressHud.bezelView setColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [progressHud setRemoveFromSuperViewOnHide:YES];
        [progressHud setMargin:10.0];
        [progressHud.label setText:msg];
        [progressHud.label setNumberOfLines:0];
        [progressHud.label setFont:[UIFont systemFontOfSize:13.0]];
        [progressHud.label setTextColor:[UIColor whiteColor]];
        [progressHud hideAnimated:YES afterDelay:DELAY_TIME];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hideAllHUD];
//        });
    });
}

+ (void)loadFailedWithMaskMsg:(NSString *)msg {
    [self hideAllHUD];
    if ([UtilsMacro whetherIsEmptyWithObject:msg]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        UIView *view = [[UIApplication sharedApplication] keyWindow];
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [progressHud setMode:MBProgressHUDModeText];
        [progressHud.backgroundView setHidden:YES];
        progressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        [progressHud.bezelView setColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [progressHud setRemoveFromSuperViewOnHide:YES];
        [progressHud setMargin:10.0];
        [progressHud.label setText:msg];
        [progressHud.label setNumberOfLines:0];
        [progressHud.label setFont:[UIFont systemFontOfSize:13.0]];
        [progressHud.label setTextColor:[UIColor whiteColor]];
        [progressHud hideAnimated:YES afterDelay:DELAY_TIME];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hideAllHUD];
//        });
    });
}

+ (void)loadSucceedWithMsg:(NSString *)msg {
    [self hideAllHUD];
    if ([UtilsMacro whetherIsEmptyWithObject:msg]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithDelay:DELAY_TIME];
        [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setFont:[UIFont systemFontOfSize:13.0]];
        [SVProgressHUD setCornerRadius:5.0];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
    });
}

+ (void)loadFailedWithMsg:(NSString *)msg {
    [self hideAllHUD];
    if ([UtilsMacro whetherIsEmptyWithObject:msg]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithDelay:DELAY_TIME];
        [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setFont:[UIFont systemFontOfSize:13.0]];
        [SVProgressHUD setCornerRadius:5.0];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:msg];
    });
}

+ (void)hideAllHUD {
    [self configHideHUDWithView:nil];
    [self hideNoMaskHud];
}

+ (void)hideHUDForView:(UIView *)view {
    [self configHideHUDWithView:view];
}

+ (void)configHideHUDWithView:(UIView *)view {
    NSMutableArray *hudList = [[NSMutableArray alloc] init];
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[ZXNewHudView class]]) {
            ZXNewHudView *newHudView = (ZXNewHudView *)subview;
            [hudList addObject:newHudView];
        }
    }
    if ([hudList count] <= 0) {
        return;
    }
    for (int i = 0 ; i < [hudList count] - 1; i++) {
        ZXNewHudView *subView = [hudList objectAtIndex:i];
        [subView removeFromSuperview];
    }
    __block ZXNewHudView *newHudView = [hudList lastObject];
    if (newHudView) {
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:newHudView endRemove:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [newHudView removeFromSuperview];
            newHudView = nil;
        });
    }
    [SVProgressHUD dismiss];
}

@end
