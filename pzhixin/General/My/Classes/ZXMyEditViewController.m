//
//  ZXMyEditViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyEditViewController.h"
#import "ZXEditNameView.h"
#import "ZXEditIntroView.h"
#import "ZXEditWxView.h"
#import "ZXEditPayPwdView.h"
#import "ZXEditWxBindView.h"
#import "ZXEditPhoneView.h"
#import "ZXFeedbackView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZXVerifyViewController.h"
#import "ZXFeedbackPickCell.h"
#import "ZXPhotoUtil.h"
#import "UIImage+JKRImage.h"

#define NICKNAME_MAX 30
#define INTRO_MAX 200

@interface ZXMyEditViewController () <UITextFieldDelegate, UITextViewDelegate, ZXEditPhoneViewDelegate, ZXEditPayPwdViewDelegate, ZXEditWxBindViewDelegate, ZXWeChatUtilsDelegate, ZXFeedbackViewDelegate, ZXPhotoUtilDelegate> {
    ZXEditNameView *editNameView;
    ZXEditIntroView *editIntroView;
    ZXEditWxView *editWxView;
    ZXEditPayPwdView *editPayPwdView;
    ZXEditWxBindView *wxBindView;
    ZXEditPhoneView *editPhoneView;
    ZXFeedbackView *feedbackView;
    NSMutableArray *feedbackImgList;
    NSInteger second;
    NSTimer *timer;
}

@end

@implementation ZXMyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.titleStr font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self.view setBackgroundColor:BG_COLOR];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
    switch (self.type) {
            //修改昵称
        case 1:
        {
            [self setRightBtnTitle:@"保存" target:self action:@selector(handleTapRightBtnAction)];
            [self createEditNameView];
        }
            break;
            //修改个人简介
        case 3:
        {
            [self setRightBtnTitle:@"保存" target:self action:@selector(handleTapRightBtnAction)];
            [self createEditIntroView];
        }
            break;
            //修改微信号
        case 4:
        {
            [self setRightBtnTitle:@"保存" target:self action:@selector(handleTapRightBtnAction)];
            [self createEditWxView];
        }
            break;
            //修改支付密码
        case 5:
        {
            [self createEditPayPwdView];
        }
            break;
            //微信绑定&&解绑
        case 6:
        {
            [self createEditWxBindView];
        }
            break;
            //修改手机号码
        case 7:
        {
            [self createEditPhoneView];
        }
            break;
            //修改手机号码
        case 8:
        {
            [self createFeedbackView];
        }
            break;
            
        default:
            break;
    }
}

- (void)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[ZXPhotoUtil sharedInstance] removeImgPickerVC];
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

#pragma mark - 修改昵称

- (void)createEditNameView {
    if (!editNameView) {
        editNameView = [[ZXEditNameView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 50.0)];
        [editNameView.nameTextField setDelegate:self];
        [editNameView.nameTextField addTarget:self action:@selector(nameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] nickname]]) {
        [editNameView.nameTextField setText:@""];
    } else {
        [editNameView.nameTextField setText:[[[ZXMyHelper sharedInstance] userInfo] nickname]];
    }
    editNameView.nameTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:editNameView];
}

- (void)nameTextFieldDidChange:(UITextField *)textField {
    if ([[editNameView.nameTextField text] length] > NICKNAME_MAX) {
        [editNameView.nameTextField setText:[[editNameView.nameTextField text] substringToIndex:NICKNAME_MAX]];
    }
}

#pragma mark - 修改个人简介

- (void)createEditIntroView {
    if (!editIntroView) {
        editIntroView = [[ZXEditIntroView alloc] init];
//        editIntroView = [[ZXEditIntroView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 100.0)];
        [editIntroView.introTextView setDelegate:self];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] intro]]) {
        [editIntroView.introTextView setText:@""];
        [editIntroView.tipLabel setHidden:NO];
    } else {
        [editIntroView.introTextView setText:[[[ZXMyHelper sharedInstance] userInfo] intro]];
        [editIntroView.tipLabel setHidden:YES];
    }
    [self.view addSubview:editIntroView];
    [editIntroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
    }];
}

#pragma mark - 修改微信号

- (void)createEditWxView {
    if (!editWxView) {
        editWxView = [[ZXEditWxView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 50.0)];
        [editWxView.wxTextField setDelegate:self];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] wx]]) {
        [editWxView.wxTextField setText:@""];
    } else {
        [editWxView.wxTextField setText:[[[ZXMyHelper sharedInstance] userInfo] wx]];
    }
    editWxView.wxTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:editWxView];
}

