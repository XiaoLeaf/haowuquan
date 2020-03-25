//
//  ZXDetailCell_2.h
//  pzhixin
//
//  Created by zhixin on 2019/9/3.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXGoods.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXDetailCell_2Delegate;

@interface ZXDetailCell_2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *recommendView;
@property (weak, nonatomic) IBOutlet UIScrollView *recommendScrollView;

@property (weak, nonatomic) id<ZXDetailCell_2Delegate>delegate;

@property (strong, nonatomic) NSArray *recommendList;

@end

@protocol ZXDetailCell_2Delegate <NSObject>

- (void)detailCell2CollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath andGoods:(ZXGoods *)goods;

@end

NS_ASSUME_NONNULL_END
