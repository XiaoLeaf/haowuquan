//
//  ZXVerifyViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXVerifyViewController.h"
#import "ZXMyEditViewController.h"

@interface ZXVerifyViewController () <UITextFieldDelegate> {
    NSTimer *timer;
    NSInteger second;
}

@end

@implementation ZXVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.submitButton.layer setCornerRadius:2.0];
    [self.codeButton.layer setCornerRadius:2.0];
    [self setTitle:@"验证身份" font:[UIFont systemFontOfSize:18.0] color:HOME_TITLE_COLOR];
    [self.codeTextFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([x length] > 4) {
            self.codeTextFiled.text = [x substringToIndex:4];
        }
        if (self.codeTextFiled.text.length != 4) {
            [self.submitButton setBackgroundColor:DEDEDE_COLOR];
            [self.submitButton setTintColor:DEDEDE_COLOR];
        } else {
            [self.submitButton setBackgroundColor:THEME_COLOR];
            [self.submitButton setTintColor:THEME_COLOR];
        }
    }];
    [self.tipLabel setText:[NSString stringWithFormat:@"为了您的账户安全，需要验证您的身份。验证码将发送至尾号%@的手机，请注意查收。",[[[[ZXMyHelper sharedInstance] userInfo] tel] substringFromIndex:7]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zxVerifyVCDismiss) name:@"DISMISS_VERIFY" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
}

#pragma mark - NSNotificationCenter

- (void)zxVerifyVCDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - Button Methods

- (IBAction)handleTapAtCodeButtonAction:(id)sender {
    if ([UtilsMacro isCanReachableNetWork]) {
        second = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verifyViewControllerTimerCount) userInfo:nil repeats:YES];
        [ZXProgressHUD loadingNoMask];
        [[ZXCodeHelper sharedInstance] fetchCodeWithType:[NSString stringWithFormat:@"%ld",(long)self.codeType] andTel:[[[ZXMyHelper sharedInstance] userInfo] tel] andUser_id:nil andUniondid:nil completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
        } error:^(ZXResponse * _Nonnull response) {
            [self->timer invalidate];
            self->timer = nil;
            [self.codeButton setUserInteractionEnabled:YES];
            [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.codeButton.titleLabel setText:@"获取验证码"];
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)verifyViewControllerTimerCount {
    second --;
    NSString *str = [NSString stringWithFormat:@"%ds后重发",(int)second];
    if (second > 0) {
        [self.codeButton setUserInteractionEnabled:NO];
        [self.codeButton setTitle:str forState:UIControlStateNormal];
        [self.codeButton.titleLabel setText:str];
    } else {
        [self.codeButton setUserInteractionEnabled:YES];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeButton.titleLabel setText:@"获取验证码"];
    }
}

- (IBAction)handleTapAtSubmitButtonAction:(id)sender {
    if ([[self.codeTextFiled text] length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入验证码"];
        return;
    }
    if ([[self.codeTextFiled text] length] != 4) {
        [ZXProgressHUD loadFailedWithMsg:@"验证码长度有误"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        if (self.type == 1) {
            [[ZXModifyTelHelper sharedInstance] fetchModifyTelWithStep:@"1" andCode:self.codeTextFiled.text andTel:nil andCodeNew:nil completion:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadSucceedWithMsg:response.info];
                ZXMyEditViewController *myEdit = [[ZXMyEditViewController alloc] init];
                [myEdit setType:7];
                [myEdit setOldCode:self.codeTextFiled.text];
                [myEdit setTitleStr:@"更换手机号"];
                [self.navigationController pushViewController:myEdit animated:YES];
            } error:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
                return;
            }];
        } else if (self.type == 2) {
            [[ZXModifyPPwdHelper sharedInstance] fetchModifyPPwdWithStep:@"1" andVal:nil andCode:self.codeTextFiled.text completion:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadSucceedWithMsg:response.info];
                ZXMyEditViewController *myEdit = [[ZXMyEditViewController alloc] init];
                [myEdit setType:5];
                [myEdit setOldCode:self.codeTextFiled.text];
                [myEdit setTitleStr:@"设置支付密码"];
                [self.navigationController pushViewController:myEdit animated:YES];
            } error:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
                return;
            }];
        } else if (self.type == 3) {
            [[ZXUnBindWxHelper sharedInstance] fetchUnBindWXWithCode:self.codeTextFiled.text completion:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadSucceedWithMsg:response.info];
                ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                [userInfo setBind_wx:@"0"];
                [userInfo setWxtmp:[[ZXWXTmp alloc] init]];
                [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                [self dismissViewControllerAnimated:YES completion:nil];
            } error:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
                return;
            }];
        }
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)dealloc {
    [timer invalidate];
    timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DISMISS_VERIFY" object:nil];
}

@end
