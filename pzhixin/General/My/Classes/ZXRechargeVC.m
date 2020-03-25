//
//  ZXRechargeVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRechargeVC.h"
#import "ZXRechargeCell.h"
#import "ZXRechargeHeaderView.h"
#import <ContactsUI/ContactsUI.h>

@interface ZXRechargeVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZXRechargeHeaderViewDelegate, CNContactPickerDelegate> {
    ZXRechargeHeaderView *headerView;
    NSInteger selectIndex;
}

@end

@implementation ZXRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"话费充值" font:TITLE_FONT color:HOME_TITLE_COLOR];
    
    [self.rechargeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXRechargeCell class]) bundle:nil] forCellWithReuseIdentifier:@"ZXRechargeCell"];
    [self.rechargeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXRechargeHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXRechargeHeaderView"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)openContact {
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
    }];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREENWIDTH - 80.0)/3.0, 60.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 105.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20.0, 20.0, 0.0, 20.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (!headerView) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZXRechargeHeaderView" forIndexPath:indexPath];
        }
        [headerView setDelegate:self];
        return headerView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXRechargeCell" forIndexPath:indexPath];
    if (indexPath.row == selectIndex) {
        [cell setBackgroundColor:THEME_COLOR];
        [cell.valueLab setTextColor:[UIColor whiteColor]];
        [cell.priceLab setTextColor:[UIColor whiteColor]];
        [cell.layer setBorderWidth:0.0];
        [cell.layer setBorderColor:THEME_COLOR.CGColor];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.valueLab setTextColor:HOME_TITLE_COLOR];
        [cell.priceLab setTextColor:COLOR_666666];
        [cell.layer setBorderWidth:1.0];
        [cell.layer setBorderColor:[UtilsMacro colorWithHexString:@"E5E5E5"].CGColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectIndex = indexPath.row;
    [self.rechargeCollectionView reloadData];
}

#pragma mark - ZXRechargeHeaderViewDelegate

- (void)rechargeHeaderViewHandleTapContactBtnAction {
    [self openContact];
    CNContactPickerViewController *contact = [[CNContactPickerViewController alloc] init];
    [contact setDelegate:self];
    [contact setDisplayedPropertyKeys:@[CNContactPhoneNumbersKey]];
    [self presentViewController:contact animated:YES completion:nil];
}

#pragma mar - CNContactPickerDelegate

//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
//    if (contact.phoneNumbers.count <= 0) {
//        return;
//    }
//    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)[contact.phoneNumbers objectAtIndex:0].value;
////    NSLog(@"phoneNumber:%@",phoneNumber);
//    NSString *phone = phoneNumber.stringValue;
////    NSLog(@"手机号===>%@", phone);
//    [headerView.phoneTextField setText:phone];
//}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *phone = phoneNumber.stringValue;
//            NSLog(@"手机号===>%@", phone);
        [self->headerView.phoneTextField setText:phone];
    }];
}

@end
