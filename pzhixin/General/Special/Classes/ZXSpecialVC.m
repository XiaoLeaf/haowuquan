//
//  ZXSpecialVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSpecialVC.h"
#import "ZXDoubleCell.h"
#import "ZXSingleCell.h"
#import <Masonry/Masonry.h>
#import "ZXSpecialHeader.h"
#import "ZXSpendSortHeaderView.h"
#import "ZXGoodsDetailVC.h"
#import "ZXDoubleSkeleCell.h"
#import "ZXSingleSkeleCell.h"

#define HEADER_HEIGHT (SCREENWIDTH - 10.0) * 0.4 + 5.0

@interface ZXSpecialVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *specialTable;

@property (strong, nonatomic) ZXSpecialHeader *specialHeader;

@property (strong, nonatomic) ZXSpendSortHeaderView *sortHeader;

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) ZXRefreshFooter *refreshFooter;

@property (strong, nonatomic) NSMutableArray *goodsList;

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) NSMutableArray *slideList;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) UIButton *topBtn;

@end

@implementation ZXSpecialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createSubviews];
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

#pragma mark - Setter

- (void)setSubjectResult:(ZXSubjectResult *)subjectResult{
    _subjectResult = subjectResult;
}

- (void)setSingle:(BOOL)single {
    _single = single;
    [_specialTable reloadData];
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_specialTable) {
        _specialTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_specialTable setShowsVerticalScrollIndicator:NO];
        [_specialTable setShowsHorizontalScrollIndicator:NO];
        [_specialTable setDelegate:self];
        [_specialTable setDataSource:self];
        [_specialTable setBackgroundColor:BG_COLOR];
        [_specialTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_specialTable setEstimatedRowHeight:0.0];
        [_specialTable setEstimatedSectionHeaderHeight:0.0];
        [_specialTable setEstimatedSectionFooterHeight:0.0];
        [self.view addSubview:_specialTable];
        
        if (_single) {
            TABTableAnimated *tableAnimated = [TABTableAnimated animatedWithCellClass:[ZXSingleSkeleCell class] cellHeight:120.0 animatedCount:10];
            tableAnimated.animatedBackgroundColor = BG_COLOR;
            tableAnimated.animatedColor = BG_COLOR;
            tableAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
                manager.animation(0).color([UIColor whiteColor]).height(120.0).width(SCREENWIDTH);
                manager.animation(1).width(100.0).height(100.0).radius(5.0);
                manager.animation(2).height(40.0);
                manager.animation(3).height(15.0);
                manager.animation(6).up(2.0);
                manager.animation(7).up(2.0);
                manager.animation(8).up(2.0);
            };
            self.specialTable.tabAnimated = tableAnimated;
            [self.specialTable tab_startAnimation];
        } else {
            TABTableAnimated *tableAnimated = [TABTableAnimated animatedWithCellClass:[ZXDoubleSkeleCell class] cellHeight:(SCREENWIDTH - 15.0)/2.0 + 110.0 animatedCount:10];
            tableAnimated.animatedBackgroundColor = BG_COLOR;
            tableAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
                manager.animation(0).radius(5.0).color([UIColor whiteColor]).height((SCREENWIDTH - 15.0)/2.0 + 105.0);
                manager.animation(1).radius(5.0).color([UIColor whiteColor]).height((SCREENWIDTH - 15.0)/2.0 + 105.0);
                manager.animation(2).width((SCREENWIDTH - 15.0)/2.0).color([UIColor whiteColor]).radius(5.0);
                manager.animation(3).width((SCREENWIDTH - 15.0)/2.0).color([UIColor whiteColor]).radius(5.0);
                manager.animation(4).color(BG_COLOR).height(40.0);
                manager.animation(5).color(BG_COLOR).height(40.0);
            };
            self.specialTable.tabAnimated = tableAnimated;
            [self.specialTable tab_startAnimation];
        }
        
        _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshGoodsSubject)];
        [_refreshHeader setTimeKey:[NSString stringWithFormat:@"ZXSpecialVC%@",_sid]];
        _refreshFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoodsSubject)];
