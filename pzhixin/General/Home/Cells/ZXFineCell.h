//
//  ZXFineCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXFineCellTitleImgClick)(void);

typedef void(^ZXFineCellCollectionCellDidSelected)(NSInteger index);

@interface ZXFineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UICollectionView *fineCollectionView;

@property (strong, nonatomic) ZXDayRec *dayRec;

@property (copy, nonatomic) ZXFineCellTitleImgClick zxFineCellTitleImgClick;

@property (copy, nonatomic) ZXFineCellCollectionCellDidSelected zxFineCellCollectionCellDidSelected;

@end

NS_ASSUME_NONNULL_END
