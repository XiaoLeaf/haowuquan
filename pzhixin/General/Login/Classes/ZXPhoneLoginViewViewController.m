//
//  ZXPhoneLoginViewViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPhoneLoginViewViewController.h"
#import "UtilsMacro.h"
#import "ZXSecurityCodeViewController.h"
#import <YYText/YYText.h>
#import "ZXInviteCodeViewController.h"

@interface ZXPhoneLoginViewViewController () <ZXWeChatUtilsDelegate>

@end

@implementation ZXPhoneLoginViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![WXApi isWXAppInstalled]) {
        [self.thirdView setHidden:YES];
    }
    
    UITapGestureRecognizer *tapWxView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxLogin)];
    [self.wxView addGestureRecognizer:tapWxView];
    
    if (self.type == 2) {
        [self.thirdView setHidden:YES];
        [self.tipLabel setHidden:YES];
        [self.titleLabel setText:@"绑定手机号码"];
    }
    [self createDealLabel];
    
    [self.phoneTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([x length] > 11) {
            [self.phoneTextField setText:[x substringToIndex:11]];
        }
        if ([self.phoneTextField.text length] == 11) {
            [self.fetchBtn setBackgroundColor:THEME_COLOR];
        } else {
            [self.fetchBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.phoneTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.phoneTextField resignFirstResponder];
    [self.navigationController.navigationBar setTranslucent:NO];
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

- (void)createDealLabel {
    YYLabel *dealLabel = [[YYLabel alloc] init];
    [dealLabel setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, self.dealView.frame.size.height)];
    [self.dealView addSubview:dealLabel];
    
    NSString *dealStr = [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].txt;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:dealStr];
    
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0] range:NSMakeRange(0, dealStr.length)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UtilsMacro colorWithHexString:@"4B729D"] range:NSMakeRange(0, dealStr.length)];
    
    [attri yy_setTextHighlightRange:NSMakeRange(0, dealStr.length) color:[UtilsMacro colorWithHexString:@"4B729D"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].url_schema] andUserInfo:nil viewController:self];
    }];
    [dealLabel setAttributedText:attri];
    dealLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - UITapGestureRecognizer

//微信登录
- (void)wxLogin {
//    [ZXProgressHUD loadingNoMask];
    [[ZXWeChatUtils sharedInstance] sendAuthLoginReuqestWithController:self delegate:self];
}

#pragma mark - Button Methods

- (IBAction)handleTapFetchBtnAction:(id)sender {
    if ([[self.phoneTextField text] length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入手机号码"];
        return;
    }
    if ([[self.phoneTextField text] length] != 11) {
        [ZXProgressHUD loadFailedWithMsg:@"长度有误"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXCodeHelper sharedInstance] fetchCodeWithType:[NSString stringWithFormat:@"%ld",(long)self.type] andTel:self.phoneTextField.text andUser_id:self.user_id andUniondid:self.unionid completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            ZXSecurityCodeViewController *securityCode = [[ZXSecurityCodeViewController alloc] init];
            [securityCode setType:self.type];
            [securityCode setPhone:self.phoneTextField.text];
            [securityCode setTabIndex:self.tabIndex];
            if (self.type == 2) {
                [securityCode setUser_id:self.user_id];
                [securityCode setUnionid:self.unionid];
            }
            [self.navigationController pushViewController:securityCode animated:YES];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatAuthLoginSucceedWithCode:(NSString *)authCode {
    [ZXProgressHUD loadingNoMask];
    [[ZXLoginHelper sharedInstance] fetchLoginWithCode:authCode andPush_id:[[ZXAppConfigHelper sharedInstance] registrationID] completion:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD hideAllHUD];
        [[ZXLoginHelper sharedInstance] setLoginState:YES];
        NSString *authorization = [response.data valueForKey:@"authorization"];
        [[ZXLoginHelper sharedInstance] setAuthorization:authorization];
        
        //将authorization与用户数据一起存入数据库，留作本地用户切换
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
        if ([[[[ZXMyHelper sharedInstance] userInfo] is_bind] integerValue] == 2) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, INVITE_CODE_VC] andUserInfo:@2 viewController:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_LOGIN" object:nil userInfo:nil];
        }
    } error:^(ZXResponse * _Nonnull response) {
        if (response.status == 201) {
            [ZXProgressHUD hideAllHUD];
            [self setType:2];
            [self.thirdView setHidden:YES];
            [self.tipLabel setHidden:YES];
            [self.titleLabel setText:@"绑定手机号码"];
            return;
        }
        [ZXProgressHUD loadFailedWithMsg:response.info];
        return;
    }];
}

- (void)zxWeChatAuthLoginDenied {
    [ZXProgressHUD hideAllHUD];
    [ZXProgressHUD loadFailedWithMsg:@"您拒绝了授权"];
    return;
}

- (void)zxWeChatAuthLoginCancel {
    [ZXProgressHUD hideAllHUD];
    [ZXProgressHUD loadFailedWithMsg:@"您取消了授权"];
    return;
}

@end
