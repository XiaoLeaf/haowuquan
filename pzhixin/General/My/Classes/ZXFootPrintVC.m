//
//  ZXFootPrintVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFootPrintVC.h"
#import "ZXFavoriteCell.h"
#import "ZXFavoriteHeaderView.h"
#import "ZXFavoritePickCell.h"
#import "ZXFavoritePickHeaderView.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "ZXGoodsDetailVC.h"

@interface ZXFootPrintVC () <UITableViewDelegate, UITableViewDataSource, ZXFavoritePickHeaderViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource> {
    UIView *toolView;
    CGFloat bottomHeight;
    UIButton *allPickBtn;
    UIButton *deleteBtn;
    NSInteger page;
    NSInteger deleteIndex;
}

@property (strong, nonatomic) NSMutableArray *footPrintList;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@end

@implementation ZXFootPrintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor:BG_COLOR];
    // Do any additional setup after loading the view from its nib.
    
    _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:@"足迹" titleColor:HOME_TITLE_COLOR rightContent:nil leftDot:NO];
    _customNav.backgroundColor = BG_COLOR;
    
    __weak typeof(self) weakSelf = self;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清空所有足迹？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UtilsMacro isCanReachableNetWork]) {
                [ZXProgressHUD loadingNoMask];
                [[ZXDelFootPrintHelper sharedInstance] fetchDelFootPrintWithIds:@"all" completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD hideAllHUD];
                    [weakSelf.footPrintList removeAllObjects];
                    [weakSelf.footPrintTable reloadData];
                    [weakSelf.footPrintTable reloadEmptyDataSet];
                    [weakSelf.footPrintTable.mj_footer endRefreshingWithNoMoreData];
                    weakSelf.footPrintTable.mj_footer = nil;
                    [weakSelf.customNav setRightContent:nil];
                    [weakSelf.footPrintTable reloadEmptyDataSet];
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                    if ([[response.data allKeys] count] <= 0) {
                        [weakSelf.footPrintTable.mj_footer endRefreshingWithNoMoreData];
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
        [weakSelf presentViewController:deleteAlert animated:YES completion:nil];
    };
    [self.view addSubview:_customNav];
    
    _footPrintTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_footPrintTable setShowsVerticalScrollIndicator:NO];
    [_footPrintTable setShowsVerticalScrollIndicator:NO];
    [_footPrintTable setDelegate:self];
    [_footPrintTable setDataSource:self];
    [_footPrintTable setEmptyDataSetDelegate:self];
    [_footPrintTable setEmptyDataSetSource:self];
    [_footPrintTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_footPrintTable setBackgroundColor:[UIColor clearColor]];
    [_footPrintTable setEstimatedRowHeight:116.0];
    [self.view addSubview:_footPrintTable];
    [_footPrintTable mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFootPrint)];
    [refreshHeader.stateLab setTextColor:COLOR_999999];
    _footPrintTable.mj_header = refreshHeader;
    
    _footPrintTable.tabAnimated = [TABTableAnimated animatedWithCellClass:[ZXFavoriteCell class] cellHeight:116.0];
    [_footPrintTable.mj_header beginRefreshing];
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