#pragma mark - 修改支付密码

- (void)createEditPayPwdView {
    if (!editPayPwdView) {
        editPayPwdView = [[ZXEditPayPwdView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 200.0)];
        [editPayPwdView setDelegate:self];
        [editPayPwdView.pwdTextField addTarget:self action:@selector(pwdTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [editPayPwdView.confirmTextField addTarget:self action:@selector(confirmTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    [self.view addSubview:editPayPwdView];
}

- (void)pwdTextFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 6) {
        [textField setText:[textField.text substringToIndex:6]];
    }
    if ([textField.text length] == 6 && [editPayPwdView.confirmTextField.text length] == 6) {
        [editPayPwdView.submitBtn setBackgroundColor:THEME_COLOR];
    } else {
        [editPayPwdView.submitBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
    }
}

- (void)confirmTextFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 6) {
        [textField setText:[textField.text substringToIndex:6]];
    }
    if ([textField.text length] == 6 && [editPayPwdView.pwdTextField.text length] == 6) {
        [editPayPwdView.submitBtn setBackgroundColor:THEME_COLOR];
    } else {
        [editPayPwdView.submitBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
    }
}

#pragma mark - 微信绑定&&解绑

- (void)createEditWxBindView {
    if (!wxBindView) {
        wxBindView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXEditWxBindView class]) owner:nil options:nil] lastObject];
        [wxBindView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 380.0)];
        [wxBindView setDelegate:self];
    }
    if ([[[[ZXMyHelper sharedInstance] userInfo] bind_wx] integerValue] == 1) {
        [wxBindView.tipView setHidden:YES];
        [wxBindView.bindView setHidden:YES];
        [wxBindView.bindedView setHidden:NO];
        [wxBindView.releaseView setHidden:NO];
        if ([UtilsMacro whetherIsEmptyWithObject:[[[[ZXMyHelper sharedInstance] userInfo] wxtmp] icon]]) {
            [wxBindView.userHeadImg setImage:DEFAULT_HEAD_IMG];
        } else {
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[[[[ZXMyHelper sharedInstance] userInfo] wxtmp] icon]] imageView:wxBindView.userHeadImg placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
        }
        if ([UtilsMacro whetherIsEmptyWithObject:[[[[ZXMyHelper sharedInstance] userInfo] wxtmp] nickname]]) {
            [wxBindView.nameLabel setText:@""];
        } else {
            [wxBindView.nameLabel setText:[[[[ZXMyHelper sharedInstance] userInfo] wxtmp] nickname]];
        }
    } else {
        [wxBindView.tipView setHidden:NO];
        [wxBindView.bindView setHidden:NO];
        [wxBindView.bindedView setHidden:YES];
        [wxBindView.releaseView setHidden:YES];
        [wxBindView.userHeadImg setImage:DEFAULT_HEAD_IMG];
        [wxBindView.nameLabel setText:@""];
    }
    [self.view addSubview:wxBindView];
}

#pragma mark - 修改手机号码

- (void)createEditPhoneView {
    if (!editPhoneView) {
        editPhoneView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXEditPhoneView class]) owner:nil options:nil] lastObject];
        [editPhoneView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 300.0)];
        [editPhoneView setDelegate:self];
        [editPhoneView.phoneTextField addTarget:self action:@selector(phoneTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [editPhoneView.codeTextField addTarget:self action:@selector(codeTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    [self.view addSubview:editPhoneView];
}

- (void)phoneTextFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 11) {
        [textField setText:[textField.text substringToIndex:11]];
    }
    if ([textField.text length] == 11 && [editPhoneView.codeTextField.text length] == 4) {
        [editPhoneView.submitBtn setBackgroundColor:THEME_COLOR];
    } else {
        [editPhoneView.submitBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
    }
}

- (void)codeTextFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 4) {
        [textField setText:[textField.text substringToIndex:4]];
    }
    if ([textField.text length] == 4 && [editPhoneView.phoneTextField.text length] == 11) {
        [editPhoneView.submitBtn setBackgroundColor:THEME_COLOR];
    } else {
        [editPhoneView.submitBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"DEDEDE"]];
    }
}

#pragma mark - 意见反馈

