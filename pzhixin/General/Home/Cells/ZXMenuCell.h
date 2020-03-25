//
//  ZXMenuCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMenuCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *menuImg;
@property (weak, nonatomic) IBOutlet UILabel *menuLab;

@property (strong, nonatomic) ZXHomeSlides *homeBtn;

@end

NS_ASSUME_NONNULL_END
