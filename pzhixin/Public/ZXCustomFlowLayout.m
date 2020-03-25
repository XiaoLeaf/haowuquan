//
//  ZXCustomFlowLayout.m
//  pzhixin
//
//  Created by zhixin on 2019/11/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCustomFlowLayout.h"

@implementation ZXCustomFlowLayout

- (CGSize)collectionViewContentSize {
    NSInteger totalCount = [self.collectionView numberOfItemsInSection:0];
    int totalPage;
    if ((float)totalCount/(_itemCount * _lineNum) == 1.0) {
        totalPage = (int)totalCount/(_itemCount * _lineNum);
    } else {
        totalPage = (int)ceil((float)totalCount/(_itemCount * _lineNum));
    }
    return CGSizeMake(totalPage * _totalWidth, self.collectionView.frame.size.height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *superList = [[NSMutableArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect]];
    int totalPage = ceil(superList.count/(_itemCount * _lineNum));
    for (int i = 0; i <= totalPage; i++) {
        NSRange range;
        if (i == totalPage) {
            range = NSMakeRange(i * _lineNum * _itemCount, superList.count - i * _lineNum * _itemCount);
            [superList replaceObjectsInRange:range withObjectsFromArray:[self chanegLayoutAttributesWithArray:[superList subarrayWithRange:range] andPage:i]];
        } else {
            range = NSMakeRange(i * _lineNum * _itemCount, _lineNum * _itemCount);
            [superList replaceObjectsInRange:range withObjectsFromArray:[self chanegLayoutAttributesWithArray:[superList subarrayWithRange:range] andPage:i]];
        }
    }
    return superList;
}

#pragma mark - Private Methods

- (NSArray *)chanegLayoutAttributesWithArray:(NSArray *)list andPage:(int)page {
    NSMutableArray *resultList = [[NSMutableArray alloc] initWithArray:list];
    for (int i = 0; i < resultList.count; i++) {
        UICollectionViewLayoutAttributes *attris = (UICollectionViewLayoutAttributes *)[resultList objectAtIndex:i];
        if ((i + 1) * self.itemSize.width <= _totalWidth) {
            [attris setFrame:CGRectMake(i * self.itemSize.width + floorf(attris.frame.origin.x / _totalWidth) * _totalWidth + (_fromNib ? page * _totalWidth : 0.0), 0.0, self.itemSize.width, self.itemSize.height)];
        } else {
            [attris setFrame:CGRectMake(i%_itemCount * self.itemSize.width + floorf(attris.frame.origin.x / _totalWidth) * _totalWidth + (_fromNib ? page * _totalWidth : 0.0), self.itemSize.height, self.itemSize.width, self.itemSize.height)];
        }
        [resultList replaceObjectAtIndex:i withObject:attris];
    }
    return resultList;
}

@end
