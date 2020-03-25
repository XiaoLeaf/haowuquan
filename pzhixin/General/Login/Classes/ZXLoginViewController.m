//
//  ZXLoginViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXLoginViewController.h"
#import "ZXPhoneLoginViewViewController.h"
#import <YYText/YYText.h>
#import "AppDelegate.h"
#import "ZXInviteCodeViewController.h"
#import <Masonry/Masonry.h>

@interface ZXLoginViewController () <ZXWeChatUtilsDelegate> {
}

@property (strong, nonatomic) YYLabel *dealLabel;

@end

@implementation ZXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] login_banner]] imageView:_logoImg placeholderImage:nil options:0 progress:nil completed:nil];
    [self.unableBtn setTitle:![UtilsMacro whetherIsEmptyWithObject:[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] unable_login].txt] ? [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] unable_login].txt : @"" forState:UIControlStateNormal];
    [self setHiddenBackButton:YES];
    // Do any additional setup after loading the view from its nib.
    [self setRightBtnImage:[UIImage imageNamed:@"login_close"] target:self action:@selector(handleTapAtRightBtnAction)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:@"DISMISS_LOGIN" object:nil];
    
    [self createDealLabel];
    
    if (![WXApi isWXAppInstalled]) {
        [self.wxBtn setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - NSNotificationCenter

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)handleTapAtRightBtnAction {
    if ([[ZXLoginHelper sharedInstance] loginState]) {
        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:self.tabIndex];
    } else {
        if (self.tabIndex) {
            [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:self.tabIndex];
        } else {
            [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:0];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createDealLabel {
    _dealLabel = [[YYLabel alloc] init];
    [self.dealView addSubview:_dealLabel];
    [_dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0.0);
    }];
    
    NSString *dealStr = [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].txt;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:dealStr];
    
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0] range:NSMakeRange(0, dealStr.length)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UtilsMacro colorWithHexString:@"4B729D"] range:NSMakeRange(0, dealStr.length)];
    
    [attri yy_setTextHighlightRange:NSMakeRange(0, dealStr.length) color:[UtilsMacro colorWithHexString:@"4B729D"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].url_schema] andUserInfo:nil viewController:self];
    }];
    [_dealLabel setAttributedText:attri];
    _dealLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Button Actions

//微信登录
- (IBAction)handleTapWxBtnAction:(id)sender {
//    [ZXProgressHUD loadingNoMask];
    [[ZXWeChatUtils sharedInstance] sendAuthLoginReuqestWithController:self delegate:self];
}

//手机登录
- (IBAction)handleTapPhoneBtnAction:(id)sender {
    ZXPhoneLoginViewViewController *phoneLogin = [[ZXPhoneLoginViewViewController alloc] init];
    [phoneLogin setType:1];
    [phoneLogin setTabIndex:_tabIndex];
    [self.navigationController pushViewController:phoneLogin animated:YES];
}

//无法登录
- (IBAction)handleTapUnableBtnAction:(id)sender {
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] unable_login].url_schema] andUserInfo:nil viewController:self];
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatAuthLoginSucceedWithCode:(NSString *)authCode {
    [ZXProgressHUD loadingNoMask];
    [[ZXLoginHelper sharedInstance] fetchLoginWithCode:authCode andPush_id:[[ZXAppConfigHelper sharedInstance] registrationID] completion:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD loadSucceedWithMsg:response.info];
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

        [[[AppDelegate sharedInstance] homeTabBarController] setSelectedIndex:self.tabIndex];
        
        if ([[[[ZXMyHelper sharedInstance] userInfo] is_bind] integerValue] == 2) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, INVITE_CODE_VC] andUserInfo:@2 viewController:self];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } error:^(ZXResponse * _Nonnull response) {
        if (response.status == 201) {
            [ZXProgressHUD hideAllHUD];
            ZXPhoneLoginViewViewController *phoneLogin = [[ZXPhoneLoginViewViewController alloc] init];
            [phoneLogin setType:2];
            [phoneLogin setUser_id:[response.data valueForKey:@"id"]];
            [phoneLogin setUnionid:[response.data valueForKey:@"unionid"]];
            [phoneLogin setTabIndex:self.tabIndex];
            [self.navigationController pushViewController:phoneLogin animated:YES];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DISMISS_LOGIN" object:nil];
}

@end
