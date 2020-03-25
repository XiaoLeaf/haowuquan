//
//  ZXDateView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDateView.h"
#import <Masonry/Masonry.h>

@interface ZXDateView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSMutableArray *yearList;
    NSMutableArray *monthList;
}

@end

@implementation ZXDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        yearList = [[NSMutableArray alloc] init];
        for (int i = 2019; i < 2019 + 12; i++) {
            [yearList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        monthList = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 12; i++) {
            [monthList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self createSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0.0);
        }];
    }
    
    UIView *topView = [[UIView alloc] init];
    [_mainView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(40.0);
    }];
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [topView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(80.0);
        }];
    }
    
    if (!_confirmBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [topView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(80.0);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
    [_mainView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0.0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_mainView addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(200.0);
            make.top.mas_equalTo(lineView.mas_bottom);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
    
//    if (!_datePicker) {
//        _datePicker = [[UIDatePicker alloc] init];
//        [_mainView addSubview:_datePicker];
//        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0.0);
//            make.height.mas_equalTo(200.0);
//            make.top.mas_equalTo(lineView.mas_bottom);
//            make.bottom.mas_equalTo(0.0).priorityHigh();
//        }];
//    }
}

#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 12;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREENWIDTH/2.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [yearList objectAtIndex:row];
    } else {
        return [monthList objectAtIndex:row];
    }
}

@end
