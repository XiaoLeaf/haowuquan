//
//  ZXOrderHeader.h
//  pzhixin
//
//  Created by zhixin on 2019/9/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXOrderHeaderClick)(void);

@interface ZXOrderHeader : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *titleLab;

@property (copy, nonatomic) ZXOrderHeaderClick zxOrderHeaderClick;

@end

NS_ASSUME_NONNULL_END