- (void)createFeedbackView {
    if (!feedbackView) {
        feedbackView = [[ZXFeedbackView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENHEIGHT)];
        [feedbackView setDelegate:self];
    }
    feedbackImgList = [[NSMutableArray alloc] init];
    [feedbackView setImgList:feedbackImgList];
    [self.view addSubview:feedbackView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    switch (self.type) {
        case 1:
        {
            if ([[editNameView.nameTextField text] length] == 0) {
                [ZXProgressHUD loadFailedWithMsg:@"请输入昵称"];
                return YES;
            }
            if ([[editNameView.nameTextField text] isEqualToString:[[[ZXMyHelper sharedInstance] userInfo] nickname]]) {
                [ZXProgressHUD loadFailedWithMsg:@"未作修改"];
                return YES;
            }
            if ([UtilsMacro isCanReachableNetWork]) {
                [self fetchUpdatSettingWithVal:editNameView.nameTextField.text];
                return YES;
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return YES;
            }
        }
            break;
        case 4:
        {
            if ([[editWxView.wxTextField text] length] == 0) {
                [ZXProgressHUD loadFailedWithMsg:@"请输入微信号"];
                return YES;
            }
            if ([[editWxView.wxTextField text] isEqualToString:[[[ZXMyHelper sharedInstance] userInfo] wx]]) {
                [ZXProgressHUD loadFailedWithMsg:@"未作修改"];
                return YES;
            }
            if ([UtilsMacro isCanReachableNetWork]) {
                [self fetchUpdatSettingWithVal:editWxView.wxTextField.text];
                return YES;
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return YES;
            }
        }
            break;
            
        default:
            return YES;
            break;
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == editIntroView.introTextView) {
        if (textView.text.length > 0) {
            [editIntroView.tipLabel setHidden:YES];
        } else {
            [editIntroView.tipLabel setHidden:NO];
        }
//        if (textView.markedTextRange == nil && textView.text.length > INTRO_MAX) {
//            [textView setText:[textView.text substringToIndex:INTRO_MAX]];
//        }
//        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
//        CGFloat height;
//        if (size.height < 100.0) {
//            height = 100.0;
//        } else {
//            height = size.height;
//        }
//        [editIntroView.editIntroView setFrame:CGRectMake(editIntroView.frame.origin.x, editIntroView.frame.origin.y, editIntroView.frame.size.width, height)];
//        [editIntroView.introTextView setFrame:CGRectMake(editIntroView.introTextView.frame.origin.x, editIntroView.introTextView.frame.origin.y, editIntroView.introTextView.frame.size.width, height - 20.0)];
    }
}

#pragma mark - Private Methods

- (void)fetchUpdatSettingWithVal:(NSString *)inVal {
    [ZXProgressHUD loadingNoMask];
    [[ZXSettingHelper sharedInstance] fetchSettingWithType:[NSString stringWithFormat:@"%ld",(long)self.type] andVal:inVal completion:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD hideAllHUD];
        [ZXProgressHUD loadSucceedWithMsg:response.info];
        ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
        ZXSettingRes *settingRes = [ZXSettingRes yy_modelWithJSON:response.data];
        switch (self.type) {
            case 1:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:settingRes.val]) {
                    [userInfo setNickname:@""];
                } else {
                    [userInfo setNickname:settingRes.val];
                }
            }
                break;
            case 3:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:settingRes.val]) {
                    [userInfo setIntro:@""];
                } else {
                    [userInfo setIntro:settingRes.val];
                }
            }
                break;
            case 4:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:settingRes.val]) {
                    [userInfo setWx:@""];
                } else {
                    [userInfo setWx:settingRes.val];
                }
            }
                break;
                
            default:
                break;
        }
        [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
    } error:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD loadFailedWithMsg:response.info];
        return;
    }];
}

