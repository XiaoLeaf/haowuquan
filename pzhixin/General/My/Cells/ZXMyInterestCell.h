//
//  ZXMyInterestCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXMyInterestCellDidSelectedBlock)(NSInteger index);

@interface ZXMyInterestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UICollectionView *interestColl;

@property (copy, nonatomic) ZXMyInterestCellDidSelectedBlock zxMyInterestCellDidSelectedBlock;

@property (strong, nonatomic) ZXMyMenu *myMenu;

@end

NS_ASSUME_NONNULL_END
