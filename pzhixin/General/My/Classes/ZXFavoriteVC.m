//
//  ZXFavoriteVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFavoriteVC.h"
#import "ZXFavoriteCell.h"
#import "ZXFavoriteHeaderView.h"
#import "ZXFavoritePickCell.h"
#import "ZXFavoritePickHeaderView.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "ZXGoodsDetailVC.h"

@interface ZXFavoriteVC () <UITableViewDelegate, UITableViewDataSource, ZXFavoritePickCellDelegate, ZXFavoritePickHeaderViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (assign, nonatomic) BOOL isPick;

@property (strong, nonatomic) NSMutableArray *deleteIds;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) UIButton *allPickBtn;

@property (strong, nonatomic) UIButton *deleteBtn;

@property (strong, nonatomic) UIView *toolView;

@property (assign, nonatomic) CGFloat bottomHeight;

@property (strong, nonatomic) NSMutableArray *favoriteList;

@property (assign, nonatomic) NSInteger deleteIndex;

@property (assign, nonatomic) NSInteger page;

@end

@implementation ZXFavoriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor:BG_COLOR];
    // Do any additional setup after loading the view from its nib.
    _isPick = NO;
    
    __weak typeof(self) weakSelf = self;
    _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:@"收藏夹" titleColor:HOME_TITLE_COLOR rightContent:nil leftDot:NO];
    _customNav.backgroundColor = BG_COLOR;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        weakSelf.isPick = !weakSelf.isPick;
        weakSelf.deleteIds = [[NSMutableArray alloc] init];
        [weakSelf.allPickBtn setSelected:NO];
        for (ZXFavorite *favorite in weakSelf.favoriteList) {
            [favorite setIsSelected:NO];
        }
        if (weakSelf.isPick) {
            [weakSelf.customNav setRightContent:@"完成"];
            [weakSelf.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
            [weakSelf.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50.0);
                    } else {
                        // Fallback on earlier versions
                        make.bottom.mas_equalTo(weakSelf.view);
                    }
                }];
                [weakSelf.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).mas_offset(0.0);
                    } else {
                        // Fallback on earlier versions
                        make.bottom.mas_equalTo(weakSelf.view).mas_offset(0.0);
                    }
                }];
            }];
        } else {
            [weakSelf.customNav setRightContent:@"管理"];
            [weakSelf.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        // Fallback on earlier versions
                        make.bottom.mas_equalTo(weakSelf.view);
                    }
                }];
                [weakSelf.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).mas_offset(weakSelf.bottomHeight + 50.0);
                    } else {
                        // Fallback on earlier versions
                        make.bottom.mas_equalTo(weakSelf.view).mas_offset(50.0);
                    }
                }];
            }];
        }
        [weakSelf.favoriteTableView reloadData];
    };
    [self.view addSubview:_customNav];
    
    _favoriteTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_favoriteTableView setShowsVerticalScrollIndicator:NO];
    [_favoriteTableView setShowsVerticalScrollIndicator:NO];
    [_favoriteTableView setDelegate:self];
    [_favoriteTableView setDataSource:self];
    [_favoriteTableView setEmptyDataSetDelegate:self];
    [_favoriteTableView setEmptyDataSetSource:self];
    [_favoriteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_favoriteTableView setBackgroundColor:[UIColor clearColor]];
    [_favoriteTableView setEstimatedRowHeight:116.0];
    [self.view addSubview:_favoriteTableView];
    [_favoriteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.customNav.mas_bottom);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            // Fallback on earlier versions
            make.top.mas_equalTo(self.customNav.mas_bottom);
            make.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
        }
    }];
    
    ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFavoriteList)];
    [refreshHeader.stateLab setTextColor:COLOR_999999];
    _favoriteTableView.mj_header = refreshHeader;
    
    _favoriteTableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[ZXFavoriteCell class] cellHeight:116.0];
    [_favoriteTableView.mj_header beginRefreshing];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        _bottomHeight = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
        _bottomHeight = 0.0;
    }
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        [_toolView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_toolView];
        [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(self.bottomHeight + 50.0);
                make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
                make.height.mas_equalTo(50.0);
            } else {
                // Fallback on earlier versions
                make.bottom.mas_equalTo(self.view).mas_offset(50.0);
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.height.mas_equalTo(50.0);
            }
        }];
    }
    
    if (!_allPickBtn) {
        _allPickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allPickBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_allPickBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allPickBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_allPickBtn addTarget:self action:@selector(handleTapAllPickBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_allPickBtn setImage:[UIImage imageNamed:@"ic_favorite_pick_nor"] forState:UIControlStateNormal];
        [_allPickBtn setImage:[UIImage imageNamed:@"ic_favorite_pick_sel"] forState:UIControlStateSelected];
        [_allPickBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, -10.0)];
        [_toolView addSubview:_allPickBtn];
        [_allPickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.toolView);
            make.left.mas_equalTo(self.toolView).mas_offset(15.0);
            make.width.mas_equalTo(80.0);
            make.height.mas_equalTo(30.0);
        }];
    }
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundColor:THEME_COLOR];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_deleteBtn addTarget:self action:@selector(handleTapDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.toolView);
            make.right.mas_equalTo(self.toolView).offset(-15.0);
            make.width.mas_equalTo(80.0);
            make.height.mas_equalTo(30.0);
        }];
        [_deleteBtn.layer setCornerRadius:15.0];
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

