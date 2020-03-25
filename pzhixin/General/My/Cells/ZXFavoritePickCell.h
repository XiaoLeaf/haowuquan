//
//  ZXFavoritePickCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "ZXFavorite.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFavoritePickCellDelegate;

@interface ZXFavoritePickCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *pickBtn;
- (IBAction)handleTapPickBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) YYLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *originalLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *earnLab;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;

@property (strong, nonatomic) ZXFavorite *favorite;

@property (weak, nonatomic) id<ZXFavoritePickCellDelegate>delegate;

@end

@protocol ZXFavoritePickCellDelegate <NSObject>

- (void)favoritePickCellHandleTapPickBtnWithTag:(NSInteger)btnTag andCell:(ZXFavoritePickCell *)cell;

@end

NS_ASSUME_NONNULL_END
