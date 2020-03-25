//
//  ZXDetailRecommendCell.h
//  pzhixin
//
//  Created by zhixin on 2019/6/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXDetailRecommendCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) NSDictionary *goodsInfo;
@property (strong, nonatomic) ZXGoods *goods;

@end

NS_ASSUME_NONNULL_END
