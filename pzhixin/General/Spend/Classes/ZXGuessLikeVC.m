//
//  ZXGuessLikeVC.m
//  pzhixin
//
//  Created by zhixin on 2019/10/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGuessLikeVC.h"
#import "ZXSpendSortHeaderView.h"
#import <Masonry/Masonry.h>
#import "ZXGoods.h"
#import "ZXDoubleCell.h"
#import "ZXSingleCell.h"
#import "ZXSearchResultViewController.h"
#import "ZXGoodsDetailVC.h"
#import "ZXSpecialHeader.h"
#import "ZXDoubleSkeleCell.h"
#import "ZXSpendSortSkele.h"

#define HEADER_HEIGHT 180.0

#define SPECIAL_HEIGHT SCREENWIDTH * 0.4

@interface ZXGuessLikeVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *spendTable;

@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnBottom;

@property (strong, nonatomic) NSMutableArray *goodsList;

@property (assign, nonatomic) NSInteger page;

@property (assign, nonatomic) NSInteger sortType;

@property (assign, nonatomic) BOOL single;

@property (strong, nonatomic) NSArray *subCats;

@property (strong, nonatomic) ZXSpendSortHeaderView *sortHeaderView;

@property (strong, nonatomic) ZXMaterial *guessLike;

@property (strong, nonatomic) ZXSpecialHeader *slidesHeader;

@property (strong, nonatomic) NSMutableArray *slideList;

@end

@implementation ZXGuessLikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.topBtn setHidden:YES];
    self.topBtnBottom.constant = 0.15 * SCREENHEIGHT;
    _single = NO;
    _sortType = TOTAL_SALES_DES;
    // Do any additional setup after loading the view from its nib.
    
    [self createSubviews];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

- (void)createSubviews {
    if (!_spendTable) {
        _spendTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_spendTable setShowsVerticalScrollIndicator:NO];
        [_spendTable setShowsHorizontalScrollIndicator:NO];
        [_spendTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_spendTable setDelegate:self];
        [_spendTable setDataSource:self];
        [_spendTable setBackgroundColor:BG_COLOR];
        [_spendTable setEstimatedRowHeight:0.0];
        [_spendTable setEstimatedSectionFooterHeight:0.0];
        [_spendTable setEstimatedSectionHeaderHeight:0.0];
        [_spendTable setTableFooterView:[UIView new]];
        [self.view addSubview:_spendTable];
        [_spendTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0.0);
        }];
        
        TABTableAnimated *tableAnimated = [TABTableAnimated animatedWithCellClassArray:@[[ZXSpendSortSkele class], [ZXDoubleSkeleCell class]] cellHeightArray:@[[NSNumber numberWithFloat:41.0], [NSNumber numberWithFloat:(SCREENWIDTH - 15.0)/2.0 + 110.0]] animatedCountArray:@[[NSNumber numberWithInt:1], [NSNumber numberWithInt:10]]];
        tableAnimated.animatedSectionCount = 2;
        tableAnimated.animatedBackgroundColor = [UIColor whiteColor];
        tableAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            if (manager.tabTargetClass == [ZXSpendSortSkele class]) {
                manager.animation(0).color([UIColor whiteColor]).height(41.0);
            }
            if (manager.tabTargetClass == [ZXDoubleSkeleCell class]) {
                manager.animatedBackgroundColor = BG_COLOR;
                manager.animation(0).radius(5.0).color([UIColor whiteColor]).height((SCREENWIDTH - 15.0)/2.0 + 105.0);
                manager.animation(1).radius(5.0).color([UIColor whiteColor]).height((SCREENWIDTH - 15.0)/2.0 + 105.0);
                manager.animation(2).width((SCREENWIDTH - 15.0)/2.0).color([UIColor whiteColor]).radius(5.0);
                manager.animation(3).width((SCREENWIDTH - 15.0)/2.0).color([UIColor whiteColor]).radius(5.0);
                manager.animation(4).color(BG_COLOR).height(40.0);
                manager.animation(5).color(BG_COLOR).height(40.0);
            }
        };
        self.spendTable.tabAnimated = tableAnimated;
        [self.spendTable tab_startAnimation];
        
        ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshSubSpendInfo)];
        [refreshHeader.stateLab setTextColor:COLOR_999999];
        self.spendTable.mj_header = refreshHeader;
        [self.spendTable.mj_header beginRefreshing];
    }
    [self.view bringSubviewToFront:self.topBtn];
}

