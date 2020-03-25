//
//  ZXMyTopCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *levelImg;
@property (weak, nonatomic) IBOutlet UILabel *icodeLab;
@property (weak, nonatomic) IBOutlet UIButton *cpCodeBtn;
- (IBAction)handleTapCpCodeBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;

@property (copy, nonatomic) void(^zxMyTopCellCpBtnClick)(NSInteger index);

@property (copy, nonatomic) void(^zxMyTopItemCellDidSelected)(ZXUserBtn *userBtn);

@property (strong, nonatomic) ZXUser *userInfo;

@end

NS_ASSUME_NONNULL_END
