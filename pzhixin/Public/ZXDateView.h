//
//  ZXDateView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXDateView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIButton *confirmBtn;

@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

NS_ASSUME_NONNULL_END
