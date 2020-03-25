//
//  ZXBalanceSecHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXBalanceSecHeaderBtnClick)(NSInteger btnTag);

@interface ZXBalanceSecHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (copy, nonatomic) ZXBalanceSecHeaderBtnClick zxBalanceSecHeaderBtnClick;

@end

NS_ASSUME_NONNULL_END
