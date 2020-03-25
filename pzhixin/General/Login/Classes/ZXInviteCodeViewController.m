//
//  ZXInviteCodeViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXInviteCodeViewController.h"

@interface ZXInviteCodeViewController ()

@property (strong, nonatomic) ZXInviteView *inviteView;

//1-确认绑定  2-查询邀请人信息
@property (strong, nonatomic) NSString *step;

@end

@implementation ZXInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _step = @"2";
    // Do any additional setup after loading the view from its nib.
    
    [self.codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([x length] > 11) {
            [self.codeTextField setText:[x substringToIndex:11]];
        }
        if ([self.codeTextField.text length] == 6 || [self.codeTextField.text length] == 11) {
            [self.bindBtn setBackgroundColor:THEME_COLOR];
        } else {
            [self.bindBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.codeTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.codeTextField resignFirstResponder];
    [ZXProgressHUD hideAllHUD];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backButtonPressed:(id)sender {
    if (self.fromType == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_LOGIN" object:nil userInfo:nil];
    }
}

#pragma mark - Button Method

- (IBAction)handleTapBindBtnAction:(id)sender {
    [self.codeTextField resignFirstResponder];
    if ([UtilsMacro whetherIsEmptyWithObject:self.codeTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入邀请码/手机号码"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXAuthBindHelper sharedInstance] fetchAuthBindWithRef:self.codeTextField.text andStep:@"2" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            if (response.status == 201) {
                __weak typeof(self) weakSelf = self;
                [self.codeTextField resignFirstResponder];
                self.inviteView = [[ZXInviteView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                self.inviteView.zxInviteViewBtnClick = ^(NSInteger btnTag) {
                    [weakSelf.inviteView setBackgroundColor:[UIColor clearColor]];
                    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.inviteView.containerView endRemove:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.inviteView removeFromSuperview];
                        weakSelf.inviteView = nil;
                    });
                    switch (btnTag) {
                        case 0:
                        {
                            if ([UtilsMacro isCanReachableNetWork]) {
                                [ZXProgressHUD loadingNoMask];
                                [[ZXAuthBindHelper sharedInstance] fetchAuthBindWithRef:weakSelf.codeTextField.text andStep:@"1" completion:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                                    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                                    [userInfo setIs_bind:@"1"];
                                    [userInfo setIcode:[response.data valueForKey:@"icode"]];
                                    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                                    if (self.fromType == 1) {
                                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                    } else {
                                        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:weakSelf.tabIndex];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_LOGIN" object:nil userInfo:nil];
                                    }
                                } error:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadFailedWithMsg:response.info];
                                    return;
                                }];
                            } else {
                                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                                return;
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                };
                [self.inviteView setUserInfo:response.data];
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.inviteView];
                [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:self.inviteView.containerView endRemove:NO];
                return;
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (IBAction)handleSkipBtnAction:(id)sender {
    if (self.fromType == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_LOGIN" object:nil userInfo:nil];
    }
}

@end
