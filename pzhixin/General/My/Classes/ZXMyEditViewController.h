//
//  ZXMyEditViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyEditViewController : ZXNormalBaseViewController

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString *oldCode;

@end

NS_ASSUME_NONNULL_END
