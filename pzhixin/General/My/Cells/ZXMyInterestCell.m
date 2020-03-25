//
//  ZXMyInterestCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyInterestCell.h"
#import "ZXMyInterestItemCell.h"

@interface ZXMyInterestCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *menuList;

@end

@implementation ZXMyInterestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mainView.layer setCornerRadius:5.0];
    [self setBackgroundColor:BG_COLOR];
    [self.interestColl setDelegate:self];
    [self.interestColl setDataSource:self];
    [self.interestColl registerNib:[UINib nibWithNibName:NSStringFromClass([ZXMyInterestItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXMyInterestItemCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setMyMenu:(ZXMyMenu *)myMenu {
    _myMenu = myMenu;
    _menuList = [[NSArray alloc] initWithArray:_myMenu.list];
    [_titleLab setText:_myMenu.name];
    [self.interestColl reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 20.0)/2.0, 85.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXMyInterestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXMyInterestItemCell" forIndexPath:indexPath];
    ZXMyMenuItem *myMenuItem = (ZXMyMenuItem *)[_menuList objectAtIndex:indexPath.row];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:myMenuItem.icon] imageView:cell.interestImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:nil completed:nil];
    [cell.countLab setText:myMenuItem.desc];
    [cell.titleLab setText:myMenuItem.name];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zxMyInterestCellDidSelectedBlock) {
        self.zxMyInterestCellDidSelectedBlock(indexPath.row);
    }
}

@end
