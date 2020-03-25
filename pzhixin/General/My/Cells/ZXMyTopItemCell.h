//
//  ZXMyTopItemCell.h
//  pzhixin
//
//  Created by zhixin on 2019/11/14.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyTopItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *coutLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (strong, nonatomic) ZXUserBtn *userBtn;

@end

NS_ASSUME_NONNULL_END
