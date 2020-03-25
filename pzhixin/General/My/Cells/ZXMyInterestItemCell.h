//
//  ZXMyInterestItemCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyInterestItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *interestImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@end

NS_ASSUME_NONNULL_END
