//
//  ZXH5ShareVC.h
//  pzhixin
//
//  Created by zhixin on 2020/3/17.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXH5Share.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXH5ShareVC : UIViewController

@property (copy, nonatomic) void(^zxH5ShareVCShareSucceed) (void);

@property (strong, nonatomic) ZXH5Share *h5Share;

@end

NS_ASSUME_NONNULL_END
