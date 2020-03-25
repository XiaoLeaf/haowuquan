//
//  ZXRefreshHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "MJRefreshGifHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXRefreshHeader : MJRefreshGifHeader

@property (strong,  nonatomic) UIImageView *loadingImg;

@property (strong, nonatomic) UILabel *stateLab;

@property (assign, nonatomic) CGFloat topMargin;

@property (assign, nonatomic) BOOL light;

@end

NS_ASSUME_NONNULL_END
