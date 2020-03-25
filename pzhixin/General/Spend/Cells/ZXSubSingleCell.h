//
//  ZXSubSingleCell.h
//  pzhixin
//
//  Created by zhixin on 2019/6/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSubSingleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) YYLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissionLeft;

@property (strong, nonatomic) ZXGoods *goods;

@end

NS_ASSUME_NONNULL_END
