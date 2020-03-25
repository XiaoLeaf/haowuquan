//
//  ZXSpendCatsCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSpendCatsCell.h"
#import "ZXCatsCell.h"
#import <Masonry/Masonry.h>

@interface ZXSpendCatsCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *catsCollectionView;

@property (weak, nonatomic) IBOutlet UIView *pageView;

@property (strong, nonatomic) UIView *pageDot;

@end

@implementation ZXSpendCatsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    ZXCustomFlowLayout *layout = [[ZXCustomFlowLayout alloc] init];
//    [layout setTotalWidth:SCREENWIDTH];
//    [layout setLineNum:2];
//    [layout setItemCount:5];
//    [layout setFromNib:YES];
//    layout.itemSize = CGSizeMake(SCREENWIDTH/5.0, 90.0);
//    self.catsCollectionView.collectionViewLayout = layout;
    [self.pageView.layer setCornerRadius:1.0];
    [self.catsCollectionView setDelegate:self];
    [self.catsCollectionView setDataSource:self];
    [self.catsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCatsCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXCatsCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setClassifyList:(NSArray *)classifyList {
    _classifyList = classifyList;
    [self.catsCollectionView reloadData];
    if ([_classifyList count] > 10) {
        [_pageView setHidden:NO];
        [self createPageDot];
    } else {
        [_pageView setHidden:YES];
    }
}

#pragma mark - Private Methods

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
    if (self.zxSpendCatsCellDidSelect) {
        self.zxSpendCatsCellDidSelect(classify);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pageDot mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView.contentOffset.x/(self.catsCollectionView.contentSize.width - SCREENWIDTH) * 30.0);
    }];
}

@end
