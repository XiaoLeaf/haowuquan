//
//  ZXDetailRecItemCell.m
//  pzhixin
//
//  Created by zhixin on 2020/1/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXDetailRecItemCell.h"
#import "ZXDetailRecommendCell.h"

@interface ZXDetailRecItemCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ZXDetailRecItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDetailRecommendCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXDetailRecommendCell"];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
}

#pragma mark - Setter

- (void)setRecommendList:(NSArray *)recommendList {
    _recommendList = recommendList;
    [_mainCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for (int i = (int)self.tag * 6; i < self.tag * 6 + 6; i++) {
        if ([_recommendList count] > i) {
            [dataList addObject:[_recommendList objectAtIndex:i]];
        }
    }
    return [dataList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 40.0)/3.0, (SCREENWIDTH - 40.0)/3.0 + 70.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXDetailRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXDetailRecommendCell" forIndexPath:indexPath];
    ZXGoods *goods = (ZXGoods *)[_recommendList objectAtIndex:self.tag * 6 + indexPath.row];
    [cell setGoods:goods];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXGoods *goods = (ZXGoods *)[_recommendList objectAtIndex:self.tag * 6 + indexPath.row];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell2CollectionView:didSelectItemAtIndexPath:andGoods:)]) {
//        [self.delegate detailCell2CollectionView:collectionView didSelectItemAtIndexPath:indexPath andGoods:goods];
//    }
    if (self.zxDetailRecItemCellDidSelectCollectionViewCell) {
        self.zxDetailRecItemCellDidSelectCollectionViewCell(indexPath, goods);
    }
}

@end
