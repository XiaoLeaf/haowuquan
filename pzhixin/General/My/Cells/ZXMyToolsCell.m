//
//  ZXMyToolsCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyToolsCell.h"
#import "ZXMyToolsItemCell.h"

@interface ZXMyToolsCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *menuList;

@end

@implementation ZXMyToolsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mainView.layer setCornerRadius:5.0];
    [self setBackgroundColor:BG_COLOR];
    [self.toolCollectionView setDelegate:self];
    [self.toolCollectionView setDataSource:self];
    [self.toolCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXMyToolsItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXMyToolsItemCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMyMenu:(ZXMyMenu *)myMenu {
    _myMenu = myMenu;
    _menuList = [[NSArray alloc] initWithArray:_myMenu.list];
    [_titleLab setText:_myMenu.name];
    [self.toolCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 20.0)/4.0, 90.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXMyToolsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXMyToolsItemCell" forIndexPath:indexPath];
    ZXMyMenuItem *myMenuItem = (ZXMyMenuItem *)[_menuList objectAtIndex:indexPath.row];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:myMenuItem.icon] imageView:cell.toolImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:nil completed:nil];
    [cell.toolLab setText:myMenuItem.name];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zxMyToolsCellDidSelectedBlock) {
        self.zxMyToolsCellDidSelectedBlock(indexPath.row);
    }
}

@end
