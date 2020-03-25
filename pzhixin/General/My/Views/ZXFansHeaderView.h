//
//  ZXFansHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFansHeaderViewDelegate;

@interface ZXFansHeaderView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *sortView;

@property (strong, nonatomic) UIButton *lastBtn;

@property (strong, nonatomic) UIButton *fansBtn;

@property (weak, nonatomic) id<ZXFansHeaderViewDelegate>delegate;

@end

@protocol ZXFansHeaderViewDelegate <NSObject>

- (void)fansHeaderViewHandleTapBtnActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
