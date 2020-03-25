//
//  ZXSearchNewHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/11/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSearchNewHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@property (copy, nonatomic) void(^zxSearchNewHeaderImgClick)(void);

@end

NS_ASSUME_NONNULL_END
