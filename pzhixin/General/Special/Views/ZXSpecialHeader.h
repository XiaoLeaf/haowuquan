//
//  ZXSpecialHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/11/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSpecialHeader : UIView

@property (strong, nonatomic) NSArray *imgList;

@property (copy, nonatomic) void (^zxSpecialHeaderBannerClick) (NSInteger index);

@end

NS_ASSUME_NONNULL_END
