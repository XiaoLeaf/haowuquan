//
//  ZXAccountViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAccountViewController.h"
#import "ZXVerifyViewController.h"
#import "ZXMyEditViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "ZXAccountCell.h"

@interface ZXAccountViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate> {
    NSArray *accountList;
    
    //淘宝授权
    NSMutableString *cookieValue;
    
    UIWebView *authWebView;
}

@property (strong, nonatomic) ZXTBAuthView *tbAuthView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger second;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation ZXAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    [self.accountTableView setTableFooterView:[UIView new]];
    [self setTitle:@"账户安全" font:TITLE_FONT color:HOME_TITLE_COLOR];
    accountList = @[@[@"手机号码", @"支付密码", @"绑定淘宝", @"绑定微信"], @[[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].txt]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
    [self.accountTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [accountList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[accountList objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [accountList count] - 1) {
        return 0.01;
    }
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXAccountCell";
    ZXAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXAccountCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@",[[accountList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] tel]]) {
                        [cell.contentLabel setText:@"点击绑定手机号码"];
                    } else {
                        [cell.contentLabel setText:[[[[ZXMyHelper sharedInstance] userInfo] tel] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
                    }
                }
                    break;
                case 2:
                {
                    if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] bind_tb]]) {
                        [cell.contentLabel setText:@"未绑定"];
                        [cell.arrowImg setHidden:NO];
                        cell.contentRight.constant = 8.0;
                    } else {
                        if ([[[[ZXMyHelper sharedInstance] userInfo] bind_tb] integerValue] == 0) {
                            [cell.contentLabel setText:@"未绑定"];
                            [cell.arrowImg setHidden:NO];
                            cell.contentRight.constant = 8.0;
                        } else {
                            [cell.contentLabel setText:[[[ZXMyHelper sharedInstance] userInfo] tb_nickname]];
                            [cell.arrowImg setHidden:YES];
                            cell.contentRight.constant = -15.0;
                        }
                    }
                }
                    break;
                case 3:
                {
                    if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] bind_wx]]) {
                        [cell.contentLabel setText:@"未绑定"];
                    } else {
                        if ([[[[ZXMyHelper sharedInstance] userInfo] bind_wx] integerValue] == 0) {
                            [cell.contentLabel setText:@"未绑定"];
                        } else {
                            [cell.contentLabel setText:[[[[ZXMyHelper sharedInstance] userInfo] wxtmp] nickname]];
                        }
                    }
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
                        ZXVerifyViewController *verify = [[ZXVerifyViewController alloc] init];
                        [verify setType:1];
                        [verify setCodeType:4];
                        UINavigationController *verifyNavi = [[UINavigationController alloc] initWithRootViewController:verify];
                        [verifyNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                        [self presentViewController:verifyNavi animated:YES completion:nil];
                    });
                }
                    break;
                case 1:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ZXVerifyViewController *verify = [[ZXVerifyViewController alloc] init];
                        [verify setType:2];
                        [verify setCodeType:4];
                        UINavigationController *verifyNavi = [[UINavigationController alloc] initWithRootViewController:verify];
                        [verifyNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                        [self presentViewController:verifyNavi animated:YES completion:nil];
                    });
                }
                    break;
                case 2:
                {
                    if ([[[[ZXMyHelper sharedInstance] userInfo] bind_tb] integerValue] == 0) {
                        [UtilsMacro openTBAuthViewWithVC:self completion:^{
                            [self.accountTableView reloadData];
                        }];
                    } else {
                        return;
                    }
                }
                    break;
                case 3:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ZXMyEditViewController *edit = [[ZXMyEditViewController alloc] init];
                        [edit setType:6];
                        [edit setTitleStr:@"微信绑定"];
                        UINavigationController *editNavi = [[UINavigationController alloc] initWithRootViewController:edit];
                        [editNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                        [self presentViewController:editNavi animated:YES completion:nil];
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
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].url_schema] andUserInfo:nil viewController:self];
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