#pragma mark - MJRefresh

- (void)refreshFavoriteList {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXFavoriteListHelper sharedInstance] fetchFavoriteListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(ZXResponse * _Nonnull response) {
            if ([self.favoriteTableView.mj_header isRefreshing]) {
                [self.favoriteTableView.mj_header endRefreshing];
            }
            [ZXProgressHUD hideAllHUD];
            if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.page++;
                if (!self.favoriteTableView.mj_footer) {
                    self.favoriteTableView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFavoriteList)];
                } else {
                    [self.favoriteTableView.mj_footer resetNoMoreData];
                }
            }
            
            self.favoriteList = [[NSMutableArray alloc] init];
            NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
            for (int i = 0; i < [resultList count]; i++) {
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                ZXFavorite *favorite = [ZXFavorite yy_modelWithDictionary:dict];
                [self.favoriteList addObject:favorite];
            }
            if ([self.favoriteList count] > 0) {
                [self.customNav setRightContent:@"管理"];
                [self.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
            } else {
                [self.customNav setRightContent:nil];
            }
            [self.favoriteTableView tab_endAnimation];
            [self.favoriteTableView reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.favoriteTableView.mj_header isRefreshing]) {
                [self.favoriteTableView.mj_header endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            if ([[response.data allKeys] count] <= 0) {
                [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
            }
            return;
        }];
    } else {
        if ([self.favoriteTableView.mj_header isRefreshing]) {
            [self.favoriteTableView.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreFavoriteList {
    [[ZXFavoriteListHelper sharedInstance] fetchFavoriteListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD hideAllHUD];
        if ([self.favoriteTableView.mj_footer isRefreshing]) {
            [self.favoriteTableView.mj_footer endRefreshing];
        }
        if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
            [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            self.page++;
            if (!self.favoriteTableView.mj_footer) {
                self.favoriteTableView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFavoriteList)];
            } else {
                [self.favoriteTableView.mj_footer resetNoMoreData];
            }
        }
        
        NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
        for (int i = 0; i < [resultList count]; i++) {
            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
            ZXFavorite *favorite = [ZXFavorite yy_modelWithDictionary:dict];
            [self.favoriteList addObject:favorite];
        }
        [self.favoriteTableView reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.favoriteTableView.mj_footer isRefreshing]) {
            [self.favoriteTableView.mj_footer endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:response.info];
        if ([[response.data allKeys] count] <= 0) {
            [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
        }
        return;
    }];
}

