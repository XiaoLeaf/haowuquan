//
//  ZXInviteVC.h
//  pzhixin
//
//  Created by zhixin on 2019/9/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXInviteVC : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
- (IBAction)handleTapBottomBtnActions:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

NS_ASSUME_NONNULL_END