- (void)refreshFootPrint {
    if ([UtilsMacro isCanReachableNetWork]) {
        page = 1;
        [[ZXFootPrintHelper sharedInstance] fetchFootPrintWithPage:[NSString stringWithFormat:@"%d",(int)page] completion:^(ZXResponse * _Nonnull response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.footPrintTable.mj_header isRefreshing]) {
                    [self.footPrintTable.mj_header endRefreshing];
                }
                [ZXProgressHUD hideAllHUD];
                if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                    [self.footPrintTable.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self->page++;
                    if (!self.footPrintTable.mj_footer) {
                        self.footPrintTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFootPrint)];
                    } else {
                        [self.footPrintTable.mj_footer resetNoMoreData];
                    }
                }
                
                self.footPrintList = [[NSMutableArray alloc] init];
                NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
                for (int i = 0; i < [resultList count]; i++) {
                    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                    ZXFavorite *favorite = [ZXFavorite yy_modelWithDictionary:dict];
                    [self.footPrintList addObject:favorite];
                }
                if ([self.footPrintList count] > 0) {
                    [self.customNav setRightContent:[UIImage imageNamed:@"icon_fp_delete"]];
                } else {
                    [self.customNav setRightContent:nil];
                }
                [self.footPrintTable reloadData];
            });
        } error:^(ZXResponse * _Nonnull response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.footPrintTable.mj_header isRefreshing]) {
                    [self.footPrintTable.mj_header endRefreshing];
                }
                if (response.status != 0) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                }
                if ([[response.data allKeys] count] <= 0) {
                    [self.footPrintTable.mj_footer endRefreshingWithNoMoreData];
                }
            });
            return;
        }];
    } else {
        if ([self.footPrintTable.mj_header isRefreshing]) {
            [self.footPrintTable.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreFootPrint {
    [[ZXFootPrintHelper sharedInstance] fetchFootPrintWithPage:[NSString stringWithFormat:@"%d",(int)page] completion:^(ZXResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.footPrintTable.mj_footer isRefreshing]) {
                [self.footPrintTable.mj_footer endRefreshing];
            }
            if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                [self.footPrintTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                self->page++;
                if (!self.footPrintTable.mj_footer) {
                    self.footPrintTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFootPrint)];
                } else {
                    [self.footPrintTable.mj_footer resetNoMoreData];
                }
            }
            
            NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
            for (int i = 0; i < [resultList count]; i++) {
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                ZXFavorite *favorite = [ZXFavorite yy_modelWithDictionary:dict];
                [self.footPrintList addObject:favorite];
            }
            [self.footPrintTable reloadData];
        });
    } error:^(ZXResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.footPrintTable.mj_footer isRefreshing]) {
                [self.footPrintTable.mj_footer endRefreshing];
            }
            if (response.status != 0) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
            }
            if ([[response.data allKeys] count] <= 0) {
                [self.footPrintTable.mj_footer endRefreshingWithNoMoreData];
            }
        });
        return;
    }];
}

#pragma mark - Private Methods

- (void)manageFootPrintList {
}

- (void)deleteFootPrintList {
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.footPrintList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
//    return 36.0;
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
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除当前足迹？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UtilsMacro isCanReachableNetWork]) {
//                [self->footPrintList removeObjectAtIndex:indexPath.row];
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [ZXProgressHUD loadingNoMask];
                ZXFavorite *favorite = (ZXFavorite *)[self.footPrintList objectAtIndex:indexPath.row];
                self->deleteIndex = indexPath.row;
                [[ZXDelFootPrintHelper sharedInstance] fetchDelFootPrintWithIds:favorite.zx_id completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD hideAllHUD];
                    [self.footPrintList removeObjectAtIndex:indexPath.row];
                    [self.footPrintTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    if ([self.footPrintList count] <= 0) {
                        [self.footPrintTable reloadEmptyDataSet];
                        [self.footPrintTable.mj_footer endRefreshingWithNoMoreData];
                        self.footPrintTable.mj_footer = nil;
                        [self.customNav setRightContent:nil];
                    } else {
                        [self.customNav setRightContent:[UIImage imageNamed:@"icon_fp_delete"]];
                    }
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                    if ([[response.data allKeys] count] <= 0) {
                        [self.footPrintTable.mj_footer endRefreshingWithNoMoreData];
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
    static NSString *identifier = @"ZXFavoriteCell";
    ZXFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXFavoriteCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXFavorite *favorite = (ZXFavorite *)[self.footPrintList objectAtIndex:indexPath.row];
    [cell setFavorite:favorite];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXFavorite *favorite = (ZXFavorite *)[self.footPrintList objectAtIndex:indexPath.row];
    ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
    [goodsDetail setFavorite:favorite];
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_footprint_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"没有留下任何足迹呢~";
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

- (void)favoritePickCellHandleTapPickBtnWithTag:(NSInteger)btnTag {
    
}

#pragma mark - ZXFavoritePickHeaderViewDelegate

- (void)favoritePickHeaderViewHandleTapPickBtnActionWithTag:(NSInteger)btnTag {
    
}

@end
