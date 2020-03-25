//
//  ZXFansTabView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFansTabViewDelegate;

@interface ZXFansTabView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *bgImgView;

@property (strong, nonatomic) UICountingLabel *countLab;

@property (strong, nonatomic) UIView *tipView;

@property (strong, nonatomic) UIButton *problemBtn;

@property (strong, nonatomic) UIView *inviteView;

@property (strong, nonatomic) UILabel *inviteLab;

@property (strong, nonatomic) UILabel *wxLab;

@property (strong, nonatomic) UIButton *cpBtn;

@property (strong, nonatomic) UIView *fetchInviteView;

@property (strong, nonatomic) UIButton *fetchBtn;

@property (weak, nonatomic) id<ZXFansTabViewDelegate>delegate;

@end

@protocol ZXFansTabViewDelegate <NSObject>

- (void)fansTabViewHandleTapButtonActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
