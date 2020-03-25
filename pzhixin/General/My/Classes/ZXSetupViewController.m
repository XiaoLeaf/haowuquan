//
//  ZXSetupViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSetupViewController.h"
#import "ZXPersonalViewController.h"
#import "ZXAccountViewController.h"
#import "ZXAboutViewController.h"
#import "ZXAddressListViewController.h"
#import "ZXSetupCell.h"
#import "ZXMyEditViewController.h"
#import <LTNavigationBar/UINavigationBar+Awesome.h>
#import "ZXLoginViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "AppDelegate.h"

@interface ZXSetupViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *setupList;
    UIAlertController *exitAlert;
    NSString *cacheStr;
}

@end

@implementation ZXSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.setupTableView setBackgroundColor:BG_COLOR];
    cacheStr = @"计算中";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->cacheStr = [UtilsMacro getCachesSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
            [self.setupTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
    [self.view setBackgroundColor:BG_COLOR];
    // Do any additional setup after loading the view from its nib
    [self setTitle:@"设置" font:TITLE_FONT color:HOME_TITLE_COLOR];
    setupList = @[@[@"个人资料", @"账户与安全", @"我的地址"], @[[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] feedback].txt, @"推送通知", @"清除缓存"], @[@"关于我们"], @[@"退出登录"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
                 
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [setupList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[setupList objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXSetupCell";
    ZXSetupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXSetupCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section != [setupList count] - 1) {
        [cell.exitLabel setHidden:YES];
        [cell.arrowImg setHidden:NO];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@",[[setupList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
        if (indexPath.section == 1 && indexPath.row == 1) {
            [cell.subLabel setText:@"避免错过订单状态通知-去开启"];
        } else if(indexPath.section == 1 && indexPath.row == 2) {
            [cell.subLabel setText:cacheStr];
        }
    } else {
        [cell.exitLabel setText:[NSString stringWithFormat:@"%@",[[setupList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
        [cell.exitLabel setHidden:NO];
        [cell.arrowImg setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, PERSONAL_VC] andUserInfo:nil viewController:self];
                    });
                }
                    break;
                case 1:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ACCOUNT_VC] andUserInfo:nil viewController:self];
                    });
                }
                    break;
                case 2:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ADDRESS_VC] andUserInfo:nil viewController:self];
                    });
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] feedback].url_schema] andUserInfo:nil viewController:self];
                    });
                }
                    break;
                case 1:
                {
                    UIAlertController *pushAlert = [UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"是否前往设置开启通知权限，及时收到推送消息？" style:UIAlertControllerStyleAlert andAction:@[@"确认"] alertActionClicked:^(NSInteger actionTag) {
                        switch (actionTag) {
                            case 0:
                            {
                                if (@available(iOS 10.0, *)) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                } else {
                                    // Fallback on earlier versions
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                }
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }];
                    [self presentViewController:pushAlert animated:YES completion:nil];
                }
                    break;
                case 2:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *clearAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认清除当前缓存数据？" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [ZXProgressHUD loadingNoMask];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [UtilsMacro removeCache];
                                self->cacheStr = @"";
                                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                    self->cacheStr = [UtilsMacro getCachesSize];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.setupTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                    });
                                });
                            });
                            
                        }];
                        [clearAlert addAction:cancel];
                        [clearAlert addAction:confirm];
                        [self presentViewController:clearAlert animated:YES completion:nil];
                    });
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, ABOUT_VC] andUserInfo:nil viewController:self];
                    });
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!self->exitAlert) {
                            self->exitAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认退出登录好物券？" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [[ZXLoginHelper sharedInstance] setLoginState:NO];
                                [[ZXLoginHelper sharedInstance] setAuthorization:@""];
                                [[ZXDatabaseUtil sharedDataBase] clearUserWithUser:[[ZXMyHelper sharedInstance] userInfo]];
                                [[ZXMyHelper sharedInstance] setUserInfo:[[ZXUser alloc] init]];
                                [[ZXTBAuthHelper sharedInstance] setTBAuthState:NO];
                                [UtilsMacro taobaoLogout];
                                ZXLoginViewController *loginVC = [[ZXLoginViewController alloc] init];
                                [loginVC setTabIndex:0];
                                UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                                [loginNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                                [[[[AppDelegate sharedInstance] homeTabBarController] selectedViewController] presentViewController:loginNavi animated:YES completion:^{
                                    [self.navigationController popViewControllerAnimated:NO];
                                }];
                            }];
                            [self->exitAlert addAction:cancel];
                            [self->exitAlert addAction:confirm];
                        }
                        [self.navigationController presentViewController:self->exitAlert animated:YES completion:nil];
                    });
                }
                    break;

                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
}

@end
