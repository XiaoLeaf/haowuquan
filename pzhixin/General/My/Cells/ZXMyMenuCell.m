//
//  ZXMyMenuCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyMenuCell.h"
#import "ZXMyMenuItemCell.h"

@interface ZXMyMenuCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;

@property (strong, nonatomic) NSArray *menuList;

@end

@implementation ZXMyMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:BG_COLOR];
    [self.menuCollectionView.layer setCornerRadius:5.0];
    [self.menuCollectionView setDelegate:self];
    [self.menuCollectionView setDataSource:self];
    [self.menuCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXMyMenuItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXMyMenuItemCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setMyMenu:(ZXMyMenu *)myMenu {
    _myMenu = myMenu;
    _menuList = [[NSArray alloc] initWithArray:_myMenu.list];
    [self.menuCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 20.0)/[_menuList count], 86.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXMyMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXMyMenuItemCell" forIndexPath:indexPath];
    ZXMyMenuItem *myMenuItem = (ZXMyMenuItem *)[_menuList objectAtIndex:indexPath.row];
    [cell.menuLab setText:myMenuItem.name];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:myMenuItem.icon] imageView:cell.menuImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:nil completed:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zxMyMenuCellDidSelectedBlock) {
        self.zxMyMenuCellDidSelectedBlock(indexPath.row);
    }
}

@end
