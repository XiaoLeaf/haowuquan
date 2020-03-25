//
//  ZXFineCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFineCell.h"
#import "ZXHomeFineCell.h"
#import <Masonry/Masonry.h>

@interface ZXFineCell () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *titleImg;

@property (weak, nonatomic) IBOutlet UIView *pageView;

@property (strong, nonatomic) UIView *pageDot;

@end

@implementation ZXFineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mainView.layer setCornerRadius:5.0];
    [self.pageView.layer setCornerRadius:1.0];
    [self setBackgroundColor:BG_COLOR];
    [self.fineCollectionView setDelegate:self];
    [self.fineCollectionView setDataSource:self];
    [self.fineCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXHomeFineCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXHomeFineCell"];
    // Initialization code
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTitleImgAction)];
    [self.titleImg addGestureRecognizer:tapImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setDayRec:(ZXDayRec *)dayRec {
    _dayRec = dayRec;
    [self createPageDot];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_dayRec.banner] imageView:_titleImg placeholderImage:nil options:0 progress:nil completed:nil];
    [self.fineCollectionView reloadData];
}

#pragma mark - Private Methods

- (void)handleTapTitleImgAction {
    if (self.zxFineCellTitleImgClick) {
        self.zxFineCellTitleImgClick();
    }
}

- (void)createPageDot {
    if (!_pageDot) {
        _pageDot = [[UIView alloc] init];
        [_pageDot setBackgroundColor:THEME_COLOR];
        [_pageDot setClipsToBounds:YES];
        [_pageDot.layer setCornerRadius:1.0];
        [_pageView addSubview:_pageDot];
        [_pageDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(15.0);
        }];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dayRec.list count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 10.0)/3.0, (SCREENWIDTH - 10.0)/3.0 + 28.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXHomeFineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXHomeFineCell" forIndexPath:indexPath];
    ZXGoods *goods = (ZXGoods *)[_dayRec.list objectAtIndex:indexPath.row];
    [cell setGoods:goods];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zxFineCellCollectionCellDidSelected) {
        self.zxFineCellCollectionCellDidSelected(indexPath.row);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pageDot mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView.contentOffset.x/(self.fineCollectionView.contentSize.width - SCREENWIDTH - 10.0) * 30.0);
    }];
}

@end
