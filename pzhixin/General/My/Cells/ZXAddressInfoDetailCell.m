//
//  ZXAddressInfoDetailCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/5.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressInfoDetailCell.h"
#import <Masonry/Masonry.h>

@implementation ZXAddressInfoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self createSubviews];
    [self.placeTextField setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 0) {
        [self.placeTextField setHidden:YES];
    } else {
        [self.placeTextField setHidden:NO];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressInfoDetailCellTextViewDidChange:)]) {
        [self.delegate addressInfoDetailCellTextViewDidChange:textView];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_detailTextView) {
        _detailTextView = [[UITextView alloc] init];
        [_detailTextView setFont:[UIFont systemFontOfSize:15.0]];
        [_detailTextView setTextColor:HOME_TITLE_COLOR];
//        [_detailTextView setScrollEnabled:NO];
        [_detailTextView setDelegate:self];
        [self.contentView addSubview:_detailTextView];
        [self.contentView sendSubviewToBack:_detailTextView];
        [_detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-20.0);
            make.top.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0.0);
            make.height.mas_equalTo(60.0).priorityHigh();
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
