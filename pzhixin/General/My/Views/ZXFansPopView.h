//
//  ZXFansPopView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXFansPopViewClick)(void);

@interface ZXFansPopView : UIView

@property (strong, nonatomic) UIView *containerView;

@property (copy, nonatomic) ZXFansPopViewClick zxFansPopViewClick;

@property (strong, nonatomic) NSString *tipStr;

@end

NS_ASSUME_NONNULL_END
