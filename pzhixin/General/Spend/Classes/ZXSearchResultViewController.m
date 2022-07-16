//
//  ZXSearchResultViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/7/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSearchResultViewController.h"
#import "ZXSubSingleCell.h"
#import "ZXSubDoubleCell.h"
#import "ZXSubSpendFooterView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ZXGoodsDetailVC.h"
#import "ZXSingleSkeletonCell.h"
#import <Masonry/Masonry.h>

#define DISTANCE 10.0

@interface ZXSearchResultViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    BOOL single;
    ZXSubSpendFooterView *footerView;
    NSInteger sortType;
    NSInteger page;
    NSMutableArray *goodsList;
    UITextField *searchTextField;
    NSString *searchStr;
    BOOL isEditing;
}
@property (strong, nonatomic) UIButton *topBtn;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@end

@implementation ZXSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    //接口参数初始化
    sortType = TOTAL_SALES_DES;

    __weak typeof(self) weakSelf = self;
    if (self.fromType == 1) {
        single = YES;
        self.fd_prefersNavigationBarHidden = YES;
        _customNav = [[ZXCustomNavView alloc] initWithSearchTF];
        
        _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [self.view addSubview:_customNav];
        [_customNav.searchTextField setDelegate:self];
    } else {
        single = NO;
        _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_whole_back"] title:_titleStr titleColor:HOME_TITLE_COLOR rightContent:nil leftDot:NO];
        _customNav.backgroundColor = [UIColor whiteColor];
        _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [self.view addSubview:_customNav];
    }
    [self createSubviews];
    isEditing = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //关键词搜索不提供下拉刷新
    if (self.fromType == 1) {
        if ([goodsList count] <= 0) {
            [self refreshSearchResult];
        }
        searchStr = self.titleStr;
        [_customNav.searchTextField setText:searchStr];
    } else {
        ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshSearchResult)];
        [refreshHeader setTimeKey:@"ZXSearchResultViewController"];
