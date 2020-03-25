//
//  ZXPhoneLoginViewViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXPhoneLoginViewViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;
- (IBAction)handleTapFetchBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *wxView;
@property (weak, nonatomic) IBOutlet UIImageView *wxImgView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *dealView;


/*
 1:手机号登录
 2:绑定手机号码
 */
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *user_id;

@property (strong, nonatomic) NSString *unionid;

@property (assign, nonatomic) NSInteger tabIndex;

@end

NS_ASSUME_NONNULL_END
