//
//  ZXEditPayPwdView.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXEditPayPwdViewDelegate;

@interface ZXEditPayPwdView : UIView

@property (strong, nonatomic) UITextField *pwdTextField;

@property (strong, nonatomic) UITextField *confirmTextField;

@property (strong, nonatomic) UIButton *submitBtn;

@property (weak, nonatomic) id<ZXEditPayPwdViewDelegate>delegate;

@end

@protocol ZXEditPayPwdViewDelegate <NSObject>

- (void)editPayPwdViewHandleTapSubmitBtnAction;

@end

NS_ASSUME_NONNULL_END
