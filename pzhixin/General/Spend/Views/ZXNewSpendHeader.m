//
//  ZXNewSpendHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/10/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewSpendHeader.h"
#import "ZXCatsCell.h"

@interface ZXNewSpendHeader () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *catsCollectionView;

@end

@implementation ZXNewSpendHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.catsCollectionView setDelegate:self];
    [self.catsCollectionView setDataSource:self];
    [self.catsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCatsCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXCatsCell"];
}

#pragma mark - Setter

- (void)setClassifyList:(NSArray *)classifyList {
    _classifyList = classifyList;
    [self.catsCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_classifyList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH/5.0, 90.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXClassify *classify = [_classifyList objectAtIndex:indexPath.row];
    ZXCatsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXCatsCell" forIndexPath:indexPath];
    [cell setClassify:classify];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXClassify *classify = [_classifyList objectAtIndex:indexPath.row];
    if (self.zxNewSpendHeaderCellDidSelected) {
        self.zxNewSpendHeaderCellDidSelected(classify);
    }
}

@end