//        [refreshHeader.stateLab setTextColor:COLOR_999999];
        self.resultCollectionView.mj_header = refreshHeader;
        if ([goodsList count] <= 0) {
            [self.resultCollectionView.mj_header beginRefreshing];
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_countBtn setNeedsLayout];
    [_countBtn layoutIfNeeded];
    _countBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_countBtn.imageView.frame.size.width - DISTANCE/2.0, 0, _countBtn.imageView.frame.size.width);
    _countBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _countBtn.titleLabel.frame.size.width, 0, -_countBtn.titleLabel.frame.size.width - DISTANCE/2.0);
    [_priceBtn setNeedsLayout];
    [_priceBtn layoutIfNeeded];
    _priceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_priceBtn.imageView.frame.size.width - DISTANCE/2.0, 0, _priceBtn.imageView.frame.size.width);
    _priceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _priceBtn.titleLabel.frame.size.width, 0, -_priceBtn.titleLabel.frame.size.width - DISTANCE/2.0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.navigationController.topViewController isKindOfClass:[ZXGoodsDetailVC class]]) {
        [ZXProgressHUD hideAllHUD];
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

- (void)refreshSearchResult {
    if ([UtilsMacro isCanReachableNetWork]) {
//        [ZXProgressHUD loadingNoMask];
        page = 1;
        if (self.fromType == 1) {
            [ZXProgressHUD loadingNoMask];
            [[ZXSearchListHelper sharedInstance] fetchSearchListWithPage:[NSString stringWithFormat:@"%ld", (long)page] andKeywords:self.titleStr andSort:[NSString stringWithFormat:@"%ld", (long)sortType] completion:^(ZXResponse * _Nonnull response) {
                [ZXProgressHUD hideAllHUD];
                [self.resultCollectionView tab_endAnimation];
                if ([self.resultCollectionView.mj_header isRefreshing]) {
                    [self.resultCollectionView.mj_header endRefreshing];
                }
                self->goodsList = [[NSMutableArray alloc] init];
                if (![[response.data valueForKey:@"goods"] isKindOfClass:[NSArray class]]) {
                    [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                        [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        self.resultCollectionView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSearchResult)];
                        self->page++;
                        [self.resultCollectionView.mj_footer resetNoMoreData];
                        [self.resultCollectionView.mj_footer setHidden:NO];
                    }
                    NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
                    for (int i = 0; i < [resultList count]; i++) {
                        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                        ZXGoods *goods = [ZXGoods yy_modelWithDictionary:dict];
                        [self->goodsList addObject:goods];
                    }
                }
                [self.resultCollectionView reloadEmptyDataSet];
                [self.resultCollectionView reloadData];
            } error:^(ZXResponse * _Nonnull response) {
                [self.resultCollectionView tab_endAnimation];
                if ([self.resultCollectionView.mj_header isRefreshing]) {
                    [self.resultCollectionView.mj_header endRefreshing];
                }
                [ZXProgressHUD loadFailedWithMsg:response.info];
                return;
            }];
        } else {
            [[ZXMaterialOptionalHelper sharedInstance] fetchMaterialOptionalWithPage:[NSString stringWithFormat:@"%ld", (long)page] andCat_id:self.classify.classifyId andSort:[NSString stringWithFormat:@"%ld", (long)sortType] completion:^(ZXResponse * _Nonnull response) {
                [self.resultCollectionView tab_endAnimation];
                [ZXProgressHUD hideAllHUD];
                if ([self.resultCollectionView.mj_header isRefreshing]) {
                    [self.resultCollectionView.mj_header endRefreshing];
                }
                self->goodsList = [[NSMutableArray alloc] init];
                if (![[response.data valueForKey:@"goods"] isKindOfClass:[NSArray class]]) {
                    [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                        [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        self.resultCollectionView.mj_footer = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSearchResult)];
                        self->page++;
                        [self.resultCollectionView.mj_footer resetNoMoreData];
                        [self.resultCollectionView.mj_footer setHidden:NO];
                    }
                    NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
                    for (int i = 0; i < [resultList count]; i++) {
                        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                        ZXGoods *goods = [ZXGoods yy_modelWithDictionary:dict];
                        [self->goodsList addObject:goods];
                    }
                }
                [self.resultCollectionView reloadEmptyDataSet];
                [self.resultCollectionView reloadData];
            } error:^(ZXResponse * _Nonnull response) {
                [self.resultCollectionView tab_endAnimation];
                if ([self.resultCollectionView.mj_header isRefreshing]) {
                    [self.resultCollectionView.mj_header endRefreshing];
                }
                [ZXProgressHUD loadFailedWithMsg:response.info];
                return;
            }];
        }
    } else {
        [self.resultCollectionView tab_endAnimation];
        if ([self.resultCollectionView.mj_header isRefreshing]) {
            [self.resultCollectionView.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreSearchResult {
    if ([UtilsMacro isCanReachableNetWork]) {
        if (self.fromType == 1) {
            [[ZXSearchListHelper sharedInstance] fetchSearchListWithPage:[NSString stringWithFormat:@"%ld", (long)page] andKeywords:self.titleStr andSort:[NSString stringWithFormat:@"%ld", (long)sortType] completion:^(ZXResponse * _Nonnull response) {
                if ([self.resultCollectionView.mj_footer isRefreshing]) {
                    [self.resultCollectionView.mj_footer endRefreshing];
                }
                if (![[response.data valueForKey:@"goods"] isKindOfClass:[NSArray class]]) {
                    [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                        [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        self->page++;
                        [self.resultCollectionView.mj_footer resetNoMoreData];
                        [self.resultCollectionView.mj_footer setHidden:NO];
                    }
                    NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
                    for (int i = 0; i < [resultList count]; i++) {
                        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                        ZXGoods *goods = [ZXGoods yy_modelWithDictionary:dict];
                        [self->goodsList addObject:goods];
                    }
                }
                [self.resultCollectionView reloadData];
            } error:^(ZXResponse * _Nonnull response) {
                if ([self.resultCollectionView.mj_footer isRefreshing]) {
                    [self.resultCollectionView.mj_footer endRefreshing];
                }
                [ZXProgressHUD loadFailedWithMsg:response.info];
                if ([[response.data allKeys] count] <= 0) {
                    [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
                return;
            }];
        } else {
            [[ZXMaterialOptionalHelper sharedInstance] fetchMaterialOptionalWithPage:[NSString stringWithFormat:@"%ld", (long)page] andCat_id:self.classify.classifyId andSort:[NSString stringWithFormat:@"%ld", (long)sortType] completion:^(ZXResponse * _Nonnull response) {
                if ([self.resultCollectionView.mj_footer isRefreshing]) {
                    [self.resultCollectionView.mj_footer endRefreshing];
                }
                if (![[response.data valueForKey:@"goods"] isKindOfClass:[NSArray class]]) {
                    [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    if ([[response.data valueForKey:@"goods"] count] < [[response.data valueForKey:@"pagesize"] integerValue]) {
                        [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        self->page++;
                        [self.resultCollectionView.mj_footer resetNoMoreData];
                        [self.resultCollectionView.mj_footer setHidden:NO];
                    }
                    NSArray *resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"goods"]];
                    for (int i = 0; i < [resultList count]; i++) {
                        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[resultList objectAtIndex:i]];
                        ZXGoods *goods = [ZXGoods yy_modelWithDictionary:dict];
                        [self->goodsList addObject:goods];
                    }
                }
                [self.resultCollectionView reloadData];
            } error:^(ZXResponse * _Nonnull response) {
                if ([self.resultCollectionView.mj_footer isRefreshing]) {
                    [self.resultCollectionView.mj_footer endRefreshing];
                }
                [ZXProgressHUD loadFailedWithMsg:response.info];
                if ([[response.data allKeys] count] <= 0) {
                    [self.resultCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
                return;
            }];
        }
    } else {
        if ([self.resultCollectionView.mj_footer isRefreshing]) {
            [self.resultCollectionView.mj_footer endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.customNav.mas_bottom);
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(41.0);
        }];
    }
    
    UILabel *topLine = [[UILabel alloc] init];
    topLine.backgroundColor = [UtilsMacro colorWithHexString:@"EFEFEF"];
    [_topView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *bottomLine = [[UILabel alloc] init];
    bottomLine.backgroundColor = [UtilsMacro colorWithHexString:@"EFEFEF"];
    [_topView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0);
        make.height.mas_equalTo(0.5);
    }];
    
    NSMutableArray *btnList = [[NSMutableArray alloc] init];
    if (!_synBtn) {
        _synBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_synBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_synBtn setTitle:@"综合" forState:UIControlStateNormal];
        [_synBtn setTag:0];
        [_synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
        [_synBtn addTarget:self action:@selector(handleTapRankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_synBtn];
    }
    [btnList addObject:_synBtn];
    
    if (!_awardBtn) {
        _awardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_awardBtn setTitle:@"奖励" forState:UIControlStateNormal];
        [_awardBtn setTag:1];
        [_awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_awardBtn addTarget:self action:@selector(handleTapRankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_awardBtn];
    }
    [btnList addObject:_awardBtn];
    
    if (!_countBtn) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countBtn setTitle:@"销量" forState:UIControlStateNormal];
        [_countBtn setTag:2];
        [_countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor.png"] forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(handleTapRankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_countBtn];
    }
    [btnList addObject:_countBtn];
    
    if (!_priceBtn) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setTag:3];
        [_priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor.png"] forState:UIControlStateNormal];
        [_priceBtn addTarget:self action:@selector(handleTapRankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_priceBtn];
    }
    [btnList addObject:_priceBtn];
    
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_typeBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.26 * SCREENWIDTH / 5.0)];
        [_typeBtn setTag:4];
        if (single) {
            [_typeBtn setImage:[UIImage imageNamed:@"ic_spend_single"] forState:UIControlStateNormal];
        } else {
            [_typeBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
        }
        [_typeBtn addTarget:self action:@selector(handleTapRankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_typeBtn];
    }
    [btnList addObject:_typeBtn];
    
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
    [btnList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLine.mas_bottom);
        make.bottom.mas_equalTo(bottomLine.mas_top);
    }];
    
    if (!_resultCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_resultCollectionView setBackgroundColor:BG_COLOR];
        [_resultCollectionView setDelegate:self];
        [_resultCollectionView setDataSource:self];
        [_resultCollectionView setEmptyDataSetSource:self];
        [_resultCollectionView setEmptyDataSetDelegate:self];
        [_resultCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSingleSkeletonCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXSingleSkeletonCell"];
        [_resultCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSubSingleCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXSubSingleCell"];
        [_resultCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSubDoubleCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXSubDoubleCell"];
        [_resultCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSubSpendFooterView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZXSubSpendFooterView"];
        [self.view addSubview:_resultCollectionView];
    }
    [_resultCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
    if (single) {
        _resultCollectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClass:[ZXSingleSkeletonCell class] cellSize:CGSizeMake(SCREENWIDTH, 120.0) animatedCount:10];
//        [_resultCollectionView.tabAnimated setCanLoadAgain:YES];
        _resultCollectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(0).radius(5.0);
            manager.animation(0).height(100.0);
        };
    } else {
        _resultCollectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClass:[ZXSubDoubleCell class] cellSize:CGSizeMake((SCREENWIDTH - 15.0)/2.0, (SCREENWIDTH - 15.0)/2.0 + 110.0) animatedCount:6];
//        [_resultCollectionView.tabAnimated setCanLoadAgain:YES];
        [_resultCollectionView.tabAnimated setAnimatedBackgroundColor:BG_COLOR];
        _resultCollectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(0).color([UIColor whiteColor]);
            manager.animation(0).height((SCREENWIDTH - 15.0)/2.0 + 105.0);
            manager.animation(0).radius(5.0);
        };
    }
    [self.resultCollectionView tab_startAnimation];
    
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn setImage:[UIImage imageNamed:@"ic_scroll_top.png"] forState:UIControlStateNormal];
        [_topBtn addTarget:self action:@selector(handleTapTopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topBtn setHidden:YES];
        [self.view addSubview:_topBtn];
        [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-0.2 * SCREENHEIGHT);
            make.right.mas_equalTo(-10.0);
            make.width.height.mas_equalTo(32.0);
        }];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [goodsList count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (single) {
        return 0.5;
    }
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (single) {
        return 0.0;
    } else {
        return 2.5;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (single) {
        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    } else {
        return UIEdgeInsetsMake(0.0, 5.0, 5.0, 5.0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (single) {
        return  CGSizeMake(SCREENWIDTH, 120.0);
    } else {
        return  CGSizeMake((SCREENWIDTH - 15.0)/2.0, (SCREENWIDTH - 15.0)/2.0 + 110.0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (single) {
        return CGSizeMake(SCREENWIDTH, 10.0);
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        return nil;;
    } else if (kind == UICollectionElementKindSectionFooter) {
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZXSubSpendFooterView" forIndexPath:indexPath];
        return footerView;
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXGoods *goods = (ZXGoods *)[goodsList objectAtIndex:indexPath.row];
    if (single) {
        ZXSubSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXSubSingleCell" forIndexPath:indexPath];
        [cell setGoods:goods];
        return cell;
    } else {
        ZXSubDoubleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXSubDoubleCell" forIndexPath:indexPath];
        [cell setGoods:goods];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isEditing) {
        isEditing = NO;
        [_customNav.searchTextField resignFirstResponder];
        return;
    }
    ZXGoods *goods = (ZXGoods *)[goodsList objectAtIndex:indexPath.row];
    if (![UtilsMacro whetherIsEmptyWithObject:[goods pre_slide]] && ![UtilsMacro whetherIsEmptyWithObject:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:goods.pre_slide]]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:goods.pre_slide] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            }];
        });
    }
    ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
    [goodsDetail setGoods:goods];
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_general_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = EMPTY_STR;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

#pragma mark - Button Methods

- (void)handleTapRankBtnAction:(UIButton *)button {
    if (isEditing) {
        isEditing = NO;
        [_customNav.searchTextField resignFirstResponder];
        return;
    }
    NSInteger btnTag = button.tag;
    switch (btnTag) {
        case 0:
        {
            if (sortType == TOTAL_SALES_DES) {
                return;
            }
            sortType = TOTAL_SALES_DES;
            [self.synBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [self.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
            [self.awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
            [self.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
            [self.resultCollectionView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            if (self.fromType != 1) {
                [ZXProgressHUD loadingNoMask];
            }
            [self refreshSearchResult];
        }
            break;
        case 1:
        {
            if (sortType == TK_RATE_DES) {
                return;
            }
            sortType = TK_RATE_DES;
            [self.synBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.awardBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [self.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
            [self.priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
            [self.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
            [self.resultCollectionView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            if (self.fromType != 1) {
                [ZXProgressHUD loadingNoMask];
            }
            [self refreshSearchResult];
        }
            break;
        case 2:
        {
            [self.synBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.priceBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.countBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [self.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
            if (sortType != TK_TOTAL_SALES_ASC && sortType != TK_TOTAL_SALES_DES) {
                sortType = TK_TOTAL_SALES_DES;
                [self.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
            } else if (sortType == TK_TOTAL_SALES_DES) {
                sortType = TK_TOTAL_SALES_ASC;
                [self.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_up"] forState:UIControlStateNormal];
            } else {
                sortType = TK_TOTAL_SALES_DES;
                [self.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
            }
            [self.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
            [self.resultCollectionView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            if (self.fromType != 1) {
                [ZXProgressHUD loadingNoMask];
            }
            [self refreshSearchResult];
        }
            break;
        case 3:
        {
            [self.synBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.synBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.awardBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.awardBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [self.priceBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [self.priceBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
            [self.countBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [self.countBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            if (sortType != PRICE_ASC  && sortType != PRICE_DES) {
                sortType = PRICE_DES;
                [self.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
            } else if (sortType == PRICE_DES) {
                sortType = PRICE_ASC;
                [self.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_up"] forState:UIControlStateNormal];
            } else {
                sortType = PRICE_DES;
                [self.priceBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_down"] forState:UIControlStateNormal];
            }
            [self.countBtn setImage:[UIImage imageNamed:@"ic_dou_triangle_nor"] forState:UIControlStateNormal];
            [self.resultCollectionView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
            if (self.fromType != 1) {
                [ZXProgressHUD loadingNoMask];
            }
            [self refreshSearchResult];
        }
            break;
        case 4:
        {
            single = !single;
            if (single) {
                [self.typeBtn setImage:[UIImage imageNamed:@"ic_spend_single"] forState:UIControlStateNormal];
            } else {
                [self.typeBtn setImage:[UIImage imageNamed:@"ic_spend_double"] forState:UIControlStateNormal];
            }
            [self.resultCollectionView reloadData];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleTapTopBtnAction:(UIButton *)button {
    [self.topBtn setHidden:YES];
    [self.resultCollectionView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _resultCollectionView) {
        if (scrollView.contentOffset.y > SCREENHEIGHT * 2) {
            [self.topBtn setHidden:NO];
        } else {
            [self.topBtn setHidden:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    isEditing = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    isEditing = NO;
    
    NSString *tempStr = textField.text;
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([UtilsMacro whetherIsEmptyWithObject:tempStr]) {
        return NO;
    }
    
    searchStr = tempStr;
    self.titleStr = tempStr;
    [self.resultCollectionView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    [self refreshSearchResult];
    
    [[ZXDatabaseUtil sharedDataBase] insertHistory:tempStr];
    if (self.zxSearchResultVCChangeSearchHisBlock) {
        self.zxSearchResultVCChangeSearchHisBlock(searchStr);
    }
    return YES;
}

@end
