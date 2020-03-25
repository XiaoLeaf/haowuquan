//
//  ZXAddressInfoViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressInfoViewController.h"
#import "ZXAddressInfoCell.h"
#import "ZHFAddTitleAddressView.h"
#import "ZXAddressInfoDetailCell.h"

@interface ZXAddressInfoViewController () <UITableViewDelegate, UITableViewDataSource, ZHFAddTitleAddressViewDelegate, ZXAddressInfoDetailCellDelegate>

@property (strong, nonatomic) ZHFAddTitleAddressView *addressView;

@property (strong, nonatomic) NSArray *placeHolderList;

@property (assign, nonatomic) CGFloat safeHeight;

@end

@implementation ZXAddressInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.addressTableView setEstimatedRowHeight:50.0];
    [self.addressTableView setRowHeight:UITableViewAutomaticDimension];
    [self setTitle:@"地址详情" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self setRightBtnTitle:@"保存" target:self action:@selector(handleTapRightBtnAction)];
    _placeHolderList = @[@"请添加收货人姓名", @"请输入手机号码", @"所在地区", @"请输入详细地址", @"设置默认地址"];
    [self.addressTableView setTableFooterView:[UIView new]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        _safeHeight = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
        _safeHeight = 0.0;
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

//导航栏右边按钮点击事件
- (void)handleTapRightBtnAction {
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    ZXAddressInfoCell *firstCell = [self.addressTableView cellForRowAtIndexPath:firstIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:firstCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入收货人姓名"];
        return;
    }
    
    NSIndexPath *secIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    ZXAddressInfoCell *secCell = [self.addressTableView cellForRowAtIndexPath:secIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:secCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入手机号码"];
        return;
    }
    if (secCell.contentTextField.text.length != 11) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入正确手机号码"];
        return;
    }
    
    NSIndexPath *thirdIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    ZXAddressInfoCell *thirdCell = [self.addressTableView cellForRowAtIndexPath:thirdIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:thirdCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请选择所在地区"];
        return;
    }
    
    NSIndexPath *fouthIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    ZXAddressInfoDetailCell *fouthCell = [self.addressTableView cellForRowAtIndexPath:fouthIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:fouthCell.detailTextView.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入详细地址"];
        return;
    }
    
    NSIndexPath *fifthIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    ZXAddressInfoCell *fifthCell = [self.addressTableView cellForRowAtIndexPath:fifthIndex];
    NSString *isDef;
    if ([fifthCell.defaultSwitch isOn]) {
        isDef = @"1";
    } else {
        isDef = @"2";
    }
    
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXAddrInfoHelper sharedInstance] fetchAddrInfoWithAct:@"save" andId:_addrItem ? _addrItem.addrId : @"0" andRealName:firstCell.contentTextField.text andTel:secCell.contentTextField.text andProv_id:_addrItem.prov_id andCity_id:_addrItem.city_id andArea_id:_addrItem.area_id andStreer_id:_addrItem.street_id andAddress:fouthCell.detailTextView.text andIs_def:isDef Completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            if (self.zxAddressInfoChangeBlcok) {
                self.zxAddressInfoChangeBlcok();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)createAddressViewWithHeight:(CGFloat)height {
    _addressView = [[ZHFAddTitleAddressView alloc] init];
    [_addressView setTitle:@"请选择区域"];
    [_addressView setDelegate:self];
    [_addressView setDefaultHeight:500];
    [_addressView setTitleScrollViewH:30.0];
    
    UIView *subView = [_addressView initAddressViewWithHeiht:self.view.bounds.size.height - height andSafeHeight:height];
    [self.view addSubview:subView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_placeHolderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        static NSString *identifier = @"ZXAddressInfoDetailCell";
        ZXAddressInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXAddressInfoDetailCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        if ([UtilsMacro whetherIsEmptyWithObject:_addrItem.address]) {
            [cell.placeTextField setPlaceholder:@"请输入详细地址"];
        } else {
            [cell.placeTextField setPlaceholder:@""];
        }
        [cell.detailTextView setText:_addrItem.address];
        return cell;
    } else {
        static NSString *identifier = @"ZXAddressInfoCell";
        ZXAddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXAddressInfoCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setTag:indexPath.row];
        [cell.contentTextField setPlaceholder:[NSString stringWithFormat:@"%@", [_placeHolderList objectAtIndex:indexPath.row]]];
        if (indexPath.row != [_placeHolderList count] - 1) {
            [cell.defaultSwitch setHidden:YES];
            [cell.arrowImg setHidden:NO];
        } else {
            [cell.defaultSwitch setHidden:NO];
            [cell.arrowImg setHidden:YES];
        }
        cell.zxAddressInfoCellTFEdited = ^(NSInteger cellTag, ZXAddressInfoCell * _Nonnull infoCell) {
            switch (cellTag) {
                case 0:
                    [self.addrItem setRealname:infoCell.contentTextField.text];
                    break;
                case 1:
                    [self.addrItem setTel:infoCell.contentTextField.text];
                    break;
                    
                default:
                    break;
            }
        };
        cell.zxAddressInfoCellSwitchValueChanged = ^(BOOL isOn) {
            if (isOn) {
                [self.addrItem setIs_def:@"1"];
            } else {
                [self.addrItem setIs_def:@"2"];
            }
        };
        if (indexPath.row == 1) {
            [cell.contentTextField setKeyboardType:UIKeyboardTypePhonePad];
        }
        if (indexPath.row == 2 || indexPath.row == 4) {
            [cell.contentTextField setUserInteractionEnabled:NO];
        } else {
            [cell.contentTextField setUserInteractionEnabled:YES];
        }
        switch (indexPath.row) {
            case 0:
                [cell setContentStr:_addrItem.realname];
                break;
            case 1:
                [cell setContentStr:_addrItem.tel];
                break;
            case 2:
                [cell setContentStr:_addrItem.pcas];
                break;
            case 4:
            {
                if ([_addrItem.is_def integerValue] == 1) {
                    [cell.defaultSwitch setOn:YES];
                } else {
                    [cell.defaultSwitch setOn:NO];
                }
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if (!_addressView) {
                [self createAddressViewWithHeight:_safeHeight];
            }
            [_addressView addAnimateWithHeight:_safeHeight];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ZXAddressInfoDetailCellDelegate

- (void)addressInfoDetailCellTextViewDidChange:(YYTextView *)textView {
    [self.addressTableView beginUpdates];
    [self.addressTableView endUpdates];
}

#pragma mark - ZHFAddTitleAddressViewDelegate

- (void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID {
    [_addrItem setPcas:titleAddress];
    [self.addressTableView reloadData];
    NSArray *idList = [[NSArray alloc] initWithArray:[titleID componentsSeparatedByString:@","]];
    if ([idList count] > 0) {
        [_addrItem setProv_id:[idList objectAtIndex:0]];
    } else {
        [_addrItem setProv_id:@""];
        [_addrItem setCity_id:@""];
        [_addrItem setArea_id:@""];
        [_addrItem setStreet_id:@""];
    }
    
    if ([idList count] > 1) {
        [_addrItem setCity_id:[idList objectAtIndex:1]];
    } else {
        [_addrItem setCity_id:@""];
        [_addrItem setArea_id:@""];
        [_addrItem setStreet_id:@""];
    }
    
    if ([idList count] > 2) {
        [_addrItem setArea_id:[idList objectAtIndex:2]];
    } else {
        [_addrItem setArea_id:@""];
        [_addrItem setStreet_id:@""];
    }
    
    if ([idList count] > 3) {
        [_addrItem setStreet_id:[idList objectAtIndex:3]];
    } else {
        [_addrItem setStreet_id:@""];
    }
}

@end
