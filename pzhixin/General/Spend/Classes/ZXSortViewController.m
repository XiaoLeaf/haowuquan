//
//  ZXSortViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSortViewController.h"
#import "ZXSortCell.h"
#import "ZXSortCollCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ZXSortHeaderView.h"
#import "ZXSortFooterView.h"
#import "ZXSearchResultViewController.h"
#import "ZXSearchViewController.h"
#import "ZXClassify.h"
#import <Masonry/Masonry.h>

#define SORT_COLL_IDENTIFIER @"ZXSortCollCell"
#define SORT_HEADER @"ZXSortHeaderView"
#define SORT_FOOTER @"ZXSortFooterView"

@interface ZXSortViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate> {
    NSArray *menuList;
    NSInteger menuIndex;
    ZXSortHeaderView *headerView;
    ZXSortFooterView *footerView;
    UIButton *searchBtn;
}

@property (strong, nonatomic) ZXCustomNavView *customNav;

@end

@implementation ZXSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.labelTop.constant = 44.0;
    self.fd_prefersNavigationBarHidden = YES;
    
    _customNav = [[ZXCustomNavView alloc] initWithSearchBtn];
    [_customNav setBackgroundColor:BG_COLOR];
    
    __weak typeof(self) weakSelf = self;
    _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.searchButtonClick = ^{
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SEARCH_VC] andUserInfo:nil viewController:weakSelf];
    };
    [self.view addSubview:_customNav];
    [self createTableAndColl];
    
    menuIndex = 0;
    // Do any additional setup after loading the view from its nib.
    menuList = [[ZXAppConfigHelper sharedInstance] classifyList];
    [self.sortCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSortCollCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SORT_COLL_IDENTIFIER];
    [self.sortCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXSortHeaderView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SORT_HEADER];
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

- (void)createTableAndColl {
    if (!_sortTabelView) {
        _sortTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_sortTabelView setDelegate:self];
        [_sortTabelView setDataSource:self];
        [_sortTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_sortTabelView setShowsVerticalScrollIndicator:NO];
        [_sortTabelView setShowsHorizontalScrollIndicator:NO];
        [_sortTabelView setBackgroundColor:[UtilsMacro colorWithHexString:@"F7F7F7"]];
        [self.view addSubview:_sortTabelView];
        [_sortTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(90.0);
            make.top.mas_equalTo(self.customNav.mas_bottom);
        }];
    }
    if (!_sortCollectionView) {
        _sortCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [_sortCollectionView setDelegate:self];
        [_sortCollectionView setDataSource:self];
        [_sortCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_sortCollectionView setShowsHorizontalScrollIndicator:NO];
        [_sortCollectionView setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:_sortCollectionView];
        [_sortCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sortTabelView.mas_right);
            make.right.bottom.mas_equalTo(0.0);
            make.top.mas_equalTo(self.customNav.mas_bottom);
        }];
    }
}

- (void)sortCollectionViewDidEndScroll {
    NSArray *indexPaths = [self.sortCollectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = [indexPaths firstObject];
    menuIndex = indexPath.section;
    [self.sortTabelView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXSortCell";
    ZXSortCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXSortCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXClassify *classify = (ZXClassify *)[menuList objectAtIndex:indexPath.row];
    if ([UtilsMacro whetherIsEmptyWithObject:classify.name]) {
        [cell.nameLabel setText:@""];
    } else {
        [cell.nameLabel setText:classify.name];
    }
    if (indexPath.row == menuIndex) {
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.nameLabel setTextColor:THEME_COLOR];
    } else {
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.nameLabel setTextColor:COLOR_666666];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    menuIndex = indexPath.row;
    [self.sortTabelView reloadData];
    UICollectionViewLayoutAttributes *attributes = [self.sortCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]];
    CGRect rect = attributes.frame;
    [self.sortCollectionView setContentOffset:CGPointMake(0.0, rect.origin.y - 50.0) animated:YES];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [menuList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZXClassify *classify = (ZXClassify *)[menuList objectAtIndex:section];
    return [classify.subcats count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 90.0)/3.0, 110.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 50.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        ZXClassify *classify = (ZXClassify *)[menuList objectAtIndex:indexPath.section];
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SORT_HEADER forIndexPath:indexPath];
        if ([UtilsMacro whetherIsEmptyWithObject:classify.name]) {
            [headerView.nameLabel setText:@""];
        } else {
            [headerView.nameLabel setText:classify.name];
        }
        return headerView;
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXClassify *classify = [[(ZXClassify *)[menuList objectAtIndex:indexPath.section] subcats] objectAtIndex:indexPath.row];
    ZXSortCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SORT_COLL_IDENTIFIER forIndexPath:indexPath];
    if ([UtilsMacro whetherIsEmptyWithObject:classify.name]) {
        [cell.nameLabel setText:@""];
    } else {
        [cell.nameLabel setText:classify.name];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:classify.icon]) {
        [cell.goodsImg setImage:nil];
    } else {
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:classify.icon] imageView:cell.goodsImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXClassify *mainClassify = (ZXClassify *)[menuList objectAtIndex:indexPath.section];
    ZXClassify *classify = [[mainClassify subcats] objectAtIndex:indexPath.row];
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CATEGORY_VC] andUserInfo:classify viewController:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.sortCollectionView) {
//        [self sortCollectionViewDidEndScroll];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.sortCollectionView) {
        BOOL isStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (isStop) {
            [self sortCollectionViewDidEndScroll];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.sortCollectionView) {
        if (!decelerate) {
            BOOL isStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
            if (isStop) {
                [self sortCollectionViewDidEndScroll];
            }
        }
    }
}

@end
