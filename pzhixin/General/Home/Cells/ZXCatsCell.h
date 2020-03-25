//
//  ZXCatsCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXClassify.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCatsCell : UICollectionViewCell

@property (strong, nonatomic) ZXClassify *classify;

@property (weak, nonatomic) IBOutlet UIImageView *catsImg;
@property (weak, nonatomic) IBOutlet UILabel *catsName;

@end

NS_ASSUME_NONNULL_END
