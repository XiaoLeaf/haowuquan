//
//  ZXHomeMenuCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeMenuCell.h"
#import "ZXMenuCell.h"
#import "ZXMenuNewCell.h"

@interface ZXHomeMenuCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZXHomeMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:BG_COLOR];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    [_menuTable.layer setCornerRadius:5.0];
    [self.menuCollectionView setDelegate:self];
    [self.menuCollectionView setDataSource:self];
    [self.menuCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXMenuCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXMenuCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setMenuList:(NSArray *)menuList {
    _menuList = menuList;
    [_menuTable reloadData];
//    [self.menuCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH/5.0, 95.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXMenuCell" forIndexPath:indexPath];
    ZXHomeSlides *homeBtn = (ZXHomeSlides *)[_menuList objectAtIndex:indexPath.row];
    [cell setHomeBtn:homeBtn];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([_menuList count]/5.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXMenuNewCell";
    ZXMenuNewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXMenuNewCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setTag:indexPath.row];
    [cell setMenuList:_menuList];
    cell.zxMenuNewCellMenuClick = ^(NSInteger cellTag, NSInteger menuTag) {
        if (self.zxHomeMenuCellMenuDidSelected) {
            self.zxHomeMenuCellMenuDidSelected(cellTag, menuTag);
        }
    };
    return cell;
}

@end
