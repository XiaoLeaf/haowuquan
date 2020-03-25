//
//  ZXMyTopCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMyTopCell.h"
#import "ZXMyTopItemCell.h"

@interface ZXMyTopCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> 

@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *totalView;

@end

@implementation ZXMyTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    [self.headImg.layer setCornerRadius:self.headImg.frame.size.width/2.0];
    [self.cpCodeBtn.layer setCornerRadius:self.cpCodeBtn.frame.size.height/2.0];
    [self.topCollectionView setDelegate:self];
    [self.topCollectionView setDataSource:self];
    [self.topCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXMyTopItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXMyTopItemCell"];
    
    UITapGestureRecognizer *tapHeadImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkUserHeadImg)];
    [self.headImg addGestureRecognizer:tapHeadImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setUserInfo:(ZXUser *)userInfo {
    _userInfo = userInfo;
    [self.nameLab setText:userInfo.nickname];
    if ([UtilsMacro whetherIsEmptyWithObject:[userInfo icon]]) {
        [self.headImg setImage:DEFAULT_HEAD_IMG];
    } else {
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[userInfo icon]] imageView:self.headImg placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {} completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {}];
    }
    switch (_userInfo.rank.intValue) {
        case 1:
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:ZXAppConfigHelper.sharedInstance.appConfig.img_res.rank_1] imageView:_levelImg placeholderImage:nil options:0 progress:nil completed:nil];
            break;
        case 2:
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:ZXAppConfigHelper.sharedInstance.appConfig.img_res.rank_2] imageView:_levelImg placeholderImage:nil options:0 progress:nil completed:nil];
            break;

        default:
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:ZXAppConfigHelper.sharedInstance.appConfig.img_res.rank_1] imageView:_levelImg placeholderImage:nil options:0 progress:nil completed:nil];
            break;
    }
    if ([UtilsMacro whetherIsEmptyWithObject:[userInfo icode]]) {
        [self.icodeLab setText:@"邀请码:"];
        [self.cpCodeBtn setTitle:@"  获取邀请码  " forState:UIControlStateNormal];
    } else {
        [self.icodeLab setText:[NSString stringWithFormat:@"邀请码:%@",userInfo.icode]];
        [self.cpCodeBtn setTitle:@" 复制 " forState:UIControlStateNormal];
    }
    [self.fansLab setText:[NSString stringWithFormat:@"粉丝:%@",userInfo.fans_num]];
    [self.topCollectionView reloadData];
}

#pragma mark - UITapGestureRecognizer

- (void)checkUserHeadImg {
    if (self.zxMyTopCellCpBtnClick) {
        self.zxMyTopCellCpBtnClick(0);
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_userInfo.hbtns count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH/[_userInfo.hbtns count], 40.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXMyTopItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXMyTopItemCell" forIndexPath:indexPath];
    ZXUserBtn *userBtn = (ZXUserBtn *)[_userInfo.hbtns objectAtIndex:indexPath.row];
    [cell setUserBtn:userBtn];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.zxMyTopItemCellDidSelected) {
        ZXUserBtn *userBtn = (ZXUserBtn *)[_userInfo.hbtns objectAtIndex:indexPath.row];
        self.zxMyTopItemCellDidSelected(userBtn);
    }
}

#pragma mark - Button Method

- (IBAction)handleTapCpCodeBtnAction:(id)sender {
    if (self.zxMyTopCellCpBtnClick) {
        self.zxMyTopCellCpBtnClick(5);
    }
}

@end
