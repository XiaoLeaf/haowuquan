//
//  ZXScoreDetailHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/10/22.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXScoreDetailHeaderBtnClick)(NSInteger btnTag);

@interface ZXScoreDetailHeader : UIView

@property (copy, nonatomic) ZXScoreDetailHeaderBtnClick zxScoreDetailHeaderBtnClick;

@end

NS_ASSUME_NONNULL_END