//        [_refreshHeader.stateLab setTextColor:COLOR_999999];
        _specialTable.mj_header = _refreshHeader;
        if (_subjectResult) {
            _goodsList = [[NSMutableArray alloc] initWithArray:_subjectResult.list];
            _slideList = [[NSMutableArray alloc] init];
            for (int i = 0; i < _subjectResult.slides.count; i++) {
                ZXSubjectSlide *subjectSlide = (ZXSubjectSlide *)[_subjectResult.slides objectAtIndex:i];
                [_slideList addObject:subjectSlide.img];
            }
            [self.specialTable tab_endAnimation];
            [_specialTable reloadData];
            _specialTable.mj_footer = _refreshFooter;
        } else {
            [_refreshHeader beginRefreshing];
        }
        [_specialTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn setImage:[UIImage imageNamed:@"ic_scroll_top.png"] forState:UIControlStateNormal];
        [_topBtn addTarget:self action:@selector(handleTapTopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_topBtn setHidden:YES];
        [self.view addSubview:_topBtn];
        [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-0.2 * SCREENHEIGHT);
            make.right.mas_equalTo(-10.0);
            make.width.height.mas_equalTo(32.0);
        }];
    }
}

- (void)refreshGoodsSubject {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXSubjectHelper sharedInstance] fetchSubjectWithSid:_sid andCid:_subjectCat.catId andPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(ZXResponse * _Nonnull response) {
            [self.specialTable tab_endAnimation];
            if (self.refreshHeader.isRefreshing) {
                [self.refreshHeader endRefreshing];
            }
            self.subjectResult = [ZXSubjectResult yy_modelWithJSON:response.data];
            if ([self.subjectResult.list count] < self.subjectResult.pagesize) {
                [self.specialTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.page++;
                [self.specialTable.mj_footer resetNoMoreData];
                [self.specialTable.mj_footer setHidden:NO];
                self.specialTable.mj_footer = self.refreshFooter;
            }
            self.goodsList = [[NSMutableArray alloc] initWithArray:self.subjectResult.list];
            self.slideList = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.subjectResult.slides.count; i++) {
                ZXSubjectSlide *subjectSlide = (ZXSubjectSlide *)[self.subjectResult.slides objectAtIndex:i];
                [self.slideList addObject:subjectSlide.img];
            }
            [self.specialTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            [self.specialTable tab_endAnimation];
            if (self.refreshHeader.isRefreshing) {
                [self.refreshHeader endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [self.specialTable tab_endAnimation];
        if (_refreshHeader.isRefreshing) {
            [_refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreGoodsSubject {
    _page++;
    [[ZXSubjectHelper sharedInstance] fetchSubjectWithSid:_sid andCid:_subjectCat.catId andPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(ZXResponse * _Nonnull response) {
        if ([self.refreshFooter isRefreshing]) {
            [self.refreshFooter endRefreshing];
        }
        ZXSubjectResult *result = [ZXSubjectResult yy_modelWithJSON:response.data];
        [self.goodsList addObjectsFromArray:result.list];
        [self.specialTable reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.refreshFooter isRefreshing]) {
            [self.refreshFooter endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:response.info];
        return;
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_subjectResult.slides.count <= 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_subjectResult.slides count] <= 0) {
        if (_single) {
            return [_goodsList count];
        }
        return [_goodsList count]/2;
    } else {
        if (section == 0) {
            return 0;
        }
        if (_single) {
            return [_goodsList count];
        }
        return [_goodsList count]/2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_subjectResult.slides.count <= 0) {
        if (_single) {
            return 120.0;
        }
        return (SCREENWIDTH - 15.0)/2.0 + 110.0;
    } else {
        if (indexPath.section == 0) {
            return 0.0001;
        }
        if (_single) {
            return 120.0;
        }
        return (SCREENWIDTH - 15.0)/2.0 + 110.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_subjectResult.slides.count > 0) {
        if (section == 0) {
            return HEADER_HEIGHT;
        }
        return 0.001;
    } else {
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (_subjectResult.slides.count > 0) {
                if (!_specialHeader) {
                    _specialHeader = [[ZXSpecialHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, HEADER_HEIGHT)];
                    [_specialHeader setBackgroundColor:[UIColor clearColor]];
                }
                [_specialHeader setImgList:_slideList];
                __weak typeof(self) weakSelf = self;
                _specialHeader.zxSpecialHeaderBannerClick = ^(NSInteger index) {
                    ZXSubjectSlide *subjectSlide = (ZXSubjectSlide *)[weakSelf.subjectResult.slides objectAtIndex:index];
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, subjectSlide.url_schema] andUserInfo:nil viewController:weakSelf];
                };
                return _specialHeader;
            } else {
                return nil;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }
    __weak typeof(self) weakSelf = self;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _specialTable) {
        if (scrollView.contentOffset.y > SCREENHEIGHT * 2) {
            [self.topBtn setHidden:NO];
        } else {
            [self.topBtn setHidden:YES];
        }
    }
}

#pragma mark - Button Method

- (void)handleTapTopBtnAction {
    [_topBtn setHidden:YES];
    [_specialTable setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

@end
