//
//  ZXAddAddressVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddAddressVC.h"
#import "ZXAddressInfoCell.h"
#import "ZHFAddTitleAddressView.h"
#import "ZXAddressInfoDetailCell.h"

@interface ZXAddAddressVC () <UITableViewDelegate, UITableViewDataSource, ZHFAddTitleAddressViewDelegate, ZXAddressInfoDetailCellDelegate>

@property (strong, nonatomic) ZHFAddTitleAddressView *addressView;

@property (strong, nonatomic) NSArray *placeHolderList;

@property (assign, nonatomic) CGFloat safeHeight;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSNumber *is_df;

@property (strong, nonatomic) NSString *prov_id;

@property (strong, nonatomic) NSString *city_id;

@property (strong, nonatomic) NSString *area_id;

@property (strong, nonatomic) NSString *street_id;

@end

@implementation ZXAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _address = @"";
    // Do any additional setup after loading the view from its nib.
    [self.addTable setEstimatedRowHeight:50.0];
    [self.addTable setRowHeight:UITableViewAutomaticDimension];
    [self setTitle:@"新增地址" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self setRightBtnTitle:@"保存" target:self action:@selector(handleTapRightBtnAction)];
    _placeHolderList = @[@"请添加收货人姓名", @"请输入手机号码", @"所在地区", @"请输入详细地址", @"设置默认地址"];
    [self.addTable setTableFooterView:[UIView new]];
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

