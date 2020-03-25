//
//  ZXPersonalViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPersonalViewController.h"
#import "ZXMyEditViewController.h"
#import "ZXPersonalCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+JKRImage.h"

@interface ZXPersonalViewController () <UITableViewDelegate, UITableViewDataSource, ZXPersonalCellDelegate, ZXPhotoUtilDelegate> {
    NSArray *personalList;
    NSMutableArray *browserList;
}

@end

@implementation ZXPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    [self.personalTableView setTableFooterView:[UIView new]];
    [self setTitle:@"个人资料" font:TITLE_FONT color:HOME_TITLE_COLOR];
    personalList = @[@[@"头像", @"昵称", @"生日", @"性别", @"微信号", @"加入时间", @"个人简介"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
    [self.personalTableView reloadData];
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

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [personalList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[personalList objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXPersonalCell";
    ZXPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXPersonalCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        [cell.contentLabel setHidden:YES];
        [cell.arrowImg setHidden:YES];
        [cell.headImage setHidden:NO];
        if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] icon]]) {
            [cell.headImage setImage:DEFAULT_HEAD_IMG];
        } else {
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[[[ZXMyHelper sharedInstance] userInfo] icon]] imageView:cell.headImage placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
        }
    } else {
        [cell.contentLabel setHidden:NO];
        [cell.arrowImg setHidden:NO];
        [cell.headImage setHidden:YES];
        cell.contentRight.constant = 8.0;
        switch (indexPath.row) {
            case 1:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] nickname]]) {
                    [cell.contentLabel setText:@"请填写昵称"];
                } else {
                    [cell.contentLabel setText:[[[ZXMyHelper sharedInstance] userInfo] nickname]];
                }
            }
                break;
            case 2:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] birthday]]) {
                    [cell.contentLabel setText:@"请选择生日"];
                } else {
                    [cell.contentLabel setText:[[[ZXMyHelper sharedInstance] userInfo] birthday]];
                }
            }
                break;
            case 3:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] gender]]) {
                    [cell.contentLabel setText:@"请选择性别"];
                } else {
                    for (ZXUserGender *userGender in [[[ZXMyHelper sharedInstance] userInfo] gender_arr]) {
                        if ([userGender.key integerValue] == [[[[ZXMyHelper sharedInstance] userInfo] gender] integerValue]) {
                            [cell.contentLabel setText:userGender.val];
                            break;
                        }
                    }
                }
            }
                break;
            case 4:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] wx]]) {
                    [cell.contentLabel setText:@"输入微信号"];
                } else {
                    [cell.contentLabel setText:[[[ZXMyHelper sharedInstance] userInfo] wx]];
                }
            }
                break;
            case 5:
            {
                cell.contentRight.constant = -15.0;
                [cell.arrowImg setHidden:YES];
                if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] reg_time]]) {
                    [cell.contentLabel setText:@""];
                } else {
                    [cell.contentLabel setText:[[[ZXMyHelper sharedInstance] userInfo] reg_time]];
                }
            }
                break;
            case 6:
            {
                if ([UtilsMacro whetherIsEmptyWithObject:[[[ZXMyHelper sharedInstance] userInfo] intro]]) {
                    [cell.contentLabel setText:@"去填写"];
                } else {
                    [cell.contentLabel setText:[[[ZXMyHelper sharedInstance] userInfo] intro]];
                }
            }
                break;
                
            default:
                break;
        }
    }
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@",[[personalList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *headAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ZXPhotoUtil sharedInstance] takePhotoWithViewController:self delegate:self];
                });
            }];
            UIAlertAction *library = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[ZXPhotoUtil sharedInstance] zlSelectPhotoWithMax:1 WithViewController:self delegate:self];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [headAlert addAction:camera];
            [headAlert addAction:library];
            [headAlert addAction:cancel];
            [self presentViewController:headAlert animated:YES completion:nil];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (indexPath.row != 1 && indexPath.row != 4 && indexPath.row != 6) {
                switch (indexPath.row) {
                    case 2:
                    {
                        [UtilsMacro openZXDatePickerWithViewController:self datePickerResultBlock:^(NSString * _Nonnull resultStr) {
                            if ([UtilsMacro isCanReachableNetWork]) {
                                [ZXProgressHUD loadingNoMask];
                                [[ZXSettingHelper sharedInstance] fetchSettingWithType:@"5" andVal:resultStr completion:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                                    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                                    [userInfo setBirthday:resultStr];
                                    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                                    [self.personalTableView reloadData];
                                } error:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadFailedWithMsg:response.info];
                                    return;
                                }];
                            } else {
                                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                                return;
                            }
                        }];
                    }
                        break;
                    case 3:
                    {
                        NSMutableArray *actionList = [[NSMutableArray alloc] init];
                        for (int i = 0; i < [[[[ZXMyHelper sharedInstance] userInfo] gender_arr] count]; i++) {
                            ZXUserGender *userGender = (ZXUserGender *)[[[[ZXMyHelper sharedInstance] userInfo] gender_arr] objectAtIndex:i];
                            [actionList addObject:userGender.val];
                        }
                        UIAlertController *genderAlert = [UtilsMacro zxAlertControllerWithTitle:@"性别" andMessage:nil style:UIAlertControllerStyleActionSheet andAction:actionList alertActionClicked:^(NSInteger actionTag) {
                            ZXUserGender *userGender = (ZXUserGender *)[[[[ZXMyHelper sharedInstance] userInfo] gender_arr] objectAtIndex:actionTag];
                            if ([UtilsMacro isCanReachableNetWork]) {
                                [ZXProgressHUD loadingNoMask];
                                [[ZXSettingHelper sharedInstance] fetchSettingWithType:@"6" andVal:userGender.key completion:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                                    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                                    [userInfo setGender:userGender.key];
                                    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                                    [self.personalTableView reloadData];
                                } error:^(ZXResponse * _Nonnull response) {
                                    [ZXProgressHUD loadFailedWithMsg:response.info];
                                    return;
                                }];
                            } else {
                                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                                return;
                            }
                        }];
                        [self presentViewController:genderAlert animated:YES completion:nil];
                    }
                        break;
                        
                    default:
                        break;
                }
            } else {
                ZXMyEditViewController *myEdit = [[ZXMyEditViewController alloc] init];
                if (indexPath.row == 1) {
                    [myEdit setType:indexPath.row];
                } else {
                    switch (indexPath.row) {
                        case 4:
                            [myEdit setType:4];
                            break;
                        case 6:
                            [myEdit setType:3];
                            break;
                            
                        default:
                            break;
                    }
                }
                [myEdit setTitleStr:[NSString stringWithFormat:@"%@",[[self->personalList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
                UINavigationController *myEditNavi = [[UINavigationController alloc] initWithRootViewController:myEdit];
                [myEditNavi setModalPresentationStyle:UIModalPresentationFullScreen];
                [self.navigationController presentViewController:myEditNavi animated:YES completion:nil];
            }
        });
    }
}

