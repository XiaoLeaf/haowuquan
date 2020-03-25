//
//  ZXFirstFansView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXFirstFansView : UIView

typedef void(^ZXFirstFansViewBtnClick)(NSInteger btnTag);

@property (strong, nonatomic) UIView *containerView;

@property (copy, nonatomic) ZXFirstFansViewBtnClick zxFirstFansViewBtnClick;

@property (strong, nonatomic) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
