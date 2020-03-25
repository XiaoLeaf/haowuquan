//
//  ZXSearchViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/7/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchViewController.h"
#import "ZXSearchCell.h"
#import "ZXSearchHeaderView.h"
#import "ZXSearchNewHeader.h"
#import "ZXSearchResultViewController.h"
#import <UICollectionViewLeftAlignedLayout/UICollectionViewLeftAlignedLayout.h>
#import <Masonry/Masonry.h>

@interface ZXSearchViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ZXSearchHeaderViewDelegate, UITextFieldDelegate> {
    NSMutableArray *historyList;
    NSString *searchStr;
    BOOL isEditing;
}

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) NSString *moreStr;

@property (strong, nonatomic) ZXSearchInit *searchInit;

@property (strong, nonatomic) ZXSearchHeaderView *hotHeader;

@end

@implementation ZXSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor:BG_COLOR];
    [self createCustomNav];
    _moreStr = @"0";
    [self refreshSearchInitInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isEditing = YES;
    if (searchStr) {
        [_customNav.searchTextField setText:searchStr];
    }
    [_customNav.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_customNav.searchTextField.isFirstResponder) {
        [_customNav.searchTextField resignFirstResponder];
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

- (void)createCustomNav {
    __weak typeof(self) weakSelf = self;
    _customNav = [[ZXCustomNavView alloc] initWithSearchTFAndCancelBtn];
    [_customNav setBackgroundColor:BG_COLOR];
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [_customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    [_customNav.searchTextField setDelegate:self];
    [_customNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(NAVIGATION_HEIGHT + STATUS_HEIGHT);
    }];
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _searchColl = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _searchColl.showsVerticalScrollIndicator = NO;
    _searchColl.showsHorizontalScrollIndicator = NO;
    [_searchColl setBackgroundColor:UIColor.clearColor];
    [_searchColl registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSearchCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXSearchCell"];
    [_searchColl registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSearchHeaderView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXSearchHeaderView"];
    [_searchColl registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSearchNewHeader class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXSearchNewHeader"];
    [self.view addSubview:_searchColl];
    [_searchColl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0);
        make.bottom.mas_equalTo(0.0);
        make.right.mas_equalTo(-15.0);
        make.top.mas_equalTo(self.customNav.mas_bottom);
    }];
}

- (void)refreshSearchInitInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXSearchInitHelper sharedInstance] fetchSearchInitWithMore:_moreStr completion:^(ZXResponse * _Nonnull response) {
//            NSLog(@"response:%@",response.data);
            [ZXProgressHUD hideAllHUD];
            self.searchInit = [ZXSearchInit yy_modelWithJSON:response.data];
            if (!self.searchColl.delegate) {
                [self.searchColl setDelegate:self];
            }
            if (!self.searchColl.dataSource) {
                [self.searchColl setDataSource:self];
            }
            self->historyList = [[NSMutableArray alloc] initWithArray:[[ZXDatabaseUtil sharedDataBase] selectSearchHistory]];
            [self.searchColl reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return [_searchInit.keywords count];
            break;
        case 2:
            return [historyList count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 14.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 14.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return CGSizeZero;
        case 1:
        {
            ZXSearchKeyword *keyword = (ZXSearchKeyword *)[_searchInit.keywords objectAtIndex:indexPath.row];
            CGFloat width = [UtilsMacro widthForString:keyword.val font:[UIFont systemFontOfSize:13.0] andHeight:26.0] + 20.0;
            if (width > SCREENWIDTH - 30.0) {
                width = SCREENWIDTH - 30.0;
            }
            return CGSizeMake(width, 26.0);
        }
            break;
        case 2:
        {
            CGFloat width = [UtilsMacro widthForString:[historyList objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:13.0] andHeight:26.0] + 20.0;
            if (width > SCREENWIDTH - 30.0) {
                width = SCREENWIDTH - 30.0;
            }
            return CGSizeMake(width, 26.0);
        }
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return CGSizeMake(SCREENWIDTH - 30.0, (SCREENWIDTH - 30.0) * 0.19 + 15.0);
        }
            break;
        case 1:
        {
            return CGSizeMake(SCREENWIDTH - 30.0, 60.0);
        }
            break;
        case 2:
        {
            if ([historyList count] > 0) {
                return CGSizeMake(SCREENWIDTH - 30.0, 60.0);
            } else {
                return CGSizeZero;
            }
        }
            break;
            
        default:
            return CGSizeZero;
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            ZXSearchNewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXSearchNewHeader" forIndexPath:indexPath];
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_searchInit.banner.img] imageView:headerView.headerImg placeholderImage:nil options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSLog(@"image:%@",image);
            }];
            headerView.zxSearchNewHeaderImgClick = ^{
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, self.searchInit.banner.url_schema] andUserInfo:nil viewController:self];
            };
            return headerView;
        } else if (indexPath.section == 1) {
            _hotHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXSearchHeaderView" forIndexPath:indexPath];
            [_hotHeader.titleLabel setText:@"热门搜索"];
            [_hotHeader.deleteBtn setHidden:YES];
            [_hotHeader setBackgroundColor:BG_COLOR];
            [_hotHeader.replaceBtn setHidden:NO];
            [_hotHeader.replaceBtn.imageView.layer removeAllAnimations];
            __weak typeof(self) weakSelf = self;
            _hotHeader.zxSearchHeaderViewReplaceClick = ^{
                [UtilsMacro addRotationAnimationWithFrom:@0.0 toValue:@(M_PI * 2) view:weakSelf.hotHeader.replaceBtn.imageView duration:0.4];
//                [ZXProgressHUD loadingNoMask];
                weakSelf.moreStr = @"1";
                [weakSelf refreshSearchInitInfo];
            };
            return _hotHeader;
        } else {
            if ([historyList count] > 0) {
                ZXSearchHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXSearchHeaderView" forIndexPath:indexPath];
                [headerView setDelegate:self];
                [headerView.titleLabel setText:@"历史搜索"];
                [headerView.deleteBtn setHidden:NO];
                [headerView.replaceBtn setHidden:YES];
                [headerView setBackgroundColor:BG_COLOR];
                return headerView;
            } else {
                return nil;
            }
        }
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXSearchCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            ZXSearchKeyword *keyword = (ZXSearchKeyword *)[_searchInit.keywords objectAtIndex:indexPath.row];
            [cell.nameLabel setText:keyword.val];
            [cell.nameLabel setTextColor:[UtilsMacro colorWithHexString:keyword.color]];
        }
            break;
        case 2:
        {
            [cell.nameLabel setText:[historyList objectAtIndex:indexPath.row]];
            [cell.nameLabel setTextColor:COLOR_666666];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            ZXSearchKeyword *keyword = (ZXSearchKeyword *)[self.searchInit.keywords objectAtIndex:indexPath.row];
            searchStr = keyword.val;
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, keyword.url_schema] andUserInfo:nil viewController:self];
        }
            break;
        case 2:
        {
            searchStr = [historyList objectAtIndex:indexPath.row];
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@?params={\"keyword\":\"%@\"}", URL_PREFIX, SEARCH_RESULT_VC, [historyList objectAtIndex:indexPath.row]] andUserInfo:nil viewController:self];
        }
            break;
            
        default:
            break;
    }
    [[ZXDatabaseUtil sharedDataBase] insertHistory:searchStr];
    historyList = [[NSMutableArray alloc] initWithArray:[[ZXDatabaseUtil sharedDataBase] selectSearchHistory]];
    [self.searchColl reloadData];
}