#pragma mark - ZXPersonalCellDelegate

- (void)personalCellHandleTapHeadImgAction {
    NSArray *imgList = [[NSArray alloc] initWithObjects:[[[ZXMyHelper sharedInstance] userInfo] icon], nil];
//    NSArray *imgList = @[@"http://img5q.duitang.com/uploads/item/201504/10/20150410H4043_RXBYn.jpeg", @"http://img5q.duitang.com/uploads/item/201504/10/20150410H4043_RXBYn.jpeg", @"http://img5q.duitang.com/uploads/item/201504/10/20150410H4043_RXBYn.jpeg"];
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:0 andThumdList:@[]];
}

#pragma mark - ZXPhotoUtilDelegate

- (void)zxPhotoUtilImagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *resultImg = [info valueForKey:UIImagePickerControllerOriginalImage];
    [resultImg jkr_compressToDataLength:IMAGE_DATA_LENGTH withBlock:^(NSData *data) {
        NSString *imgBase64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UtilsMacro isCanReachableNetWork]) {
                [ZXProgressHUD loadingNoMask];
                [[ZXSettingHelper sharedInstance] fetchSettingWithType:@"2" andVal:imgBase64 completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD hideAllHUD];
                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                    ZXSettingRes *settingRes = [ZXSettingRes yy_modelWithJSON:response.data];
                    if ([UtilsMacro whetherIsEmptyWithObject:settingRes.val]) {
                        [userInfo setIcon:@""];
                    } else {
                        [userInfo setIcon:settingRes.val];
                    }
                    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.personalTableView reloadData];
                    });
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                    return;
                }];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        });
    }];
}

- (void)zlPhotoActionCancel:(ZLPhotoActionSheet *)photoActionSheet {
//    NSLog(@"ZL取消选择照片");
}

- (void)zlPhotoActionFinished:(ZLPhotoActionSheet *)photoActionSheet images:(NSArray<UIImage *> *)images asstes:(NSArray<PHAsset *> *)assets isOriginal:(BOOL)isOriginal {
    UIImage *resultImg = [images objectAtIndex:0];
    [resultImg jkr_compressToDataLength:IMAGE_DATA_LENGTH withBlock:^(NSData *data) {
        NSString *imgBase64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([UtilsMacro isCanReachableNetWork]) {
                [ZXProgressHUD loadingNoMask];
                [[ZXSettingHelper sharedInstance] fetchSettingWithType:@"2" andVal:imgBase64 completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD hideAllHUD];
                    [ZXProgressHUD loadSucceedWithMsg:response.info];
                    ZXUser *userInfo = [[ZXMyHelper sharedInstance] userInfo];
                    ZXSettingRes *settingRes = [ZXSettingRes yy_modelWithJSON:response.data];
                    if ([UtilsMacro whetherIsEmptyWithObject:settingRes.val]) {
                        [userInfo setIcon:@""];
                    } else {
                        [userInfo setIcon:settingRes.val];
                    }
                    [[ZXMyHelper sharedInstance] setUserInfo:userInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.personalTableView reloadData];
                    });
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                    return;
                }];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        });
    }];
}

- (void)zxPhotoUtilImagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