#pragma mark - Private Methods

- (void)manageFavoriteList {
    _isPick = !_isPick;
    _deleteIds = [[NSMutableArray alloc] init];
    [_allPickBtn setSelected:NO];
    for (ZXFavorite *favorite in _favoriteList) {
        [favorite setIsSelected:NO];
    }
    if (_isPick) {
        [self.customNav setRightContent:@"完成"];
        [self.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            [self->_favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50.0);
                } else {
                    // Fallback on earlier versions
                    make.bottom.mas_equalTo(self.view);
                }
            }];
            [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(0.0);
                } else {
                    // Fallback on earlier versions
                    make.bottom.mas_equalTo(self.view).mas_offset(0.0);
                }
            }];
        }];
    } else {
        [self.customNav setRightContent:@"管理"];
        [self.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            [self->_favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    // Fallback on earlier versions
                    make.bottom.mas_equalTo(self.view);
                }
            }];
            [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(self.bottomHeight + 50.0);
                } else {
                    // Fallback on earlier versions
                    make.bottom.mas_equalTo(self.view).mas_offset(50.0);
                }
            }];
        }];
    }
    [self.favoriteTableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_favoriteList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 36.0;
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 10.0;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
        [footerView setBackgroundColor:[UIColor clearColor]];
        return footerView;
    }
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除当前收藏商品？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UtilsMacro isCanReachableNetWork]) {
                [ZXProgressHUD loadingNoMask];
                ZXFavorite *favorite = (ZXFavorite *)[self.favoriteList objectAtIndex:indexPath.row];
                self.deleteIndex = indexPath.row;
                [[ZXDelFavoriteHelper sharedInstance] fetchDelFavoriteWithIds:favorite.zx_id completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD hideAllHUD];
                    [self.favoriteList removeObjectAtIndex:indexPath.row];
                    [self.favoriteTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    if ([self.favoriteList count] <= 0) {
                        [self.favoriteTableView reloadEmptyDataSet];
                        [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
                        self.favoriteTableView.mj_footer = nil;
                        [self.customNav setRightContent:nil];
                    } else {
                        [self.customNav setRightContent:@"管理"];
                        [self.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
                    }
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                    if ([[response.data allKeys] count] <= 0) {
                        [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    return;
                }];
            } else {
                [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
                return;
            }
        }];
        [deleteAlert addAction:cancel];
        [deleteAlert addAction:confirm];
        [self presentViewController:deleteAlert animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXFavorite *favorite = (ZXFavorite *)[_favoriteList objectAtIndex:indexPath.row];
    if (_isPick) {
        static NSString *identifier = @"ZXFavoritePickCell";
        ZXFavoritePickCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXFavoritePickCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        [cell setFavorite:favorite];
        [cell.pickBtn setTag:indexPath.row];
        return cell;
    } else {
        static NSString *identifier = @"ZXFavoriteCell";
        ZXFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXFavoriteCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setFavorite:favorite];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isPick) {
        ZXFavorite *favorite = (ZXFavorite *)[_favoriteList objectAtIndex:indexPath.row];
        ZXFavoritePickCell *cell = (ZXFavoritePickCell *)[tableView cellForRowAtIndexPath:indexPath];
        [favorite setIsSelected:!cell.pickBtn.isSelected];
        if ([favorite isSelected]) {
            [_deleteIds addObject:favorite.zx_id];
        } else {
            [_deleteIds removeObject:favorite.zx_id];
        }
        if ([_deleteIds count] == [_favoriteList count]) {
            [_allPickBtn setSelected:YES];
        } else {
            [_allPickBtn setSelected:NO];
        }
        [self.favoriteTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        ZXFavorite *favorite = (ZXFavorite *)[_favoriteList objectAtIndex:indexPath.row];
        ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
        [goodsDetail setFavorite:favorite];
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_favorite_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"当前没有任何收藏呢~";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100.0;
}

#pragma mark - ZXFavoritePickCellDelegate

- (void)favoritePickCellHandleTapPickBtnWithTag:(NSInteger)btnTag andCell:(nonnull ZXFavoritePickCell *)cell {
    ZXFavorite *favorite = (ZXFavorite *)[_favoriteList objectAtIndex:btnTag];
    [favorite setIsSelected:!cell.pickBtn.isSelected];
    if ([favorite isSelected]) {
        [_deleteIds addObject:favorite.zx_id];
    } else {
        [_deleteIds removeObject:favorite.zx_id];
    }
    if ([_deleteIds count] == [_favoriteList count]) {
        [_allPickBtn setSelected:YES];
    } else {
        [_allPickBtn setSelected:NO];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btnTag inSection:0];
    [self.favoriteTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ZXFavoritePickHeaderViewDelegate

- (void)favoritePickHeaderViewHandleTapPickBtnActionWithTag:(NSInteger)btnTag {
    
}

#pragma mark - Button Methods

- (void)handleTapAllPickBtnAction {
    [_allPickBtn setSelected:!_allPickBtn.isSelected];
    if (_allPickBtn.isSelected) {
        for (ZXFavorite *favorite in _favoriteList) {
            [favorite setIsSelected:YES];
            [_deleteIds addObject:favorite.zx_id];
        }
    } else {
        for (ZXFavorite *favorite in _favoriteList) {
            [favorite setIsSelected:NO];
        }
        [_deleteIds removeAllObjects];
    }
    [self.favoriteTableView reloadData];
}

- (void)handleTapDeleteBtnAction {
    if ([_deleteIds count] <= 0) {
        [ZXProgressHUD loadFailedWithMsg:@"请选择收藏商品"];
        return;
    }
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除已选收藏商品？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UtilsMacro isCanReachableNetWork]) {
            [ZXProgressHUD loadingNoMask];
            NSString *ids = [self.deleteIds componentsJoinedByString:@","];
            [[ZXDelFavoriteHelper sharedInstance] fetchDelFavoriteWithIds:ids completion:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD hideAllHUD];
                if ([self.deleteIds count] == [self.favoriteList count]) {
                    [self.favoriteList removeAllObjects];
                    [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
                    self.favoriteTableView.mj_footer = nil;
                    [self.customNav setRightContent:nil];
                } else {
                    for (int i = 0; i < [self.deleteIds count]; i++) {
                        for (ZXFavorite *favorite in [self.favoriteList reverseObjectEnumerator]) {
                            if ([favorite.zx_id isEqualToString:[self.deleteIds objectAtIndex:i]]) {
                                [self.favoriteList removeObject:favorite];
                            }
                        }
                    }
                    [self.customNav setRightContent:@"管理"];
                    [self.customNav.rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
                }
                self.isPick = NO;
                self.deleteIds = [[NSMutableArray alloc] init];
                [self.allPickBtn setSelected:NO];
                [UIView animateWithDuration:0.2 animations:^{
                    [self.favoriteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        if (@available(iOS 11.0, *)) {
                            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                        } else {
                            // Fallback on earlier versions
                            make.bottom.mas_equalTo(self.view);
                        }
                    }];
                    [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
                        if (@available(iOS 11.0, *)) {
                            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(self.bottomHeight + 50.0);
                        } else {
                            // Fallback on earlier versions
                            make.bottom.mas_equalTo(self.view).mas_offset(50.0);
                        }
                    }];
                }];
                [self.favoriteTableView reloadData];
                [self.favoriteTableView reloadEmptyDataSet];
            } error:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
                if ([[response.data allKeys] count] <= 0) {
                    [self.favoriteTableView.mj_footer endRefreshingWithNoMoreData];
                }
                return;
            }];
        } else {
            [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
            return;
        }
    }];
    [deleteAlert addAction:cancel];
    [deleteAlert addAction:confirm];
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

@end

