//
//  ZXNewRefreshHeader.h
//  pzhixin
//
//  Created by zhixin on 2020/3/31.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "MJRefreshNormalHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXRefreshHeader : MJRefreshNormalHeader

@property (strong, nonatomic) NSString *timeKey;

@property (assign, nonatomic) BOOL light;

@end

NS_ASSUME_NONNULL_END