//导航栏右边按钮点击事件
- (void)handleTapRightBtnAction {
    [self.view endEditing:YES];
    switch (self.type) {
        case 1:
        {
            if ([[editNameView.nameTextField text] length] == 0) {
                [ZXProgressHUD loadFailedWithMsg:@"请输入昵称"];
                return;
            }
            if ([[editNameView.nameTextField text] isEqualToString:[[[ZXMyHelper sharedInstance] userInfo] nickname]]) {
                [ZXProgressHUD loadFailedWithMsg:@"未作修改"];
                return;
            }
            if ([UtilsMacro isCanReachableNetWork]) {
                [self fetchUpdatSettingWithVal:editNameView.nameTextField.text];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        }
            break;
        case 3:
        {
            if ([[editIntroView.introTextView text] length] == 0) {
                [ZXProgressHUD loadFailedWithMsg:@"请填写简介"];
                return;
            }
            if ([[editIntroView.introTextView text] isEqualToString:[[[ZXMyHelper sharedInstance] userInfo] intro]]) {
                [ZXProgressHUD loadFailedWithMsg:@"未作修改"];
                return;
            }
            if ([UtilsMacro isCanReachableNetWork]) {
                [self fetchUpdatSettingWithVal:editIntroView.introTextView.text];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        }
            break;
        case 4:
        {
            if ([[editWxView.wxTextField text] length] == 0) {
                [ZXProgressHUD loadFailedWithMsg:@"请输入微信号"];
                return;
            }
            if ([[editWxView.wxTextField text] isEqualToString:[[[ZXMyHelper sharedInstance] userInfo] wx]]) {
                [ZXProgressHUD loadFailedWithMsg:@"未作修改"];
                return;
            }
            if ([UtilsMacro isCanReachableNetWork]) {
                [self fetchUpdatSettingWithVal:editWxView.wxTextField.text];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ZXEditPhoneViewDelegate

- (void)editPhoneHandleTapCodeBtnAction {
    if ([editPhoneView.phoneTextField.text length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入新手机号"];
        return;
    }
    if ([editPhoneView.phoneTextField.text length] != 11) {
        [ZXProgressHUD loadFailedWithMsg:@"手机号长度有误"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        second = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myEditPhoneViewCodeBtnCount) userInfo:nil repeats:YES];
        [ZXProgressHUD loadingNoMask];
        [[ZXCodeHelper sharedInstance] fetchCodeWithType:@"5" andTel:editPhoneView.phoneTextField.text andUser_id:nil andUniondid:nil completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
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

- (void)myEditPhoneViewCodeBtnCount {
    second --;
    NSString *str = [NSString stringWithFormat:@"%d后重发", (int)second];
    if (second > 0) {
        [editPhoneView.codeBtn setUserInteractionEnabled:NO];
        [editPhoneView.codeBtn setTitle:str forState:UIControlStateNormal];
        [editPhoneView.codeBtn.titleLabel setText:str];
    } else {
        [editPhoneView.codeBtn setUserInteractionEnabled:YES];
        [editPhoneView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [editPhoneView.codeBtn.titleLabel setText:@"获取验证码"];
    }
}

- (void)editPhoneHandleTapSubmitBtnAction {
    if ([editPhoneView.phoneTextField.text length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入新手机号"];
        return;
    }
    if ([editPhoneView.phoneTextField.text length] != 11) {
        [ZXProgressHUD loadFailedWithMsg:@"手机号长度有误"];
        return;
    }
    if ([editPhoneView.codeTextField.text length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入验证码"];
        return;
    }
    if ([editPhoneView.codeTextField.text length] != 4) {
        [ZXProgressHUD loadFailedWithMsg:@"验证码长度有误"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXModifyTelHelper sharedInstance] fetchModifyTelWithStep:@"2" andCode:self.oldCode andTel:editPhoneView.phoneTextField.text andCodeNew:editPhoneView.codeTextField.text completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_VERIFY" object:nil];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - ZXEditPayPwdViewDelegate

- (void)editPayPwdViewHandleTapSubmitBtnAction {
    if ([editPayPwdView.pwdTextField.text length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入支付密码"];
        return;
    }
    if ([editPayPwdView.pwdTextField.text length] != 6) {
        [ZXProgressHUD loadFailedWithMsg:@"密码长度为6位"];
        return;
    }
    if ([editPayPwdView.confirmTextField.text length] == 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请确认支付密码"];
        return;
    }
    if ([editPayPwdView.confirmTextField.text length] != 6) {
        [ZXProgressHUD loadFailedWithMsg:@"密码长度为6位"];
        return;
    }
    if (![editPayPwdView.confirmTextField.text isEqualToString:editPayPwdView.pwdTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"两次密码不一致"];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXModifyPPwdHelper sharedInstance] fetchModifyPPwdWithStep:@"2" andVal:editPayPwdView.pwdTextField.text andCode:self.oldCode completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_VERIFY" object:nil];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - ZXEditWxBindViewDelegate

- (void)editWxBindViewHandleTapUnBindViewAction {
    ZXVerifyViewController *verify = [[ZXVerifyViewController alloc] init];
    [verify setType:3];
    [verify setCodeType:4];
    UINavigationController *verifyNavi = [[UINavigationController alloc] initWithRootViewController:verify];
    [verifyNavi setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:verifyNavi animated:YES completion:nil];
}

- (void)editWxBindViewHanldeTapBindBtnAction {
    [[ZXWeChatUtils sharedInstance] sendAuthLoginReuqestWithController:self delegate:self];
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatAuthLoginSucceedWithCode:(NSString *)authCode {
    [ZXProgressHUD loadingNoMask];
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXBindWXHelper sharedInstance] fetchBindWXWithCode:authCode completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
            [userInfo setBind_wx:@"1"];
            ZXWXTmp *wxTmp = [[ZXWXTmp alloc] init];
            if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"icon"]]) {
                [wxTmp setIcon:@""];
                [self->wxBindView.userHeadImg setImage:DEFAULT_HEAD_IMG];
            } else {
                [wxTmp setIcon:[response.data valueForKey:@"icon"]];
                [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[response.data valueForKey:@"icon"]] imageView:self->wxBindView.userHeadImg placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                }];
            }
            if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"nickname"]]) {
                [wxTmp setNickname:@""];
                [self->wxBindView.nameLabel setText:@""];
            } else {
                [wxTmp setNickname:[response.data valueForKey:@"nickname"]];
                [self->wxBindView.nameLabel setText:[response.data valueForKey:@"nickname"]];
            }
            [userInfo setWxtmp:wxTmp];
            [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
            [self dismissViewControllerAnimated:YES completion:nil];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
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

#pragma mark - ZXFeedbackViewDelegate

- (void)feedbackCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //选择照片
    if ([cell isKindOfClass:[ZXFeedbackPickCell class]]) {
        UIAlertController *pickAlert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZXPhotoUtil sharedInstance] takePhotoWithViewController:self delegate:self];
        }];
        UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZXPhotoUtil sharedInstance] zlSelectPhotoWithMax:5 WithViewController:self delegate:self];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [pickAlert addAction:camera];
        [pickAlert addAction:library];
        [pickAlert addAction:cancel];
        [self presentViewController:pickAlert animated:YES completion:nil];
    } else {
        
    }
}

- (void)feedbackSubmitButtonAction {
    
}

#pragma mark - ZXPhotoUtilDelegate

//- (void)zxPhotoUtilImagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    for (int i = 0; i < [photos count]; i++) {
//        UIImage *resultImg = [[photos objectAtIndex:i] jkr_compressWithWidth:IMAGE_WIDTH];
//        [resultImg jkr_compressToDataLength:IMAGE_DATA_LENGTH withBlock:^(NSData *data) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self->feedbackImgList addObject:[UIImage imageWithData:data]];
//                [self->feedbackView setImgList:self->feedbackImgList];
//            });
//        }];
//    }
//}
//
//- (void)zxPhotoUtilTZ_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
//    NSLog(@"取消选择照片");
//}

- (void)zlPhotoActionFinished:(ZLPhotoActionSheet *)photoActionSheet images:(NSArray<UIImage *> *)images asstes:(NSArray<PHAsset *> *)assets isOriginal:(BOOL)isOriginal {
    for (int i = 0; i < [images count]; i++) {
        UIImage *resultImg = [[images objectAtIndex:i] jkr_compressWithWidth:IMAGE_WIDTH];
        [resultImg jkr_compressToDataLength:IMAGE_DATA_LENGTH withBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->feedbackImgList addObject:[UIImage imageWithData:data]];
                [self->feedbackView setImgList:self->feedbackImgList];
            });
        }];
    }
}

- (void)zlPhotoActionCancel:(ZLPhotoActionSheet *)photoActionSheet {
//    NSLog(@"取消选择照片");
}

- (void)zxPhotoUtilImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *resultImg = [[info valueForKey:UIImagePickerControllerOriginalImage] jkr_compressWithWidth:IMAGE_WIDTH];
    [resultImg jkr_compressToDataLength:IMAGE_DATA_LENGTH withBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->feedbackImgList addObject:[UIImage imageWithData:data]];
            [self->feedbackView setImgList:self->feedbackImgList];
        });
    }];
    
}

- (void)zxPhotoUtilImagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
