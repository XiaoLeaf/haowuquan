//
//  ZXSecurityCodeViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSecurityCodeViewController.h"
#import "UtilsMacro.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <Masonry/Masonry.h>
#import "ZXInviteCodeViewController.h"

@interface ZXSecurityCodeViewController () {
    CRBoxInputView *boxInputView;
    NSInteger second;
    NSTimer *timer;
}

@end

@implementation ZXSecurityCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startTimer];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    [cellProperty setShowLine:YES];
    [cellProperty setCellCursorColor:[UtilsMacro colorWithHexString:@"BFBFBF"]];
    [cellProperty setBorderWidth:0.0];
    [cellProperty setCustomLineViewBlock:^CRLineView * _Nonnull{
        CRLineView *lineView = [CRLineView new];
        [lineView setUnderlineColorNormal:[UtilsMacro colorWithHexString:@"BFBFBF"]];
        [lineView setUnderlineColorSelected:[UtilsMacro colorWithHexString:@"BFBFBF"]];
        [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1.0);
            make.left.right.bottom.offset(0);
        }];
        return lineView;
    }];
    boxInputView = [[CRBoxInputView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.codeView.frame.size.width, self.codeView.frame.size.height)];
    [boxInputView setIfNeedCursor:YES];
    [boxInputView setCustomCellProperty:cellProperty];
    [boxInputView setCodeLength:4];
    [boxInputView setKeyBoardType:UIKeyboardTypeNumberPad];
    [boxInputView loadAndPrepareView];
//    [boxInputView loadAndPrepareViewWithBeginEdit:YES];
    [self.codeView addSubview:boxInputView];
    
    
    __weak __typeof__(self) weakSelf = self;
    [boxInputView setTextDidChangeblock:^(NSString * _Nullable text, BOOL isFinished) {
        if (isFinished) {
            if ([UtilsMacro isCanReachableNetWork]) {
                [ZXProgressHUD loadingNoMask];
                [[ZXPhoneBindLoginHelper sharedInstance] fetchBindOrLoginWithTel:weakSelf.phone andCode:text andUnionid:weakSelf.unionid andUser_id:weakSelf.user_id andType:[NSString stringWithFormat:@"%ld",(long)weakSelf.type] andPush_id:[[ZXAppConfigHelper sharedInstance] registrationID] completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                    
                    //添加判断，info信息中是否有authorization || authorization是否为空。若为空，即判定为登录失败！！！
                    if (![[response.data allKeys] containsObject:@"authorization"] || [UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"authorization"]]) {
                        [ZXProgressHUD loadFailedWithMsg:@"登录失败"];
                        return;
                    }
                    [[ZXLoginHelper sharedInstance] setLoginState:YES];
                    [[ZXLoginHelper sharedInstance] setAuthorization:[response.data valueForKey:@"authorization"]];
                    ZXUser *user = [ZXUser yy_modelWithDictionary:response.data];
                    [[ZXMyHelper sharedInstance] setUserInfo:user];
                    if ([[ZXDatabaseUtil sharedDataBase] userExistWithName:user.nickname]) {
                        [[ZXDatabaseUtil sharedDataBase] updateUserWithUser:user];
                    } else {
                        [[ZXDatabaseUtil sharedDataBase] insertUser:user];
                    }
                    if ([[[[ZXMyHelper sharedInstance] userInfo] bind_tb] integerValue] == 1) {
                        [[ZXTBAuthHelper sharedInstance] setTBAuthState:YES];
                    } else {
                        [[ZXTBAuthHelper sharedInstance] setTBAuthState:NO];
                    }
                    [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:weakSelf.tabIndex];
                    if ([[[[ZXMyHelper sharedInstance] userInfo] is_bind] integerValue] == 2) {
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, INVITE_CODE_VC] andUserInfo:@2 viewController:weakSelf];
                    } else {
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
    }];
    
}

- (void)viewWillAppear:(BOOL)animate {
    [super viewWillAppear:animate];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)dealloc {
    [timer invalidate];
    timer = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)startTimer {
    NSString *phoneStr = [self.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [self.tipLabel setText:[NSString stringWithFormat:@"4位验证码已发送至：%@",phoneStr]];
    second = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeTimerCount) userInfo:nil repeats:YES];
}

- (void)securityCodeTimerCount {
    second --;
    NSString *str = [NSString stringWithFormat:@"重新发送(%lds)", (long)second];
    if (second > 0) {
        [self.sendBtn setUserInteractionEnabled:NO];
        [self.sendBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [self.sendBtn setTitle:str forState:UIControlStateNormal];
        [self.sendBtn.titleLabel setText:str];
    } else {
        [self.sendBtn setUserInteractionEnabled:YES];
        [self.sendBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.sendBtn.titleLabel setText:@"重新发送"];
    }
}

#pragma mark - Button Action

- (IBAction)handleTapSendBtnAction:(id)sender {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [self startTimer];
        [[ZXCodeHelper sharedInstance] fetchCodeWithType:[NSString stringWithFormat:@"%ld",(long)self.type] andTel:self.phone andUser_id:nil andUniondid:nil completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

@end