#pragma mark - ZXSearchHeaderViewDelegate

- (void)searchHeaderViewHandleTapDeleteBtn {
    if (isEditing) {
        [_customNav.searchTextField resignFirstResponder];
        isEditing = NO;
        return;
    }
    UIAlertController *delAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认清除所有搜索历史？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ZXDatabaseUtil sharedDataBase] clearSearchHistory];
        self->historyList = [[NSMutableArray alloc] init];
        [self.searchColl reloadData];
    }];
    [delAlert addAction:cancel];
    [delAlert addAction:confirm];
    [self presentViewController:delAlert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    isEditing = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    isEditing = NO;
    NSString *tempStr = textField.text;
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([UtilsMacro whetherIsEmptyWithObject:tempStr]) {
        return NO;
    }
    [_customNav.searchTextField resignFirstResponder];
    ZXSearchResultViewController *searchResult = [[ZXSearchResultViewController alloc] init];
    [searchResult setTitleStr:tempStr];
    [searchResult setFromType:1];
    searchStr = tempStr;
    
    __weak typeof(self) weakSelf = self;
    searchResult.zxSearchResultVCChangeSearchHisBlock = ^(NSString * _Nonnull content) {
        self->historyList = [[NSMutableArray alloc] initWithArray:[[ZXDatabaseUtil sharedDataBase] selectSearchHistory]];
        [weakSelf.searchColl reloadData];
        self->searchStr = content;
    };
    [self.navigationController pushViewController:searchResult animated:YES];

    [[ZXDatabaseUtil sharedDataBase] insertHistory:tempStr];
    historyList = [[NSMutableArray alloc] initWithArray:[[ZXDatabaseUtil sharedDataBase] selectSearchHistory]];
    [self.searchColl reloadData];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    isEditing = NO;
}

@end
