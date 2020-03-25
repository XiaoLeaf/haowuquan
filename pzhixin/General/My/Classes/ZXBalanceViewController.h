//
//  ZXBalanceViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import "SGAdvertScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBalanceViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet SGAdvertScrollView *balanceScroll;
@property (weak, nonatomic) IBOutlet UITableView *balanceTableView;

@end

NS_ASSUME_NONNULL_END
