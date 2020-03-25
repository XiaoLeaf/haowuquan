//
//  ZXNewHomeHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXNewHomeHeaderImgClick)(void);

@interface ZXNewHomeHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *titleImg;

@property (copy, nonatomic) ZXNewHomeHeaderImgClick zxNewHomeHeaderImgClick;

@end

NS_ASSUME_NONNULL_END
