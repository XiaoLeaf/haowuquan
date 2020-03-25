//
//  ZXEditAddressVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXEditAddressVC.h"
#import "ZXAddressInfoCell.h"
#import "ZHFAddTitleAddressView.h"
#import "ZXAddressInfoDetailCell.h"

@interface ZXEditAddressVC () <UITableViewDelegate, UITableViewDataSource, ZHFAddTitleAddressViewDelegate, ZXAddressInfoDetailCellDelegate>

@property (strong, nonatomic) ZHFAddTitleAddressView *addressView;

@property (strong, nonatomic) NSArray *placeHolderList;

@property (assign, nonatomic) CGFloat safeHeight;

@property (strong, nonatomic) ZXPcasJson *proPcasJosn;

@property (strong, nonatomic) ZXPcasJson *cityPcasJosn;

@property (strong, nonatomic) ZXPcasJson *areaPcasJosn;

@property (strong, nonatomic) ZXPcasJson *streetPcasJosn;

@end

@implementation ZXEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.editTable setEstimatedRowHeight:50.0];
    [self.editTable setRowHeight:UITableViewAutomaticDimension];
    [self setTitle:@"编辑地址" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self setRightBtnTitle:@"保存" target:self action:@selector(handleTapRightBtnAction)];
    _placeHolderList = @[@"请添加收货人姓名", @"请输入手机号码", @"所在地区", @"请输入详细地址", @"设置默认地址"];
    [self.editTable setTableFooterView:[UIView new]];
    [self fetchCurrentPcasJsons];
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
    ZXAddressInfoCell *firstCell = [self.editTable cellForRowAtIndexPath:firstIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:firstCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入收货人姓名"];
        return;
    }
    
    NSIndexPath *secIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    ZXAddressInfoCell *secCell = [self.editTable cellForRowAtIndexPath:secIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:secCell.contentTextField.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入手机号码"];
        return;
    }
    
    NSIndexPath *thirdIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    ZXAddressInfoCell *thirdCell = [self.editTable cellForRowAtIndexPath:thirdIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:thirdCell.contentLab.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请选择所在地区"];
        return;
    }
    
    NSIndexPath *fouthIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    ZXAddressInfoDetailCell *fouthCell = [self.editTable cellForRowAtIndexPath:fouthIndex];
    if ([UtilsMacro whetherIsEmptyWithObject:fouthCell.detailTextView.text]) {
        [ZXProgressHUD loadFailedWithMsg:@"请输入详细地址"];
        return;
    }
    
    NSIndexPath *fifthIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    ZXAddressInfoCell *fifthCell = [self.editTable cellForRowAtIndexPath:fifthIndex];
    NSString *isDef;
    if ([fifthCell.defaultSwitch isOn]) {
        isDef = @"1";
    } else {
        isDef = @"2";
    }
    
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXAddrInfoHelper sharedInstance] fetchAddrInfoWithAct:@"save" andId:_editItem.addrId andRealName:firstCell.contentTextField.text andTel:secCell.contentTextField.text andProv_id:_editItem.prov_id andCity_id:_editItem.city_id andArea_id:_editItem.area_id andStreer_id:_editItem.street_id andAddress:fouthCell.detailTextView.text andIs_def:isDef Completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadSucceedWithMsg:response.info];
            [ZXProgressHUD hideAllHUD];
            if (self.zxEditAddressVCBlcok) {
                self.zxEditAddressVCBlcok();
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

- (void)fetchCurrentPcasJsons {
    //从本地json读取数据 650000 659006 659006101
//    [_addrItem setArea_id:@"659006101"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"tpcs" ofType:@"json"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:imagePath encoding:NSUTF8StringEncoding error:nil];
    NSData * resData = [[NSData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray *proList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArr count]; i++) {
        ZXPcasJson *pcasJson = [ZXPcasJson yy_modelWithJSON:[resultArr objectAtIndex:i]];
        [proList addObject:pcasJson];
    }
    for (ZXPcasJson *subJson in proList) {
        if ([subJson.pcid longLongValue] == [_editItem.prov_id longLongValue]) {
            _proPcasJosn = subJson;
            for (ZXPcasJson *cityJson in _proPcasJosn.c) {
                if ([cityJson.pcid longLongValue] == [_editItem.city_id longLongValue]) {
                    _cityPcasJosn = cityJson;
                    for (ZXPcasJson *areaJson in _cityPcasJosn.c) {
                        if (_cityPcasJosn.t == 4) {
                            if ([areaJson.pcid longLongValue] == [_editItem.street_id longLongValue]) {
                                _streetPcasJosn = areaJson;
                                break;
                            }
                        } else {
                            if ([areaJson.pcid longLongValue] == [_editItem.area_id longLongValue]) {
                                _areaPcasJosn = areaJson;
                                for (ZXPcasJson *streetJson in _areaPcasJosn.c) {
                                    if ([streetJson.pcid longLongValue] == [_editItem.street_id longLongValue]) {
                                        _streetPcasJosn = streetJson;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
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
        if ([UtilsMacro whetherIsEmptyWithObject:_editItem.address]) {
            [cell.placeTextField setPlaceholder:@"请输入详细地址"];
        } else {
            [cell.placeTextField setPlaceholder:@""];
        }
        [cell.detailTextView setText:_editItem.address];
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
        cell.zxAddressInfoCellTFEdited = ^(NSInteger cellTag, ZXAddressInfoCell * _Nonnull infoCell) {
            switch (cellTag) {
                case 0:
                    [self.editItem setRealname:infoCell.contentTextField.text];
                    break;
                case 1:
                    [self.editItem setTel:infoCell.contentTextField.text];
                    break;
                    
                default:
                    break;
            }
        };
        cell.zxAddressInfoCellSwitchValueChanged = ^(BOOL isOn) {
            if (isOn) {
                [self.editItem setIs_def:@"1"];
            } else {
                [self.editItem setIs_def:@"2"];
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
                [cell setContentStr:_editItem.realname];
                break;
            case 1:
                [cell setContentStr:_editItem.tel];
                break;
            case 2:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:_editItem.pcas]) {
                    [cell.contentTextField setPlaceholder:@"所在地区"];
                } else {
                    [cell.contentTextField setPlaceholder:@""];
                }
                [cell.contentLab setText:_editItem.pcas];
            }
                break;
            case 4:
            {
                if ([_editItem.is_def integerValue] == 1) {
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
                    NSString *address;
                    if ([UtilsMacro whetherIsEmptyWithObject:proJson]) {
                        self.editItem.prov_id = @"";
                        address = @"";
                    } else {
                        self.editItem.prov_id = proJson.pcid;
                        address = proJson.n;
                        self.proPcasJosn = proJson;
                    }
                    if ([UtilsMacro whetherIsEmptyWithObject:cityJson]) {
                        self.editItem.city_id = @"";
                    } else {
                        self.editItem.city_id = cityJson.pcid;
                        address = [NSString stringWithFormat:@"%@,%@", address, cityJson.n];
                        self.cityPcasJosn = cityJson;
                        if (self.cityPcasJosn.t == 4) {
                            if ([UtilsMacro whetherIsEmptyWithObject:areaJson]) {
                                self.editItem.street_id = @"";
                                self.editItem.area_id = @"";
                            } else {
                                self.editItem.area_id = @"";
                                self.areaPcasJosn = nil;
                                self.editItem.street_id = areaJson.pcid;
                                address = [NSString stringWithFormat:@"%@,%@", address, areaJson.n];
                                self.streetPcasJosn = areaJson;
                            }
                        } else {
                            if ([UtilsMacro whetherIsEmptyWithObject:areaJson]) {
                                self.editItem.area_id = @"";
                            } else {
                                self.editItem.area_id = areaJson.pcid;
                                address = [NSString stringWithFormat:@"%@,%@", address, areaJson.n];
                                self.areaPcasJosn = areaJson;
                            }
                            if ([UtilsMacro whetherIsEmptyWithObject:streetJson]) {
                                self.editItem.street_id = @"";
                            } else {
                                self.editItem.street_id = streetJson.pcid;
                                address = [NSString stringWithFormat:@"%@,%@", address, streetJson.n];
                                self.streetPcasJosn = streetJson;
                            }
                        }
                    }
                    [self.editItem setPcas:address];
                    [self.editTable reloadData];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TEST_ADD" object:nil];
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

- (void)addressInfoDetailCellTextViewDidChange:(YYTextView *)textView {
    [_editItem setAddress:textView.text];
    [self.editTable beginUpdates];
    [self.editTable endUpdates];
}

#pragma mark - ZHFAddTitleAddressViewDelegate

- (void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID {
    [_editItem setPcas:titleAddress];
    [self.editTable reloadData];
    NSArray *idList = [[NSArray alloc] initWithArray:[titleID componentsSeparatedByString:@","]];
    if ([idList count] > 0) {
        [_editItem setProv_id:[idList objectAtIndex:0]];
    } else {
        [_editItem setProv_id:@""];
        [_editItem setCity_id:@""];
        [_editItem setArea_id:@""];
        [_editItem setStreet_id:@""];
    }
    
    if ([idList count] > 1) {
        [_editItem setCity_id:[idList objectAtIndex:1]];
    } else {
        [_editItem setCity_id:@""];
        [_editItem setArea_id:@""];
        [_editItem setStreet_id:@""];
    }
    
    if ([idList count] > 2) {
        [_editItem setArea_id:[idList objectAtIndex:2]];
    } else {
        [_editItem setArea_id:@""];
        [_editItem setStreet_id:@""];
    }
    
    if ([idList count] > 3) {
        [_editItem setStreet_id:[idList objectAtIndex:3]];
    } else {
        [_editItem setStreet_id:@""];
    }
}

@end
