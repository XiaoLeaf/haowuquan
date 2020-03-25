//
//  ZXWithDrawViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXWithDrawViewController.h"
#import "ZXModifyAccountViewController.h"
#import "ZXCashDetailVC.h"

@interface ZXCashInit : NSObject

@property (strong, nonatomic) NSString *account;

@property (strong, nonatomic) NSString *money;

@property (strong, nonatomic) NSString *is_check_pwd;

@end

@implementation ZXCashInit

@end

@interface ZXWithDrawViewController () <UITextFieldDelegate>

@property (strong, nonatomic) ZXPayPwView *payPwView;

@property (strong, nonatomic) ZXCashInit *cashInit;

@property (assign, nonatomic) BOOL needHidden;

@end

@implementation ZXWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"提现" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self fetchCashInitWithShowLoading:YES];
    [self setRightBtnTitle:@"提现明细" target:self action:@selector(checkWithDrawDetail)];
    [self.withdrawBtn.layer setCornerRadius:2.0];
    [self.numTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        //判断第一个输入的字符为.的时候，自动添加0
        if ([x isEqualToString:@"."]) {
            [self.numTextField setText:@"0."];
            return;
        }
        //保证小数点后面之后只有两位
        if ([x rangeOfString:@"."].location != NSNotFound) {
            NSRange subRan = [x rangeOfString:@"."];
            if (x.length > subRan.location + 2) {
                [self.numTextField setText:[x substringToIndex:subRan.location + subRan.length + 2]];
            }
        }
        //限定最大长度6位
        if (x.length > 6) {
            [self.numTextField setText:[x substringToIndex:6]];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.numTextField setText:@""];
    _needHidden = YES;
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
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

- (void)fetchCashInitWithShowLoading:(BOOL)show {
    if ([UtilsMacro isCanReachableNetWork]) {
        if (show) {
            [ZXProgressHUD loadingNoMask];
        }
        [[ZXCashInitHelper sharedInstance] fetchCashInitWithCompletion:^(ZXResponse * _Nonnull response) {
            if (self.needHidden) {
                [ZXProgressHUD hideAllHUD];
            }
            self.cashInit = [ZXCashInit yy_modelWithDictionary:response.data];
            [self configurationInfo];
            
            //同步本地的用户余额信息
            ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
            [[userInfo stat] setMoney:self.cashInit.money];
            [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
        } error:^(ZXResponse * _Nonnull response) {
            if (self.needHidden) {
                [ZXProgressHUD hideAllHUD];
            }
            if (response.status == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if (response.status == 1) {
                ZXModifyAccountViewController *modifyAccount = [[ZXModifyAccountViewController alloc] init];
                [modifyAccount setType:@"2"];
                __weak typeof(self) weakSelf = self;
                modifyAccount.zxModifyAccountBlock = ^(NSString * _Nonnull account) {
                    [weakSelf fetchCashInitWithShowLoading:NO];
//                    weakSelf.cashInit = [[ZXCashInit alloc] init];
//                    [weakSelf.cashInit setAccount:account];
//                    [self configurationInfo];
                };
                [self.navigationController pushViewController:modifyAccount animated:YES];
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

- (void)checkWithDrawDetail {
    ZXCashDetailVC *cashDetail = [[ZXCashDetailVC alloc] init];
    __weak typeof(self) weakSelf = self;
    cashDetail.zxCashDetailVCBlcok = ^{
        weakSelf.needHidden = NO;
        [weakSelf fetchCashInitWithShowLoading:weakSelf.needHidden];
        if (self.zxBalanceChangeBlock) {
            self.zxBalanceChangeBlock();
        }
    };
    [self.navigationController pushViewController:cashDetail animated:YES];
}

- (void)removePayPwView {
    [self.payPwView setBackgroundColor:[UIColor clearColor]];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:self.payPwView.mainView endRemove:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payPwView removeFromSuperview];
        self.payPwView = nil;
    });
}

- (void)configurationInfo {
    [self.accountLab setText:_cashInit.account];
    [self.maxLabel setText:[NSString stringWithFormat:@"最大提现金额   %@",[[[[ZXMyHelper sharedInstance] userInfo] stat] money]]];
}

- (void)fetchCashActionWithPwd:(NSString *_Nullable)pwd {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXCashDoHelper sharedInstance] fetchCashDoWithAmount:self.numTextField.text andPwd:pwd completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.zxBalanceChangeBlock) {
                    self.zxBalanceChangeBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - Button Methods

- (IBAction)handleTapEditBtnAction:(id)sender {
    ZXModifyAccountViewController *modify = [[ZXModifyAccountViewController alloc] init];
    [modify setType:@"1"];
    __weak typeof(self) weakSelf = self;
    modify.zxModifyAccountBlock = ^(NSString * _Nonnull account) {
        [weakSelf.cashInit setAccount:account];
        [self configurationInfo];
    };
    [self.navigationController pushViewController:modify animated:YES];
}

- (IBAction)handleTapAllBtnAction:(id)sender {
    [self.numTextField setText:_cashInit.money];
}

- (IBAction)handleTapWithDrawBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([UtilsMacro whetherIsEmptyWithObject:self.numTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入提现金额"];
        return;
    }
    if ([self.numTextField.text floatValue] <= 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入大于零的数字"];
        return;
    }
    if ([self.numTextField.text floatValue] > [_cashInit.money floatValue]) {
        [ZXProgressHUD loadFailedWithMsg:@"超出可提现最大金额"];
        return;
    }
    if ([[_cashInit is_check_pwd] integerValue] == 1) {
        _payPwView = [[ZXPayPwView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        __weak typeof(self) weakSelf = self;
        _payPwView.zxPayPwViewTapBlock = ^{
            [weakSelf removePayPwView];
        };
        _payPwView.zxPayPwViewPwBlock = ^(NSString * _Nonnull text, BOOL isFinished) {
            if (isFinished) {
                [weakSelf removePayPwView];
                [weakSelf fetchCashActionWithPwd:text];
            }
        };
        [[[UIApplication sharedApplication] keyWindow] addSubview:_payPwView];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:_payPwView.mainView endRemove:NO];
    } else {
        [self fetchCashActionWithPwd:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([UtilsMacro whetherIsEmptyWithObject:textField.text]) {
        return YES;
    } else {
        if ([string rangeOfString:@"."].location != NSNotFound && [textField.text rangeOfString:@"."].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

@end
