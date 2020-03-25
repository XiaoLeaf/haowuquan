//
//  ZXDetailCell_2.m
//  pzhixin
//
//  Created by zhixin on 2019/9/3.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDetailCell_2.h"
#import <Masonry/Masonry.h>
#import "ZXDetailRecommendCell.h"

#define PAGE_WIDTH 15.0

@interface ZXDetailCell_2 () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UILabel *pageLab;
    CGFloat pageWidth;
}

@end

@implementation ZXDetailCell_2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecommendList:(NSArray *)recommendList {
    _recommendList = recommendList;
    [self createRecommendSubCollView];
}

#pragma mark - Private Methods

- (void)createRecommendSubCollView {
//    NSLog(@"开始创建视图的时间======>%@",[NSDate date]);
    int num = ceil([_recommendList count]/6.0);
    if (num <= 0) {
        return;
    }
    [self.recommendScrollView setContentSize:CGSizeMake(SCREENWIDTH * num, 0.0)];
    [self.recommendScrollView setDelegate:self];
    for (int i = 0; i < num; i++) {
        UICollectionViewFlowLayout *recommendLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0.0, SCREENWIDTH, self.recommendScrollView.frame.size.height) collectionViewLayout:recommendLayout];
        [collectionView setTag:i];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDetailRecommendCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXDetailRecommendCell"];
        [collectionView reloadData];
        [self.recommendScrollView addSubview:collectionView];
    }
    
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - num * PAGE_WIDTH)/2.0, ((SCREENWIDTH - 40.0)/3.0 + 65.0) * 2.0 + 54.0 + 9.0, 45.0, 2.0)];
    [pageView.layer setCornerRadius:1.0];
    [pageView.layer setMasksToBounds:YES];
    [pageView setBackgroundColor:[UtilsMacro colorWithHexString:@"D5D9E2"]];
    [self.recommendView addSubview:pageView];
    
    pageWidth = 45.0/num;
    
    pageLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, pageWidth, 2.0)];
    [pageLab setBackgroundColor:THEME_COLOR];
    [pageLab.layer setCornerRadius:1.0];
    [pageLab.layer setMasksToBounds:YES];
    [pageView addSubview:pageLab];
//    NSLog(@"创建视图完成的时间======>%@",[NSDate date]);
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for (int i = (int)collectionView.tag * 6; i < collectionView.tag * 6 + 6; i++) {
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
    ZXGoods *goods = (ZXGoods *)[_recommendList objectAtIndex:collectionView.tag * 6 + indexPath.row];
    [cell setGoods:goods];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXGoods *goods = (ZXGoods *)[_recommendList objectAtIndex:collectionView.tag * 6 + indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell2CollectionView:didSelectItemAtIndexPath:andGoods:)]) {
        [self.delegate detailCell2CollectionView:collectionView didSelectItemAtIndexPath:indexPath andGoods:goods];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = (int)self.recommendScrollView.contentOffset.x/SCREENWIDTH;
    [UIView animateWithDuration:0.2 animations:^{
        [self->pageLab setFrame:CGRectMake(index * self->pageWidth, 0.0, self->pageWidth, 2.0)];
    }];
}

@end
