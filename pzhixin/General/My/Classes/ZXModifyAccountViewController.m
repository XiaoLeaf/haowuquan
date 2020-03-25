//
//  ZXModifyAccountViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXModifyAccountViewController.h"

@interface ZXBindAccount : NSObject

@property (strong, nonatomic) NSString *alipay;

@property (strong, nonatomic) NSString *realname;

@property (strong, nonatomic) NSString *tel;

@end

@implementation ZXBindAccount

@end

@interface ZXModifyAccountViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger second;
@property (assign, nonatomic) BOOL nameAbled;
@property (assign, nonatomic) BOOL accountAbled;
@property (assign, nonatomic) BOOL codeAbled;

@property (strong, nonatomic) ZXBindAccount *bindAccount;

@end

@implementation ZXModifyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.type integerValue] == 1) {
        [self setTitle:@"修改账户" font:TITLE_FONT color:HOME_TITLE_COLOR];
        [self fetchBindAccount];
    } else {
        [self setTitle:@"新增账户" font:TITLE_FONT color:HOME_TITLE_COLOR];
    }
    [self.phoneLabel setText:[[[[ZXMyHelper sharedInstance] userInfo] tel] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    [self.fetchBtn.layer setCornerRadius:2.0];
    [self.confirmBtn.layer setCornerRadius:2.0];
    
    [self.nameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([UtilsMacro whetherIsEmptyWithObject:x]) {
            self.nameAbled = NO;
        } else {
            self.nameAbled = YES;
        }
        [self changeConfirmBtnBgColor];
    }];
    
    [self.accountTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([UtilsMacro whetherIsEmptyWithObject:x]) {
            self.accountAbled = NO;
        } else {
            self.accountAbled = YES;
        }
        [self changeConfirmBtnBgColor];
    }];
    
    [self.codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([x length] >= 4) {
            self.codeAbled = YES;
            self.codeTextField.text = [x substringToIndex:4];
        } else {
            self.codeAbled = NO;
        }
        [self changeConfirmBtnBgColor];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
}

- (void)backButtonPressed:(id)sender {
    if ([_type integerValue] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    }
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

- (void)fetchBindAccount {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXBindAccountHelper sharedInstance] fetchBindAccountWithRealName:self.realName andAlipay:self.accountStr andCode:nil andType:@"0" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            self.bindAccount = [ZXBindAccount yy_modelWithDictionary:response.data];
            if (![UtilsMacro whetherIsEmptyWithObject:self.bindAccount.realname]) {
                [self.nameTextField setText:self.bindAccount.realname];
                self.nameAbled = YES;
            }
            if (![UtilsMacro whetherIsEmptyWithObject:self.bindAccount.tel]) {
                [self.phoneLabel setText:self.bindAccount.tel];
            }
            if (![UtilsMacro whetherIsEmptyWithObject:self.bindAccount.alipay]) {
                [self.accountTextField setText:self.bindAccount.alipay];
                self.accountAbled = YES;
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

- (void)changeConfirmBtnBgColor {
    if (self.nameAbled && self.accountAbled && self.codeAbled) {
        [self.confirmBtn setBackgroundColor:THEME_COLOR];
    } else {
        [self.confirmBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
    }
}

- (void)modifyAccountControllerTimerCount {
    _second --;
    NSString *str = [NSString stringWithFormat:@"%ds后重发",(int)_second];
    if (_second > 0) {
        [self.fetchBtn setUserInteractionEnabled:NO];
        [self.fetchBtn setTitle:str forState:UIControlStateNormal];
        [self.fetchBtn.titleLabel setText:str];
    } else {
        [self.fetchBtn setUserInteractionEnabled:YES];
        [self.fetchBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.fetchBtn.titleLabel setText:@"获取验证码"];
    }
}
#pragma mark - Button Methods

- (IBAction)handleTapFetchBtnAction:(id)sender {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        _second = 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(modifyAccountControllerTimerCount) userInfo:nil repeats:YES];
        [[ZXCodeHelper sharedInstance] fetchCodeWithType:@"4" andTel:nil andUser_id:nil andUniondid:nil completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            [ZXProgressHUD loadSucceedWithMsg:response.info];
        } error:^(ZXResponse * _Nonnull response) {
            [self.timer invalidate];
            self.timer = nil;
            [self.fetchBtn setUserInteractionEnabled:YES];
            [self.fetchBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.fetchBtn.titleLabel setText:@"获取验证码"];
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (IBAction)handleTapConfirmBtnAction:(id)sender {
    if ([UtilsMacro whetherIsEmptyWithObject:[self.nameTextField text]]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入真实姓名"];
        return;
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[self.accountTextField text]]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入支付宝账号"];
        return;
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[self.codeTextField text]]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入验证码"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXBindAccountHelper sharedInstance] fetchBindAccountWithRealName:self.nameTextField.text andAlipay:self.accountTextField.text andCode:self.codeTextField.text andType:@"1" completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            if (self.zxModifyAccountBlock) {
                self.zxModifyAccountBlock([NSString stringWithFormat:@"%@(%@)",self.accountTextField.text,self.nameTextField.text]);
            }
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            [self.navigationController popViewControllerAnimated:YES];
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
