//
//  ZXAddressListViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressListViewController.h"
#import "ZXAddressInfoViewController.h"
#import "ZXAddAddressVC.h"
#import "ZXAddressListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXEditAddressVC.h"

@interface ZXAddressListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) ZXAddrRes *addrRes;

@end

@implementation ZXAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"收货地址" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.addBtn.layer setCornerRadius:2.0];
    [self.addressListTableView setEstimatedRowHeight:70.0];
    [self.addressListTableView setBackgroundColor:BG_COLOR];
    // Do any additional setup after loading the view from its nib.
    
    _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAddressList)];
//    [_refreshHeader.stateLab setTextColor:COLOR_999999];
    [_refreshHeader setTimeKey:@"ZXAddressListViewController"];
    self.addressListTableView.mj_header = _refreshHeader;
    [_refreshHeader beginRefreshing];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MJRefresh

- (void)refreshAddressList {
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXAddrListHelper sharedInstance] fetchAddrListCompletion:^(ZXResponse * _Nonnull response) {
            if ([self.refreshHeader isRefreshing]) {
                [self.refreshHeader endRefreshing];
            }
//            NSLog(@"response.data:%@",response.data);
            self.addrRes = [ZXAddrRes yy_modelWithJSON:response.data];
            [self.addressListTableView reloadData];
            if ([self.addrRes.list count] <= 0) {
                [self.addressListTableView setEmptyDataSetSource:self];
                [self.addressListTableView setEmptyDataSetDelegate:self];
                [self.addressListTableView reloadEmptyDataSet];
            }
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.refreshHeader isRefreshing]) {
                [self.refreshHeader endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if ([self.refreshHeader isRefreshing]) {
            [self.refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_addrRes.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
    [footerView setBackgroundColor:BG_COLOR];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXAddressListCell";
    ZXAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXAddressListCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXAddrItem *addrItem = (ZXAddrItem *)[_addrRes.list objectAtIndex:indexPath.section];
    [cell setAddrItem:addrItem];
    cell.zxAddressListCellClickEdit = ^{
        ZXEditAddressVC *editAddress = [[ZXEditAddressVC alloc] init];
        [editAddress setEditItem:addrItem];
        editAddress.zxEditAddressVCBlcok = ^{
            [self.refreshHeader beginRefreshing];
        };
        [self.navigationController pushViewController:editAddress animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ZXAddressInfoViewController *addressInfo = [[ZXAddressInfoViewController alloc] init];
//    ZXAddrItem *addrItem = (ZXAddrItem *)[_addrRes.list objectAtIndex:indexPath.section];
//    [addressInfo setAddrItem:addrItem];
//    [addressInfo setType:2];
//    addressInfo.zxAddressInfoChangeBlcok = ^{
//        [self refreshAddressList];
//    };
//    [self.navigationController pushViewController:addressInfo animated:YES];
}

- (NSArray <UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXAddrItem *addrItem = (ZXAddrItem *)[_addrRes.list objectAtIndex:indexPath.section];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *deleteAlert = [UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"是否确认删除当前收货地址？" style:UIAlertControllerStyleAlert andAction:@[@"确认"] alertActionClicked:^(NSInteger actionTag) {
            if ([UtilsMacro isCanReachableNetWork]) {
                [ZXProgressHUD loadingNoMask];
                [[ZXAddrOptHelper sharedInstance] fetchAddrOptWithAct:@"del" andId:addrItem.addrId completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                    [self refreshAddressList];
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                    return;
                }];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        }];
        [self presentViewController:deleteAlert animated:YES completion:nil];
    }];
    [deleteAction setBackgroundColor:THEME_COLOR];
    
    UITableViewRowAction *defaultAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"设为默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([UtilsMacro isCanReachableNetWork]) {
            [ZXProgressHUD loadingNoMask];
            [[ZXAddrOptHelper sharedInstance] fetchAddrOptWithAct:@"def" andId:addrItem.addrId completion:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadSucceedWithMsg:response.info];
                [self refreshAddressList];
            } error:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
                return;
            }];
        } else {
            [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
            return;
        }
    }];
    if ([addrItem.is_def integerValue] == 1) {
        return @[deleteAction];
    } else {
        return @[deleteAction, defaultAction];
    }
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_general_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"还没有相关地址哦~";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100.0;
}

#pragma mark - Button Method

- (IBAction)addNewAddress:(id)sender {
    ZXAddAddressVC *addAddress = [[ZXAddAddressVC alloc] init];
    addAddress.zxAddAddressVCBlcok = ^{
        [self.refreshHeader beginRefreshing];
    };
    [self.navigationController pushViewController:addAddress animated:YES];
}

@end
