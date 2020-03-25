//
//  ZXFansView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXFans.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXFansViewNoFansCellBtnClick)(void);

typedef void(^ZXFansViewNCellSelected)(ZXFans *fans);

@interface ZXFansView : UIView

@property (assign, nonatomic) NSInteger fansType;

@property (strong, nonatomic) NSArray *defaultResult;

@property (assign, nonatomic) BOOL isDefault;

@property (copy, nonatomic) ZXFansViewNoFansCellBtnClick zxFansViewNoFansCellBtnClick;

@property (copy, nonatomic) ZXFansViewNCellSelected zxFansViewNCellSelected;

@end

NS_ASSUME_NONNULL_END