#pragma mark - MJRefresh

- (void)refreshSubSpendInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXGuessLikeHelper sharedInstance] fetchGuessLikeWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andSort:[NSString stringWithFormat:@"%ld", (long)_sortType] completion:^(ZXResponse * _Nonnull response) {
            if ([self.spendTable.mj_header isRefreshing]) {
                [self.spendTable.mj_header endRefreshing];
            }
            [self.spendTable tab_endAnimation];
            [ZXProgressHUD hideAllHUD];
//            NSLog(@"response:%@",response.data);
            self.guessLike = [ZXMaterial yy_modelWithJSON:response.data];
            if ([self.guessLike.goods count] < self.guessLike.pagesize) {
                [self.spendTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.page++;
                [self.spendTable.mj_footer resetNoMoreData];
                [self.spendTable.mj_footer setHidden:NO];
                self.spendTable.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSubSpendInfo)];
            }
            self.slideList = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.guessLike.slides.count; i++) {
                ZXSubjectSlide *subjectSlide = (ZXSubjectSlide *)[self.guessLike.slides objectAtIndex:i];
                [self.slideList addObject:subjectSlide.img];
            }
            self.goodsList = [[NSMutableArray alloc] initWithArray:self.guessLike.goods];
            [self.spendTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            [self.spendTable tab_endAnimation];
            if ([self.spendTable.mj_header isRefreshing]) {
                [self.spendTable.mj_header endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            if ([[response.data allKeys] count] <= 0) {
                [self.spendTable.mj_footer endRefreshingWithNoMoreData];
            }
            return;
        }];
    } else {
        [self.spendTable tab_endAnimation];
        if ([self.spendTable.mj_header isRefreshing]) {
            [self.spendTable.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreSubSpendInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXGuessLikeHelper sharedInstance] fetchGuessLikeWithPage:[NSString stringWithFormat:@"%ld", (long)_page] andSort:[NSString stringWithFormat:@"%ld", (long)_sortType] completion:^(ZXResponse * _Nonnull response) {
            if ([self.spendTable.mj_footer isRefreshing]) {
                [self.spendTable.mj_footer endRefreshing];
            }
            ZXMaterial *subGuessLike = [ZXMaterial yy_modelWithJSON:response.data];
            if ([subGuessLike.goods count] < subGuessLike.pagesize) {
                [self.spendTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.page++;
                [self.spendTable.mj_footer setHidden:NO];
            }
            [self.goodsList addObjectsFromArray:subGuessLike.goods];
            [self.spendTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.spendTable.mj_footer isRefreshing]) {
                [self.spendTable.mj_footer endRefreshing];
            }
            if (response.status != 200) {
                [ZXProgressHUD loadFailedWithMsg:response.info];
                if ([[response.data allKeys] count] <= 0) {
                    [self.spendTable.mj_footer endRefreshingWithNoMoreData];
                }
                return;
            }
        }];
    } else {
        if ([self.spendTable.mj_footer isRefreshing]) {
            [self.spendTable.mj_footer endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.guessLike.slides count] > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_guessLike.slides.count > 0) {
        if (section == 0) {
            return 0;
        }
    }
    if (_single) {
        return [_goodsList count];
    }
    return [_goodsList count]/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_guessLike.slides.count > 0) {
        if (indexPath.section == 0) {
            return 0.0001;
        }
    }
    if (_single) {
        return 120.0;
    }
    return (SCREENWIDTH - 15.0)/2.0 + 110.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_guessLike.slides.count > 0) {
        if (section == 0) {
            return SPECIAL_HEIGHT;
        }
    }
    if (!self.goodsList) {
        return 0.0001;
    }
    return 41.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_guessLike.slides.count > 0) {
        if (section == 0) {
            if (!_slidesHeader) {
                _slidesHeader = [[ZXSpecialHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SPECIAL_HEIGHT)];
                [_slidesHeader setBackgroundColor:[UIColor whiteColor]];
            }
            [_slidesHeader setImgList:_slideList];
            __weak typeof(self) weakSelf = self;
            _slidesHeader.zxSpecialHeaderBannerClick = ^(NSInteger index) {
                ZXSubjectSlide *subjectSlide = (ZXSubjectSlide *)[weakSelf.guessLike.slides objectAtIndex:index];
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, subjectSlide.url_schema] andUserInfo:nil viewController:weakSelf];
            };
            return _slidesHeader;
        }
    }
    if (!self.goodsList) {
        return nil;
    }
    if (!_sortHeaderView) {
        _sortHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXSpendSortHeaderView class]) owner:nil options:nil] lastObject];
        [_sortHeaderView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 41.0)];
        [_sortHeaderView.synBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_sortHeaderView.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
        [_sortHeaderView.typeBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
    }
    __weak typeof(self) weakSelf = self;
    _sortHeaderView.spendSortHeaderBtnClick = ^(UIButton * _Nonnull button) {
        switch (button.tag) {
            case 0:
            {
                if (weakSelf.sortType == TOTAL_SALES_DES) {
                    return;
                }
                weakSelf.sortType = TOTAL_SALES_DES;
                [weakSelf.sortHeaderView.synBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
                [weakSelf.sortHeaderView.awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
                if (weakSelf.spendTable.contentOffset.y >= SPECIAL_HEIGHT) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                        [weakSelf.spendTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
                [ZXProgressHUD loadingNoMask];
                [weakSelf refreshSubSpendInfo];
            }
                break;
            case 1:
            {
                if (weakSelf.sortType == TK_RATE_DES) {
                    return;
                }
                weakSelf.sortType = TK_RATE_DES;
                [weakSelf.sortHeaderView.synBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.awardBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
                [weakSelf.sortHeaderView.countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
                if (weakSelf.spendTable.contentOffset.y >= SPECIAL_HEIGHT) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                        [weakSelf.spendTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
                [ZXProgressHUD loadingNoMask];
                [weakSelf refreshSubSpendInfo];
            }
                break;
            case 2:
            {
                [weakSelf.sortHeaderView.synBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.countBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
                if (weakSelf.sortType != TK_TOTAL_SALES_ASC && weakSelf.sortType != TK_TOTAL_SALES_DES) {
                    weakSelf.sortType = TK_TOTAL_SALES_DES;
                    [weakSelf.sortHeaderView.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
                } else if (weakSelf.sortType == TK_TOTAL_SALES_DES) {
                    weakSelf.sortType = TK_TOTAL_SALES_ASC;
                    [weakSelf.sortHeaderView.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_up"] forState:UIControlStateNormal];
                } else {
                    weakSelf.sortType = TK_TOTAL_SALES_DES;
                    [weakSelf.sortHeaderView.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
                }
                [weakSelf.sortHeaderView.priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
                if (weakSelf.spendTable.contentOffset.y >= SPECIAL_HEIGHT) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                        [weakSelf.spendTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
                [ZXProgressHUD loading];
                [weakSelf refreshSubSpendInfo];
            }
                break;
            case 3:
            {
                [weakSelf.sortHeaderView.synBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
                [weakSelf.sortHeaderView.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
                [weakSelf.sortHeaderView.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
                if (weakSelf.sortType != PRICE_ASC  && weakSelf.sortType != PRICE_DES) {
                    weakSelf.sortType = PRICE_DES;
                    [weakSelf.sortHeaderView.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
                } else if (weakSelf.sortType == PRICE_DES) {
                    weakSelf.sortType = PRICE_ASC;
                    [weakSelf.sortHeaderView.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_up"] forState:UIControlStateNormal];
                } else {
                    weakSelf.sortType = PRICE_DES;
                    [weakSelf.sortHeaderView.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
                }
                if (weakSelf.spendTable.contentOffset.y >= SPECIAL_HEIGHT) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                        [weakSelf.spendTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
                [ZXProgressHUD loadingNoMask];
                [weakSelf refreshSubSpendInfo];
            }
                break;
            case 4:
            {
                weakSelf.single = !weakSelf.single;
                if (weakSelf.single) {
                    [weakSelf.sortHeaderView.typeBtn setImage:[UIImage imageNamed:@"ic_spend_single"] forState:UIControlStateNormal];
                } else {
                    [weakSelf.sortHeaderView.typeBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
                }
                [weakSelf.spendTable reloadData];
            }
                break;
                
            default:
                break;
        }
    };
    return _sortHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_guessLike.slides.count > 0) {
        if (indexPath.section == 0) {
            return nil;
        }
    }
    __weak typeof(self) weakSelf = self;
    if (_single) {
        static NSString *identifier = @"ZXSingleCell";
        ZXSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXSingleCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        ZXGoods *goods = (ZXGoods *)[_goodsList objectAtIndex:indexPath.row];
        [cell setGoods:goods];
        return cell;
    } else {
        static NSString *identifier = @"ZXDoubleCell";
        ZXDoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXDoubleCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        ZXGoods *leftGoods = (ZXGoods *)[_goodsList objectAtIndex:(indexPath.row) * 2];
        [cell setLeftGoods:leftGoods];
        [cell.leftGoodsView setTag:indexPath.row * 2];
        cell.zxDoubleCellLeftGoodsClick = ^(NSInteger viewTag) {
            if (![UtilsMacro whetherIsEmptyWithObject:leftGoods.pre_slide]) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:leftGoods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    
                }];
            }
            ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
            [goodsDetail setHidesBottomBarWhenPushed:YES];
            [goodsDetail setGoods:leftGoods];
            [weakSelf.navigationController pushViewController:goodsDetail animated:YES];
        };
        if ([_goodsList count] > indexPath.row * 2 + 1) {
            ZXGoods *rightGoods = (ZXGoods *)[_goodsList objectAtIndex:indexPath.row * 2 + 1];
            [cell setRightGoods:rightGoods];
            [cell.rightGoodsView setTag:indexPath.row * 2 + 1];
            cell.zxDoubleCellRightGoodsClick = ^(NSInteger viewTag) {
                if (![UtilsMacro whetherIsEmptyWithObject:rightGoods.pre_slide]) {
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:rightGoods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        
                    }];
                }
                ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
                [goodsDetail setHidesBottomBarWhenPushed:YES];
                [goodsDetail setGoods:rightGoods];
                [weakSelf.navigationController pushViewController:goodsDetail animated:YES];
            };
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_single) {
        ZXGoods *goods = (ZXGoods *)[_goodsList objectAtIndex:indexPath.row];
        if (![UtilsMacro whetherIsEmptyWithObject:goods.pre_slide]) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:goods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
            }];
        }
        ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
        [goodsDetail setHidesBottomBarWhenPushed:YES];
        [goodsDetail setGoods:goods];
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

#pragma mark - Button Method

- (IBAction)handleTapTopBtnAction:(id)sender {
    [self.topBtn setHidden:YES];
    [self.spendTable setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > SCREENHEIGHT * 2.0) {
        [self.topBtn setHidden:NO];
    } else {
        [self.topBtn setHidden:YES];
    }
}

@end
