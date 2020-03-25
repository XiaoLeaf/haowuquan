//
//  ZXDatePicker.h
//  pzhixin
//
//  Created by zhixin on 2019/11/6.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDatePicker : UIViewController

@property (copy, nonatomic) void(^zxDatePickerResultBlock)(NSString *result);

@end

NS_ASSUME_NONNULL_END