- (void)handleTapRightBtnAction {
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    ZXAddressInfoCell *firstCell = [self.addTable cellForRowAtIndexPath:firstIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:firstCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入收货人姓名"];
        return;
    }
    
    NSIndexPath *secIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    ZXAddressInfoCell *secCell = [self.addTable cellForRowAtIndexPath:secIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:secCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入手机号码"];
        return;
    }
    if (secCell.contentTextField.text.length != 11) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入正确手机号码"];
        return;
    }
    
    NSIndexPath *thirdIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    ZXAddressInfoCell *thirdCell = [self.addTable cellForRowAtIndexPath:thirdIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:thirdCell.contentLab.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请选择所在地区"];
        return;
    }
    
    NSIndexPath *fouthIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    ZXAddressInfoDetailCell *fouthCell = [self.addTable cellForRowAtIndexPath:fouthIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:fouthCell.detailTextView.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入详细地址"];
        return;
    }
    
    NSIndexPath *fifthIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    ZXAddressInfoCell *fifthCell = [self.addTable cellForRowAtIndexPath:fifthIndex];
    NSString *isDef;
    if ([fifthCell.defaultSwitch isOn]) {
        isDef = @"1";
    } else {
        isDef = @"2";
    }
    
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXAddrInfoHelper sharedInstance] fetchAddrInfoWithAct:@"save" andId:@"0" andRealName:firstCell.contentTextField.text andTel:secCell.contentTextField.text andProv_id:_prov_id andCity_id:_city_id andArea_id:_area_id andStreer_id:_street_id andAddress:fouthCell.detailTextView.text andIs_def:isDef Completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            if (self.zxAddAddressVCBlcok) {
                self.zxAddAddressVCBlcok();
            }
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
        cell.zxAddressInfoDetailCellLayouBlock = ^{
            [self.addTable beginUpdates];
            [self.addTable endUpdates];
        };
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
            if (indexPath.row != 2) {
                [cell.arrowImg setHidden:YES];
            } else {
                [cell.arrowImg setHidden:NO];
            }
        } else {
            [cell.defaultSwitch setHidden:NO];
            [cell.arrowImg setHidden:YES];
        }
        if (indexPath.row == 1) {
            [cell.contentTextField setKeyboardType:UIKeyboardTypePhonePad];
        }
        if (indexPath.row == 2 || indexPath.row == 4) {
            [cell.contentTextField setUserInteractionEnabled:NO];
        } else {
            [cell.contentTextField setUserInteractionEnabled:YES];
        }
        if (indexPath.row == 2) {
            if ([UtilsMacro whetherIsEmptyWithObject:_address]) {
                [cell.contentTextField setPlaceholder:@"所在地区"];
            } else {
                [cell.contentTextField setPlaceholder:@""];
            }

            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.alignment = NSTextAlignmentLeft;
            paraStyle.lineSpacing = 8.0;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSParagraphStyleAttributeName:paraStyle};
            
            [cell.contentLab setAttributedText:[[NSAttributedString alloc] initWithString:_address attributes:dic]];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                ZXAddressPicker *addressPicker = [[ZXAddressPicker alloc] init];
                [addressPicker setProvidesPresentationContextTransitionStyle:YES];
                [addressPicker setDefinesPresentationContext:YES];
                [addressPicker setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                if (![UtilsMacro whetherIsEmptyWithObject:self.proPcasJosn]) {
                    [addressPicker setProPcasJosn:self.proPcasJosn];
                }
                if (![UtilsMacro whetherIsEmptyWithObject:self.cityPcasJosn]) {
                    [addressPicker setCityPcasJosn:self.cityPcasJosn];
                }
                if (![UtilsMacro whetherIsEmptyWithObject:self.areaPcasJosn]) {
                    [addressPicker setAreaPcasJosn:self.areaPcasJosn];
                }
                if (![UtilsMacro whetherIsEmptyWithObject:self.streetPcasJosn]) {
                    [addressPicker setStreetPcasJosn:self.streetPcasJosn];
                }
                addressPicker.zxAddressPickerResult = ^(ZXPcasJson * _Nullable proJson, ZXPcasJson * _Nullable cityJson, ZXPcasJson * _Nullable areaJson, ZXPcasJson * _Nullable streetJson) {
                    self.address = @"";
                    if ([UtilsMacro whetherIsEmptyWithObject:proJson]) {
                        self.prov_id = @"";
                        self.address = @"";
                    } else {
                        self.prov_id = proJson.pcid;
                        self.address = proJson.n;
                        self.proPcasJosn = proJson;
                    }
                    if ([UtilsMacro whetherIsEmptyWithObject:cityJson]) {
                        self.city_id = @"";
                    } else {
                        self.city_id = cityJson.pcid;
                        self.address = [NSString stringWithFormat:@"%@,%@", self.address, cityJson.n];
                        self.cityPcasJosn = cityJson;
                        if (self.cityPcasJosn.t == 4) {
                            if ([UtilsMacro whetherIsEmptyWithObject:areaJson]) {
                                self.area_id = @"";
                                self.street_id = @"";
                            } else {
                                self.area_id = @"";
                                self.street_id = areaJson.pcid;
                                self.address = [NSString stringWithFormat:@"%@,%@", self.address, areaJson.n];
                                self.area_id = nil;
                                self.streetPcasJosn = areaJson;
                            }
                        } else {
                            if ([UtilsMacro whetherIsEmptyWithObject:areaJson]) {
                                self.area_id = @"";
                            } else {
                                self.area_id = areaJson.pcid;
                                self.address = [NSString stringWithFormat:@"%@,%@", self.address, areaJson.n];
                                self.areaPcasJosn = areaJson;
                            }
                            if ([UtilsMacro whetherIsEmptyWithObject:streetJson]) {
                                self.street_id = @"";
                            } else {
                                self.street_id = streetJson.pcid;
                                self.address = [NSString stringWithFormat:@"%@,%@", self.address, streetJson.n];
                                self.streetPcasJosn = streetJson;
                            }
                        }
                    }
                    [self.addTable reloadData];
                };
                [self presentViewController:addressPicker animated:YES completion:nil];
            });
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

- (void)addressInfoDetailCellTextViewDidChange:(UITextView *)textView {
    [self.addTable beginUpdates];
    [self.addTable endUpdates];
}

#pragma mark - ZHFAddTitleAddressViewDelegate

- (void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID {
    _address = titleAddress;
    [self.addTable reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//    [self.addressTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSArray *idList = [[NSArray alloc] initWithArray:[titleID componentsSeparatedByString:@","]];
    if ([idList count] > 0) {
        _prov_id = [idList objectAtIndex:0];
    } else {
        _prov_id = @"";
        _city_id = @"";
        _area_id = @"";
        _street_id = @"";
    }
    
    if ([idList count] > 1) {
        _city_id = [idList objectAtIndex:1];
    } else {
        _city_id = @"";
        _area_id = @"";
        _street_id = @"";
    }
    
    if ([idList count] > 2) {
        _area_id = [idList objectAtIndex:2];
    } else {
        _area_id = @"";
        _street_id = @"";
    }
    
    if ([idList count] > 3) {
        _street_id = [idList objectAtIndex:3];
    } else {
        _street_id = @"";
    }
}

@end
